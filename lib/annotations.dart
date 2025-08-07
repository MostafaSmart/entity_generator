// 📁 lib/annotations.dart
class GenerateEntity {
  final String style; // "equatable" or "freezed"
  const GenerateEntity({this.style = 'equatable'});
}

const generateEntity = GenerateEntity();

