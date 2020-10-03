import 'package:epaisa_todo_app/features/authentication/domain/entities/fb_user.dart';
import 'package:flutter/material.dart';

class FbUserModel extends FbUser {
  FbUserModel({@required String uid, @required String email})
      : super(email: email, uid: uid);
}
