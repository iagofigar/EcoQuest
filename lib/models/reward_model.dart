// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

class Reward {
  final int id;
  String? name;
  String? description;
  int? price;
  int? stock;
  int? limit;

  Reward(this.id, this.name, this.description, this.price, this.stock, this.limit);

  // factory Movie.fromMap(Map<String, dynamic> map) {
  //   return Movie(
  //     id: map['id'] as int,
  //     title: map['title'] ?? '',
  //     posterPath: map['poster_path'] ?? '',
  //     backdropPath: map['backdrop_path'] ?? '',
  //     overview: map['overview'] ?? '',
  //     releaseDate: map['release_date'] ?? '',
  //     voteAverage: map['vote_average']?.toDouble() ?? 0.0,
  //     genreIds: List<int>.from(map['genre_ids']),
  //   );
  // }
}
