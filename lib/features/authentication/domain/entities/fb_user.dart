import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';

class FbUser extends Equatable {
  final String uid;
  final String email;
  FbUser({@required this.uid, @required this.email});

  @override
  List<Object> get props => [uid, email];
}
