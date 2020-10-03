import 'dart:io';
import 'package:epaisa_todo_app/features/todo_screen/domain/entities/todo.dart';
import 'package:flutter/material.dart';

class TodoModel extends Todo {
  final String uid;
  final String title;
  final String description;
  final String date;
  final File image;
  final String todoId;
  final String imageUrl;
  TodoModel({
    @required this.uid,
    @required this.title,
    @required this.description,
    @required this.date,
    this.image,
    this.todoId,
    this.imageUrl,
  }) : super(
            date: date,
            image: image,
            imageUrl: imageUrl,
            title: title,
            description: description,
            todoId: todoId,
            uid: uid);
}
