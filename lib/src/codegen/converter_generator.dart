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

import 'annotation_generator.dart';
import 'builtin_generator.dart';
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
  functions ??= new Map<String, FunctionMetadata>();

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

      buffer.writeln('$outputVar ??= create();');
    } else {
      outputVar = 'model';
      modelVar = inputVar;
      mapVar = outputVar;

      buffer.writeln('var $outputVar = {};');
    }

    buffer.writeln();

    for (SerializableFieldMetadata field in model.fields) {
      var fieldType = field.type;
      var fieldName = field.name;
      var isOptional = field.optional;

      // See if the field should be outputted
      var shouldOutput = decoder ? field.decode : field.encode;

      if (!shouldOutput) {
        continue;
      }

      var modelAccess = '$modelVar.${field.name}';
      var mapAccess = '$mapVar[\'${field.serializationName}\']';

      if (fieldType.isBuiltin) {
        if (decoder) {
          buffer.write('$modelAccess = $mapAccess');

          // See if a default value should be set
          var defaultValue = field.defaultsTo;

          if ((isOptional) && (defaultValue != null)) {
            buffer.write('?? ${generateBuiltin(defaultValue)}');
          }

          buffer.writeln(';');
        } else {
          if (isOptional) {
            buffer.writeln('var $fieldName = $modelAccess;');
            buffer.writeln('if ($fieldName != null) {');
            modelAccess = fieldName;
          }

          buffer.writeln('$mapAccess = $modelAccess;');

          if (isOptional) {
            buffer.writeln('}');
          }
        }
      } else {
        var isList = fieldType.isList;
        var isMap = fieldType.isMap;

        // Determine if a function should be used
        var typeName = _getCustomType(fieldType).name;
        var convertUsing = functions[typeName];
        var converterVar;

        if (convertUsing == null) {
          convertUsing = new MethodMetadata('convert', new TypeMetadata.map());

          if (model.type.name == typeName) {
            converterVar = 'this';
          } else {
            var modelPosition = decoder ? 1 : 0;

            converterVar = converter.fields.firstWhere(
                (field) => field.type.arguments[modelPosition].name == typeName).name;
          }
        }

        if (decoder) {
          var decodeValue;

          if (isList) {
            buffer.writeln('var $fieldName = ${generateConstructorCall(fieldType)};');

            var tempName = 'value';
            var convertCall = _generateConvertCall(
                convertUsing,
                converterVar,
                tempName
            );

            buffer.writeln('for (var $tempName in $mapAccess){');
            buffer.writeln('$fieldName.add($convertCall);');
            buffer.writeln('}');

            decodeValue = fieldName;
          } else if (isMap) {
            buffer.writeln('var $fieldName = ${generateConstructorCall(fieldType)}');

            decodeValue = fieldName;
          } else {
            decodeValue = _generateConvertCall(
                convertUsing,
                converterVar,
                mapAccess,
                defaultsTo: modelVar
            );
          }

          buffer.writeln('$modelAccess = $decodeValue;');
        } else {
          var encodeValue;

          if (isList) {
            buffer.writeln('var $fieldName = new List<${convertUsing.returnType.name}>();');

            var tempName = 'value';
            var convertCall = _generateConvertCall(
                convertUsing,
                converterVar,
                tempName
            );

            buffer.writeln('for (var $tempName in $modelAccess){');
            buffer.writeln('$fieldName.add($convertCall);');
            buffer.writeln('}');

            encodeValue = fieldName;
          } else if (isMap) {

          } else {
            encodeValue = _generateConvertCall(
                convertUsing,
                converterVar,
                modelAccess
            );
          }

          buffer.writeln('$mapAccess = $encodeValue;');
        }
      }
    }

    // Return the value
    buffer.writeln('\nreturn $outputVar;');
  };
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

/// Gets the custom type that will be used in conversion from the [metadata].
TypeMetadata _getCustomType(TypeMetadata metadata) {
  if (metadata.isList) {
    return _getCustomType(metadata.arguments[0]);
  } else if (metadata.isMap) {
    return _getCustomType(metadata.arguments[1]);
  } else {
    return metadata;
  }
}
