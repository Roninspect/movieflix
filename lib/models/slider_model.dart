// ignore_for_file: public_member_api_docs, sort_constructors_first

class SliderModel {
  String title;
  num rating;
  String poster;
  SliderModel({
    required this.title,
    required this.rating,
    required this.poster,
  });

  SliderModel copyWith({
    String? title,
    num? rating,
    String? poster,
  }) {
    return SliderModel(
      title: title ?? this.title,
      rating: rating ?? this.rating,
      poster: poster ?? this.poster,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'rating': rating,
      'poster': poster,
    };
  }

  factory SliderModel.fromMap(Map<String, dynamic> map) {
    return SliderModel(
      title: map['title'] as String,
      rating: map['rating'] as num,
      poster: map['poster'] as String,
    );
  }
}
