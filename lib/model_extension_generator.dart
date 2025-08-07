import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
// استخدم مكتبة element2 الجديدة
import 'package:analyzer/dart/element/element2.dart';

import 'annotations.dart';

class ModelExtensionGenerator extends GeneratorForAnnotation<GenerateEntity> {
  @override
  String generateForAnnotatedElement(
      Element2 element,
      ConstantReader annotation,
      BuildStep buildStep,
      ) {
    if (element is! ClassElement2) return '';

    final className = element.name3;
    final entityName = className?.replaceAll('Model', 'Entity');

    final buffer = StringBuffer();

    buffer.writeln('extension ${className}Extension on $className {');

    // دالة toEntity
    buffer.writeln('  $entityName toEntity() => $entityName(');
    for (final field in element.fields2.where((f) => !f.isStatic)) {
      buffer.writeln('    ${field.name3}: ${field.name3},');
    }
    buffer.writeln('  );');

    // دالة fromEntity (factory)
    buffer.writeln();
    buffer.writeln('  static $className fromEntity($entityName entity) => $className(');
    for (final field in element.fields2.where((f) => !f.isStatic)) {
      buffer.writeln('    ${field.name3}: entity.${field.name3},');
    }
    buffer.writeln('  );');

    buffer.writeln('}');

    return buffer.toString();
  }
}
