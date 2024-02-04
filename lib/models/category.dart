//Describe the data structure for a category
//enum for the categories

import 'package:flutter/material.dart';

enum Categories {
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other
}


class Category {
  Category( this.category, this.color);

  final String category;
  final Color color;
  
}