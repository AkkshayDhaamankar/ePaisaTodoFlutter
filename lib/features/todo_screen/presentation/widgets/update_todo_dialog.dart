import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:epaisa_todo_app/features/todo_screen/domain/entities/todo.dart';
import 'package:epaisa_todo_app/features/todo_screen/presentation/update_todo/bloc/update_todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UpdateTodoDialog extends StatefulWidget {
  final String uid;
  final BuildContext todoContext;
  final Todo todoItem;

  UpdateTodoDialog({
    @required this.uid,
    this.todoContext,
    this.todoItem,
  });
  @override
  State<StatefulWidget> createState() => UpdateTodoDialogState(
        uid: uid,
        todoContext: todoContext,
        todoItem: todoItem,
      );
}

class UpdateTodoDialogState extends State<UpdateTodoDialog> {
  final primaryColor = const Color(0xFF75A2EA);
  final grayColor = const Color(0xFF939393);
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String uid;
  final BuildContext todoContext;

  final Todo todoItem;
  UpdateTodoDialogState({
    this.todoItem,
    this.todoContext,
    @required this.uid,
  });

  static const double padding = 20.0;
  String _title, _description, _date;
  File _image;
  bool imageUrlExistsVar = false;

  void setImage(File imagePicked) {
    setState(() {
      _image = imagePicked;
    });
  }

  void setImageUrlBool(bool value) {
    setState(() {
      imageUrlExistsVar = value;
      _image = null;
    });
  }

  @override
  void initState() {
    imageUrlExistsVar = todoItem.imageUrl != null ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(padding),
        ),
        child: UpdateTodoBuilder(
          padding: padding,
          buildInputs: buildInputsUpdate(context),
        ));
  }

/*
 * !Update Dialog Views
 */
  List<Widget> buildInputsUpdate(BuildContext context) {
    List<Widget> textFields = [];
    List<String> preDate = todoItem.date.split("-");
    textFields.add(SizedBox(height: 20));
    textFields.add(
      TextField(
        controller: TextEditingController(text: todoItem.title),
        style: TextStyle(fontSize: 22.0),
        decoration: buildSignUpInputDecoration("Title"),
        onChanged: (value) {
          _title = value;
        },
      ),
    );
    textFields.add(SizedBox(height: 15));

    textFields.add(
      TextField(
        controller: TextEditingController(text: todoItem.description),
        style: TextStyle(fontSize: 22.0),
        decoration: buildSignUpInputDecoration("Description"),
        onChanged: (value) {
          _description = value;
        },
      ),
    );
    textFields.add(SizedBox(height: 15));
    textFields.add(
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: InputDatePickerFormField(
          initialDate: DateTime(int.parse(preDate[0]), int.parse(preDate[1]),
              int.parse(preDate[2])),
          onDateSubmitted: (value) {
            _date = formatter.format(value);
          },
          onDateSaved: (value) {
            _date = formatter.format(value);
          },
          firstDate: DateTime(2020),
          lastDate: DateTime(2020, 12, 12),
        ),
      ),
    );
    textFields.add(SizedBox(height: 20));

    textFields.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Select Image"),
        imageUrlExistsVar
            ? ClipOval(
                child: Image.network(
                todoItem.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ))
            : _image != null
                ? ClipOval(
                    child: Image.file(
                    _image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ))
                : IconButton(
                    icon: Icon(
                      Icons.add_a_photo,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      final _imageValue = await ImagePicker()
                          .getImage(source: ImageSource.gallery);
                      setImage(File(_imageValue.path));
                    }),
        (imageUrlExistsVar || _image != null)
            ? IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  setImageUrlBool(false);
                })
            : Container()
      ],
    ));

    textFields.add(SizedBox(height: 20));
    textFields.add(showAddButton(context));
    return textFields;
  }

/*
 * ! Submit and Update Button
 */
  showAddButton(BuildContext context) {
    return FlatButton(
      minWidth: double.maxFinite,
      color: primaryColor,
      child: AutoSizeText(
        "Update",
        maxLines: 1,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
      onPressed: () {
        print(_title);
        BlocProvider.of<UpdateTodoBloc>(context).add(UpdateTodoItem(
            uid: uid,
            title: _title ?? todoItem.title,
            description: _description ?? todoItem.description,
            date: _date ?? todoItem.date,
            image: _image ?? null,
            imageUrl: _image != null
                ? null
                : imageUrlExistsVar
                    ? todoItem.imageUrl
                    : null,
            todoId: todoItem.todoId));
      },
    );
  }
}

/*
 * !Update ToDo Builder
 */
class UpdateTodoBuilder extends StatelessWidget {
  final List<Widget> buildInputs;
  const UpdateTodoBuilder({
    Key key,
    @required this.padding,
    @required this.buildInputs,
  }) : super(key: key);

  final double padding;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateTodoBloc, UpdateTodoState>(
        builder: (context, state) {
      if (state is UpdateTodoLoading) {
        return Container(
            width: 50,
            height: 80,
            child: Center(child: CircularProgressIndicator()));
      }

      if (state is UpdateTodoSuccess) {
        Navigator.of(context).pop();
        return Container(
          width: 0,
          height: 0,
        );
      }
      if (state is ErrorUpdateTodo) {
        return ErrorUpdateTodoWidget(
          message: state.message,
        );
      }
      if (state is UpdateTodoInitial) {
        return Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(padding),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ]),
              child:
                  Column(mainAxisSize: MainAxisSize.min, children: buildInputs),
            ),
          ],
        );
      }
    });
  }
}

InputDecoration buildSignUpInputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    focusColor: Colors.white,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 0.0)),
    contentPadding: const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
  );
}

class ErrorUpdateTodoWidget extends StatelessWidget {
  final String message;
  final BuildContext context;
  const ErrorUpdateTodoWidget({Key key, this.message, this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(message),
    );
  }
}
