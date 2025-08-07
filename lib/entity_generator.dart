
// 📁 lib/entity_generator.dart
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:entity_generator/annotations.dart';

class EntityGenerator extends GeneratorForAnnotation<GenerateEntity> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) return '';

    final className = element.name;
    final entityName = className.replaceAll('Model', 'Entity');
    final style = annotation.peek('style')?.stringValue ?? 'equatable';
    final buffer = StringBuffer();

    switch (style) {
      case 'freezed':
        buffer.writeln("import 'package:freezed_annotation/freezed_annotation.dart';");

        final entityFileName = buildStep.inputId.uri.pathSegments.last
            .replaceFirst('_model.dart', '_entity.freezed.dart');
        buffer.writeln("part '$entityFileName';");

        buffer.writeln('@freezed');
        buffer.writeln('class $entityName with _\$$entityName {');

        for (final field in element.fields.where((f) => !f.isStatic)) {
          final type = field.type.getDisplayString(withNullability: true);

          final docComment = field.documentationComment
              ?.replaceAll('///', '')
              .trim();
          if (docComment != null && docComment.isNotEmpty) {
            buffer.writeln('  /// $docComment');
          }

          buffer.writeln('  $type ${field.name};');
        }

        buffer.writeln();
        buffer.writeln('  $entityName({');
        for (final field in element.fields.where((f) => !f.isStatic)) {
          final type = field.type.getDisplayString(withNullability: true);
          final isNullable = type.endsWith('?');
          if (isNullable) {
            buffer.writeln('    this.${field.name},');
          } else {
            buffer.writeln(' required  this.${field.name},');
          }
        }
        buffer.writeln('  });');

        buffer.writeln('}');
        break;


      case 'equatable':
      default:
        buffer.writeln("import 'package:equatable/equatable.dart';");
        buffer.writeln("import 'package:copy_with_extension/copy_with_extension.dart';");
        buffer.writeln('');
        buffer.writeln('@CopyWith()');
        buffer.writeln('class $entityName extends Equatable {');

        for (final field in element.fields.where((f) => !f.isStatic)) {
          final type = field.type.getDisplayString(withNullability: true);
          buffer.writeln('  final $type ${field.name};');
        }

        buffer.writeln('\n  const $entityName({');
        for (final field in element.fields.where((f) => !f.isStatic)) {
          final type = field.type.getDisplayString(withNullability: true);
          final isNullable = type.endsWith('?');
          if (isNullable) {
            buffer.writeln('    this.${field.name},');
          } else {
            buffer.writeln('    required this.${field.name},');
          }
        }
        buffer.writeln('  });\n');

        // props
        buffer.writeln('  @override');
        buffer.writeln('  List<Object?> get props => [');
        for (final field in element.fields.where((f) => !f.isStatic)) {
          buffer.writeln('    ${field.name},');
        }
        buffer.writeln('  ];');

        buffer.writeln('\n  ${className} toModel() => $className(');
        for (final field in element.fields.where((f) => !f.isStatic)) {
          buffer.writeln('    ${field.name}: ${field.name},');
        }
        buffer.writeln('  );');

        buffer.writeln('}');
        break;
    }

    return buffer.toString();
  }
}
