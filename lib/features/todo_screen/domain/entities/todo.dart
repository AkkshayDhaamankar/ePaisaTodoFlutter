import 'dart:io';

import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';

class Todo extends Equatable {
  final String uid;
  final String title;
  final String description;
  final String date;
  final File image;
  final String imageUrl;
  final String todoId;
  Todo({
    @required this.uid,
    @required this.title,
    @required this.description,
    @required this.date,
    this.image,
    this.todoId,
    this.imageUrl,
  });

  @override
  List<Object> get props =>
      [uid, title, description, date, image, todoId, imageUrl];
}
