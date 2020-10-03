import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epaisa_todo_app/core/network/firestore_service.dart';
import 'package:epaisa_todo_app/features/authentication/domain/entities/fb_user.dart';
import 'package:epaisa_todo_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:epaisa_todo_app/features/todo_screen/domain/entities/todo.dart';
import 'package:epaisa_todo_app/features/todo_screen/presentation/delete_todo_bloc/bloc/delete_todo_bloc.dart';
import 'package:epaisa_todo_app/features/todo_screen/presentation/widgets/add_todo_dialog.dart';
import 'package:epaisa_todo_app/features/todo_screen/presentation/widgets/update_todo_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoHome extends StatelessWidget {
  final FbUser fbUser;

  const TodoHome({Key key, this.fbUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ePaisa Todo"),
          actions: [
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(LoggedOut());
                })
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: () {
            print('SHow Dialog Pressed');
            print(context);

            showDialog(
                context: context,
                builder: (BuildContext context) => AddTodoDialog(
                      uid: fbUser.uid,
                      todoContext: context,
                    ));
          },
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirestoreService.getAllTodo(fbUser.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return new ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return Dismissible(
                  background: Container(color: Colors.black45),
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    BlocProvider.of<DeleteTodoBloc>(context).add(DeleteTodoItem(
                        todoId: document.id, uid: document.data()['uid']));
                    // setState(() {
                    //   items.removeAt(index);
                    // });
                    // FirestoreService.deleteTodoItem(
                    //     document.data()['uid'], document.id);

                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(document.data()['title'] + " removed")));
                  },
                  child: ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => UpdateTodoDialog(
                                uid: fbUser.uid,
                                todoContext: context,
                                todoItem: Todo(
                                  uid: fbUser.uid,
                                  title: document.data()['title'],
                                  description: document.data()['description'],
                                  date: document.data()['date'],
                                  imageUrl: document.data()['image'],
                                  todoId: document.id,
                                ),
                              ));
                    },
                    title: Text(document.data()['title']),
                    subtitle: Text(document.data()['description']),
                    leading: document.data()['image'] != null
                        ? ClipOval(
                            child: Image.network(
                              document.data()['image'],
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            width: 30,
                            height: 30,
                            child: IconButton(
                                icon: Icon(Icons.no_photography),
                                onPressed: () {}),
                          ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Expiry:"),
                        Text(document.data()['date'])
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ));
  }
}
