import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:epaisa_todo_app/features/todo_screen/presentation/add_todo_bloc/bloc/add_todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddTodoDialog extends StatefulWidget {
  final String uid;
  final BuildContext todoContext;
  AddTodoDialog({
    @required this.uid,
    this.todoContext,
  });
  @override
  State<StatefulWidget> createState() => AddTodoDialogState(
        uid: uid,
        todoContext: todoContext,
      );
}

class AddTodoDialogState extends State<AddTodoDialog> {
  final primaryColor = const Color(0xFF75A2EA);
  final grayColor = const Color(0xFF939393);
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String uid;
  final BuildContext todoContext;

  AddTodoDialogState({
    this.todoContext,
    @required this.uid,
  });

  static const double padding = 20.0;
  String _title, _description, _date;
  File _image;

  void setImage(File imagePicked) {
    setState(() {
      _image = imagePicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      child: AddTodoBuilder(
        padding: padding,
        buildInputs: buildInputs(context),
      ),
    );
  }

/*..
 * !Add Dialog Views
 */

  List<Widget> buildInputs(BuildContext context) {
    List<Widget> textFields = [];
    textFields.add(SizedBox(height: 20));
    textFields.add(
      TextField(
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
          initialDate: DateTime(2020, 10, 02),
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
        _image != null
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
                  final _imageValue =
                      await ImagePicker().getImage(source: ImageSource.gallery);
                  setImage(File(_imageValue.path));
                }),
        _image != null
            ? IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  setImage(null);
                })
            : Container()
      ],
    ));

    textFields.add(SizedBox(height: 20));
    textFields.add(showAddButton(context));
    return textFields;
  }

/*
 * ! Submit 
 */
  showAddButton(BuildContext context) {
    return FlatButton(
      minWidth: double.maxFinite,
      color: primaryColor,
      child: AutoSizeText(
        "Submit",
        maxLines: 1,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
      onPressed: () {
        print(_title);

        BlocProvider.of<AddTodoBloc>(context).add(AddTodoItem(
            uid: uid,
            title: _title,
            description: _description,
            date: _date,
            image: _image ?? null));
      },
    );
  }
}

/*
 * !Add ToDo Builder
 */
class AddTodoBuilder extends StatelessWidget {
  final List<Widget> buildInputs;
  const AddTodoBuilder({
    Key key,
    @required this.padding,
    @required this.buildInputs,
  }) : super(key: key);

  final double padding;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTodoBloc, AddTodoState>(builder: (context, state) {
      if (state is AddTodoLoading) {
        return Container(
            width: 50,
            height: 80,
            child: Center(child: CircularProgressIndicator()));
      }

      if (state is AddTodoSuccess) {
        Navigator.of(context).pop();
        return Container(
          width: 0,
          height: 0,
        );
      }
      if (state is ErrorAddTodo) {
        return ErrorAddTodoWidget(
          message: state.message,
        );
      }
      if (state is AddTodoInitial) {
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
      return Container(
        width: 0,
        height: 0,
      );
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

class ErrorAddTodoWidget extends StatelessWidget {
  final String message;
  final BuildContext context;
  const ErrorAddTodoWidget({Key key, this.message, this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(message),
    );
  }
}
