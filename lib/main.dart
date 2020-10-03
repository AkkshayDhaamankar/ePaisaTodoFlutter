import 'package:epaisa_todo_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:epaisa_todo_app/features/authentication/presentation/pages/splash_page.dart';
import 'package:epaisa_todo_app/features/authentication/presentation/pages/welcome_page.dart';
import 'package:epaisa_todo_app/features/todo_screen/presentation/pages/todo_home.dart';
import 'package:epaisa_todo_app/injection_container.dart' as di;
import 'package:epaisa_todo_app/injection_container.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/authentication/presentation/create_and_sign_bloc/bloc/create_user_bloc.dart';
import 'features/authentication/presentation/create_and_sign_bloc/bloc/sign_in_user_bloc.dart';
import 'features/authentication/presentation/pages/sign_up.dart';
import 'features/todo_screen/presentation/add_todo_bloc/bloc/add_todo_bloc.dart';
import 'features/todo_screen/presentation/delete_todo_bloc/bloc/delete_todo_bloc.dart';
import 'features/todo_screen/presentation/update_todo/bloc/update_todo_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<CreateUserBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AddTodoBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<UpdateTodoBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<DeleteTodoBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<SignInUserBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'ePaisa Todo App',
        //home: HomeController(),
        routes: <String, WidgetBuilder>{
          '/signUp': (BuildContext context) =>
              SignUpView(authFormType: AuthFormType.signUp),
          '/signIn': (BuildContext context) =>
              SignUpView(authFormType: AuthFormType.signIn),
          //'/home': (BuildContext context) => HomeController(),
          '/home': (BuildContext context) => HomeController(),
          '/todo': (BuildContext context) => TodoHome(
                fbUser: serviceLocator(),
              ),
        },
        home: HomeController(),
      ),
    );
  }
}

class HomeController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeControllerState();
  }
}

class _HomeControllerState extends State<HomeController> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(AppStarted());
  }

  @override
  Widget build(Object context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Uninitialized) {
          return SplashPage();
        }
        if (state is Authenticated) {
          return TodoHome(fbUser: state.fbUser);
        }
        if (state is Unauthenticated) {
          return WelcomePage();
        }
      },
    );
  }
}
