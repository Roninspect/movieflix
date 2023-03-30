import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class MovieModel {
  String id;
  String poster;
  String name;
  num rating;
  String movielink;
  String trailerlink;
  String description;
  String releaseDate;
  num length;
  bool isMovie;
  String studio;
  num viewCount;
  List<String> sequelof;
  List<String> genres;
  MovieModel({
    required this.id,
    required this.poster,
    required this.name,
    required this.rating,
    required this.movielink,
    required this.trailerlink,
    required this.description,
    required this.releaseDate,
    required this.length,
    required this.isMovie,
    required this.studio,
    required this.viewCount,
    required this.sequelof,
    required this.genres,
  });

  // factory MovieModel.fromMap(Map<String, dynamic> map) {
  //   final lengthInMinutes = (map['length'] as int) / 60000;
  //   return MovieModel(
  //     id: map['id'] as String,
  //     sequelof: map['sequelof'] as String,
  //     poster: map['poster'] as String,
  //     name: map['name'] as String,
  //     rating: num.parse(map['rating'].toString()),
  //     movielink: map['movielink'] as String,
  //     trailerlink: map['trailerlink'] as String,
  //     description: map['description'] as String,
  //     releaseDate: map['releaseDate'] as String,
  //     length: lengthInMinutes,
  //     studio: map['studio'] as String,
  //     viewCount: num.parse(map['viewCount'].toString()),
  //     isMovie: map['isMovie'] as bool,
  //     genres: List<String>.from(
  //         (map['genres'] as List<dynamic>).map((e) => e.toString())),
  //   );
  // }

  MovieModel copyWith({
    String? id,
    String? poster,
    String? name,
    num? rating,
    String? movielink,
    String? trailerlink,
    String? description,
    String? releaseDate,
    num? length,
    bool? isMovie,
    String? studio,
    num? viewCount,
    List<String>? sequelof,
    List<String>? genres,
  }) {
    return MovieModel(
      id: id ?? this.id,
      poster: poster ?? this.poster,
      name: name ?? this.name,
      rating: rating ?? this.rating,
      movielink: movielink ?? this.movielink,
      trailerlink: trailerlink ?? this.trailerlink,
      description: description ?? this.description,
      releaseDate: releaseDate ?? this.releaseDate,
      length: length ?? this.length,
      isMovie: isMovie ?? this.isMovie,
      studio: studio ?? this.studio,
      viewCount: viewCount ?? this.viewCount,
      sequelof: sequelof ?? this.sequelof,
      genres: genres ?? this.genres,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'poster': poster,
      'name': name,
      'rating': rating,
      'movielink': movielink,
      'trailerlink': trailerlink,
      'description': description,
      'releaseDate': releaseDate,
      'length': length,
      'isMovie': isMovie,
      'studio': studio,
      'viewCount': viewCount,
      'sequelof': sequelof,
      'genres': genres,
    };
  }

  factory MovieModel.fromMap(Map<String, dynamic> map) {
    final lengthInMinutes = (map['length'] as num) / 60000;
    return MovieModel(
      id: map['id'] as String,
      poster: map['poster'] as String,
      name: map['name'] as String,
      rating: map['rating'] as num,
      movielink: map['movielink'] as String,
      trailerlink: map['trailerlink'] as String,
      description: map['description'] as String,
      releaseDate: map['releaseDate'] as String,
      length: lengthInMinutes,
      isMovie: map['isMovie'] as bool,
      studio: map['studio'] as String,
      viewCount: num.parse(map['viewCount'].toString()),
      sequelof: List<String>.from(
          (map['sequelof'] as List<dynamic>).map((e) => e.toString())),
      genres: List<String>.from(
          (map['genres'] as List<dynamic>).map((e) => e.toString())),
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieModel.fromJson(String source) =>
      MovieModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MovieModel(id: $id, poster: $poster, name: $name, rating: $rating, movielink: $movielink, trailerlink: $trailerlink, description: $description, releaseDate: $releaseDate, length: $length, isMovie: $isMovie, studio: $studio, viewCount: $viewCount, sequelof: $sequelof, genres: $genres)';
  }

  @override
  bool operator ==(covariant MovieModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.poster == poster &&
        other.name == name &&
        other.rating == rating &&
        other.movielink == movielink &&
        other.trailerlink == trailerlink &&
        other.description == description &&
        other.releaseDate == releaseDate &&
        other.length == length &&
        other.isMovie == isMovie &&
        other.studio == studio &&
        other.viewCount == viewCount &&
        other.sequelof == sequelof &&
        listEquals(other.genres, genres);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        poster.hashCode ^
        name.hashCode ^
        rating.hashCode ^
        movielink.hashCode ^
        trailerlink.hashCode ^
        description.hashCode ^
        releaseDate.hashCode ^
        length.hashCode ^
        isMovie.hashCode ^
        studio.hashCode ^
        viewCount.hashCode ^
        sequelof.hashCode ^
        genres.hashCode;
  }
}
