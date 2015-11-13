// Copyright (c) 2015, the Dogma Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

/// Contains the [ModelConverterGenerator] class.
library dogma_codegen.src.codegen.converter_generator;

//---------------------------------------------------------------------
// Imports
//---------------------------------------------------------------------

import 'package:dogma_codegen/metadata.dart';

import 'argument_buffer.dart';
import 'annotation_generator.dart';
import 'builtin_generator.dart';
import 'constructor_generator.dart';
import 'class_generator.dart';
import 'field_generator.dart';
import 'function_generator.dart';
import 'type_generator.dart';

//---------------------------------------------------------------------
// Library contents
//---------------------------------------------------------------------

void generateConverter(ConverterMetadata metadata,
                       ModelMetadata model,
                       StringBuffer buffer,
                      {Map<String, FunctionMetadata> functions}) {
  functions ??= <String, FunctionMetadata>{};

  generateClassDefinition(
      metadata,
      buffer,
      _generateConverterDefinition(model, functions)
  );
}


ClassGenerator _generateConverterDefinition(ModelMetadata model,
                                            Map<String, FunctionMetadata> functions) {
  return (ConverterMetadata metadata, StringBuffer buffer) {
    // Generate the fields
    generateFields(metadata.fields, buffer);

    // Generate the constructors
    for (var constructor in metadata.constructors) {
      if (constructor.isDefault) {
        generateConstructorDefinition(
            constructor,
            buffer,
            initializerListGenerator: _generateInitializeList(metadata)
        );
      } else {
        generateFinalContructor(constructor, buffer);
      }
    }

    // Generate the create function
    var createMethod = metadata.methods.firstWhere(
        (method) => method.name == 'create', orElse: () => null);

    if (createMethod != null) {
      generateFunctionDefinition(
          createMethod,
          buffer,
          _generateCreateMethod,
          annotationGenerators: [generateOverrideAnnotation],
          useArrow: true
      );
    }

    // Generate the convert function
    var convertMethod = metadata.methods.firstWhere(
        (method) => method.name == 'convert');

    generateFunctionDefinition(
        convertMethod,
        buffer,
        _generateConvertMethod(metadata, model, functions),
        annotationGenerators: [generateOverrideAnnotation]
    );
  };
}

ConstructorGenerator _generateInitializeList(ConverterMetadata converter) {
  return (ConstructorMetadata metadata, StringBuffer buffer) {
    var decoder = converter.isDecoder;
    var argumentBuffer = new ArgumentBuffer();

    for (var field in converter.fields) {
      var modelType = field.type.arguments[decoder ? 1 : 0];
      var name = ConverterMetadata.defaultConverterName(modelType, decoder);
      argumentBuffer.write('${field.name} = new $name()');
    }

    buffer.write(argumentBuffer.toString());
  };
}

void _generateCreateMethod(FunctionMetadata metadata, StringBuffer buffer) {
  buffer.write(generateConstructorCall(metadata.returnType));
  buffer.write(';');
}

FunctionGenerator _generateConvertMethod(ConverterMetadata converter,
                                         ModelMetadata model,
                                         Map<String, FunctionMetadata> functions) {
  return (FunctionMetadata metadata, StringBuffer buffer) {
    var decoder = converter.isDecoder;
    var inputVar = metadata.parameters[0].name;
    var outputVar;
    var modelVar;
    var mapVar;

    // Initialize the model variable
    if (decoder) {
      outputVar = metadata.parameters[1].name;
      modelVar = outputVar;
      mapVar = inputVar;

      buffer.writeln('$outputVar??=create();');
    } else {
      outputVar = 'model';
      modelVar = inputVar;
      mapVar = outputVar;

      buffer.writeln('var $outputVar={};');
    }

    buffer.writeln();

    for (SerializableFieldMetadata field in model.fields) {
      var fieldType = field.type;
      var fieldName = field.name;

      // See if the field should be outputted
      var shouldOutput = decoder ? field.decode : field.encode;

      if (!shouldOutput) {
        continue;
      }

      // Get what values are on the left and right hand side of the assignment
      var modelAccess = '$modelVar.${field.name}';
      var mapAccess = '$mapVar[\'${field.serializationName}\']';
      var lhsAccess;
      var rhsAccess;

      if (decoder) {
        lhsAccess = modelAccess;
        rhsAccess = mapAccess;
      } else {
        lhsAccess = mapAccess;
        rhsAccess = modelAccess;
      }

      // See if explicit conversion was requested
      var explicitConvert = decoder ? field.decodeUsing : field.encodeUsing;

      if (explicitConvert != null) {
        var function = functions[explicitConvert];
        var convertValue = _generateConvertCall(
            function,
            '',
            rhsAccess
        );

        buffer.writeln('$lhsAccess = $convertValue;');

        continue;
      }

      // Get optional values
      var isOptional = field.optional;
      var defaultValue = field.defaultsTo;

      if ((decoder) && (fieldType.isBuiltin)) {
        var rhs = _generateValueConversion(
            rhsAccess,
            fieldName,
            fieldType,
            buffer,
            converter,
            functions
        );

        // Write the expression
        buffer.write('$modelAccess = $rhs');

        // Add a cast for strong mode if required
        var shouldCast = _shouldCast(fieldType);

        if (shouldCast) {
          buffer.write(' ${generateCast(fieldType)}');
        }

        if ((isOptional) && (defaultValue != null)) {
          buffer.write('??');

          if (shouldCast) {
            buffer.write(generateTypeArguments(fieldType));
          }

          buffer.write(generateBuiltin(defaultValue));
        }

        buffer.write(';');
      } else {
        if (isOptional) {
          buffer.writeln('var $fieldName=$rhsAccess;');
          buffer.writeln('if($fieldName!=null){');
          rhsAccess = fieldName;
        }

        var rhs = _generateValueConversion(
            rhsAccess,
            fieldName,
            fieldType,
            buffer,
            converter,
            functions
        );

        buffer.writeln('$lhsAccess=$rhs;');

        if (isOptional) {
          buffer.writeln('}');
        }
      }
    }

    // Return the value
    buffer.writeln('\nreturn $outputVar;');
  };
}

