// 📁 lib/builder.dart

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'entity_generator.dart';
import 'model_extension_generator.dart';


Builder entityBuilder(BuilderOptions options) =>
    LibraryBuilder(EntityGenerator(), generatedExtension: '.entity.dart');

Builder modelExtensionBuilder(BuilderOptions options) =>
    LibraryBuilder(ModelExtensionGenerator(), generatedExtension: '.entity_extension.dart');
