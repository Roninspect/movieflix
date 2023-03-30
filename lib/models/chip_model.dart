// ignore_for_file: public_member_api_docs, sort_constructors_first

class GenreModel {
  String label;
  GenreModel({
    required this.label,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'label': label,
    };
  }

  factory GenreModel.fromMap(Map<String, dynamic> map) {
    return GenreModel(
      label: map['label'] as String,
    );
  }
}