/// Generates the source code for converting a value.
String _generateValueConversion(String access,
                               String varName,
                               TypeMetadata type,
                               StringBuffer buffer,
                               ConverterMetadata converter,
                               Map<String, FunctionMetadata> functions,
                              [int depth = 0]) {
  // Create the variable names for any temporary values
  var tempVar = '${varName}Temp$depth';
  var valueVar = '${varName}Value$depth';
  var keyVar = '${varName}Key$depth';

  // Increase the depth
  ++depth;

  // Get whether the converter is a decoder
  var decoder = converter.isDecoder;

  if (type.isBuiltin) {
    return access;
  } else if (type.isList) {
    var genericType = decoder ? generateTypeArguments(type) : '';

    buffer.writeln('var $tempVar=$genericType[];');
    buffer.writeln('for (var $valueVar in $access){');

    var value = _generateValueConversion(
        valueVar,
        varName,
        type.arguments[0],
        buffer,
        converter,
        functions,
        depth
    );

    buffer.writeln('$tempVar.add($value);');
    buffer.writeln('}');

    return tempVar;
  } else if (type.isMap) {
    // Currently assuming this is a valid JSON construct
    //
    // This means that the type of the key has to be be a builtin type. For
    // example a JSON can't be created from a Map<Map<String, Map>, dynamic>.
    var key = _generateValueConversion(
        keyVar,
        varName,
        type.arguments[0],
        buffer,
        converter,
        functions,
        depth
    );

    var genericType = decoder ? generateTypeArguments(type) : '';

    buffer.writeln('var $tempVar=$genericType{};');
    buffer.writeln('$access.forEach(($keyVar,$valueVar){');

    var value = _generateValueConversion(
        valueVar,
        varName,
        type.arguments[1],
        buffer,
        converter,
        functions,
        depth
    );

    buffer.writeln('$tempVar[$key]=$value;');
    buffer.writeln('});');

    return tempVar;
  } else {
    var instance = '';

    // See if a function is being used
    var convertUsing = functions[type.name];

    if (convertUsing != null) {
      // Check for a method to see if instance should be set
      if (convertUsing is MethodMetadata) {
        instance = access;
      }
    } else {
      convertUsing = new MethodMetadata('convert', new TypeMetadata.map());

      var modelPosition = converter.isDecoder ? 1 : 0;

      // See if the value is the same type as the converter
      instance = (converter.modelType == type)
          ? 'this'
          : converter.fields.firstWhere(
                (field) => field.type.arguments[modelPosition] == type
            ).name;
    }

    return _generateConvertCall(convertUsing, instance, access);
  }
}

String _generateConvertCall(FunctionMetadata function,
                            String instance,
                            String convert,
                           {String defaultsTo}) {
  var name = function.name;

  if (function is MethodMetadata) {
    if (name == 'convert') {
      return '$instance.$name($convert)';
    } else {
      return '$convert.$name()';
    }
  } else {
    return '$name($convert)';
  }
}

/// Determines if the given type [metadata] requires a cast for strong mode
/// support.
bool _shouldCast(TypeMetadata metadata) {
  var arguments = metadata.arguments;
  var argumentCount = arguments.length;

  if (metadata.isList) {
    if (argumentCount != 0) {
      // For some reason List<String> doesn't seem to trigger strong mode
      return !metadata.arguments[0].isString;
    }
  } else if (metadata.isMap) {
    if (argumentCount != 0) {
      return true;
    }
  }

  return !metadata.isBuiltin;
}
