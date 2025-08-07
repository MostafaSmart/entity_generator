import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';

import 'annotations.dart';

class ModelExtensionGenerator extends GeneratorForAnnotation<GenerateEntity> {
  @override
  String generateForAnnotatedElement(
      Element element,
      ConstantReader annotation,
      BuildStep buildStep,
      ) {
    if (element is! ClassElement) return '';

    final className = element.name;
    final entityName = className.replaceAll('Model', 'Entity');

    final buffer = StringBuffer();

    buffer.writeln('extension ${className}Extension on $className {');

    // دالة toEntity
    buffer.writeln('  $entityName toEntity() => $entityName(');
    for (final field in element.fields.where((f) => !f.isStatic)) {
      buffer.writeln('    ${field.name}: ${field.name},');
    }
    buffer.writeln('  );');

    // دالة fromEntity (factory)
    buffer.writeln();
    buffer.writeln('  static $className fromEntity($entityName entity) => $className(');
    for (final field in element.fields.where((f) => !f.isStatic)) {
      buffer.writeln('    ${field.name}: entity.${field.name},');
    }
    buffer.writeln('  );');

    buffer.writeln('}');

    return buffer.toString();
  }
}
