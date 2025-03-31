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

  Reward({required this.id, this.name, this.description, this.price, this.stock, this.limit});

  factory Reward.fromMap(Map<String, dynamic> map) {
    return Reward(
      id: map['id'] as int,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] as int,
      stock: map['stock'] as int,
      limit: map['limit'] as int,
    );
  }
}
