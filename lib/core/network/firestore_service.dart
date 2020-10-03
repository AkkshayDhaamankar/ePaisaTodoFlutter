import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epaisa_todo_app/features/todo_screen/data/models/todo_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  static StorageReference storageReference = FirebaseStorage.instance.ref();
  static CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  static Future<void> addUser(String email, String uid) async {
    // Call the user's CollectionReference to add a new user
    return await users
        .doc(uid)
        .set({
          'userUid': uid,
          'userEmail': email,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static Future<String> _addImageToFirebase(File _image, String uid) async {
    String downloadUrl1;
    //CreateRefernce to path.
    StorageReference ref = storageReference.child("todoImages/" + uid);

    //StorageUpload task is used to put the data you want in storage
    //Make sure to get the image first before calling this method otherwise _image will be null.

    StorageUploadTask storageUploadTask =
        ref.child("image.jpg" + DateTime.now().toString()).putFile(_image);

    if (storageUploadTask.isSuccessful || storageUploadTask.isComplete) {
      final String url = await ref.getDownloadURL();
      print("The download URL is " + url);
    } else if (storageUploadTask.isInProgress) {
      storageUploadTask.events.listen((event) {
        double percentage = 100 *
            (event.snapshot.bytesTransferred.toDouble() /
                event.snapshot.totalByteCount.toDouble());
        print("THe percentage " + percentage.toString());
      });

      StorageTaskSnapshot storageTaskSnapshot =
          await storageUploadTask.onComplete;
      downloadUrl1 = await storageTaskSnapshot.ref.getDownloadURL();

      //Here you can get the download URL when the task has been completed.
      print("Download URL " + downloadUrl1.toString());
      return downloadUrl1;
    } else {
      //Catch any cases here that might come up like canceled, interrupted
    }
  }

  static Stream getAllTodo(String uid) {
    Stream todoStream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('todo')
        .snapshots();
    return todoStream;
  }

  static Future<TodoModel> addTodoItem(String uid, String title,
      String description, String date, File image) async {
    String imageUrl;
    String todoId;
    // Call the user's CollectionReference to add a new user
    if (image != null) {
      imageUrl = await _addImageToFirebase(image, uid);
    }
    await users
        .doc(uid)
        .collection("todo")
        .add({
          'uid': uid,
          'title': title,
          'description': description,
          'date': date,
          'image': imageUrl ?? null
        })
        .then((value) => {todoId = value.id})
        .catchError((error) => print("Failed to add user: $error"));

    return TodoModel(
        uid: uid,
        title: title,
        description: description,
        date: date,
        imageUrl: imageUrl ?? null,
        todoId: todoId);
  }

  static Future<TodoModel> updateTodoItem(
      String uid,
      String title,
      String description,
      String date,
      File image,
      String imageUrlOld,
      String todoId) async {
    String imageUrl;
    // Call the user's CollectionReference to add a new user
    if (image != null) {
      imageUrl = await _addImageToFirebase(image, uid);
    }
    await users.doc(uid).collection("todo").doc(todoId).set({
      'uid': uid,
      'title': title,
      'description': description,
      'date': date,
      'image': imageUrl != null ? imageUrl : imageUrlOld ?? null
    }).catchError((error) => print("Failed to add user: $error"));

    return TodoModel(
        uid: uid,
        title: title,
        description: description,
        date: date,
        imageUrl: imageUrl ?? null,
        todoId: todoId);
  }

  static Future<TodoModel> deleteTodoItem(String uid, String todoId) async {
    CollectionReference todo = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('todo');

    await todo
        .doc(todoId)
        .delete()
        .catchError((error) => print("Failed to add user: $error"));

    return TodoModel(
        uid: uid, todoId: todoId, date: '', description: '', title: '');
  }
}
