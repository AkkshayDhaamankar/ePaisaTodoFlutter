import 'package:epaisa_todo_app/features/authentication/data/datasources/fb_auth_data_source.dart';
import 'package:epaisa_todo_app/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:epaisa_todo_app/features/authentication/domain/entities/fb_user.dart';
import 'package:epaisa_todo_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:epaisa_todo_app/features/authentication/domain/usecases/get_fb_signOut.dart';
import 'package:epaisa_todo_app/features/authentication/domain/usecases/get_fb_signedIn.dart';
import 'package:epaisa_todo_app/features/authentication/domain/usecases/get_fb_user.dart';
import 'package:epaisa_todo_app/features/authentication/domain/usecases/sign_in_user.dart';
import 'package:epaisa_todo_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:epaisa_todo_app/features/todo_screen/data/repositories/todo_repository_impl.dart';
import 'package:epaisa_todo_app/features/todo_screen/domain/repositories/todo_repository.dart';
import 'package:epaisa_todo_app/features/todo_screen/domain/usecases/create_todo.dart';
import 'package:epaisa_todo_app/features/todo_screen/presentation/add_todo_bloc/bloc/add_todo_bloc.dart';
import 'package:epaisa_todo_app/features/todo_screen/presentation/pages/todo_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

import 'core/network/network_info.dart';
import 'features/authentication/domain/usecases/create_fb_user.dart';
import 'features/authentication/presentation/create_and_sign_bloc/bloc/create_user_bloc.dart';
import 'features/authentication/presentation/create_and_sign_bloc/bloc/sign_in_user_bloc.dart';
import 'features/todo_screen/domain/usecases/delete_todo.dart';
import 'features/todo_screen/domain/usecases/update_todo.dart';
import 'features/todo_screen/presentation/delete_todo_bloc/bloc/delete_todo_bloc.dart';
import 'features/todo_screen/presentation/update_todo/bloc/update_todo_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //! Features - ePaisa (Repositories, use cases, data sources)

  /*
    * * RegisterFactory Method always creates new instance whenever its called.
    * * Here Bloc which is presentation logic component must be registered as 
    * * Factory because if we navigate to some other screen then we need to 
    * * dispose the observers, or clean memory to prevent strong reference to 
    * * the instances. 
   */
  //? Bloc
  serviceLocator.registerFactory(() => AuthBloc(
      fbSignedIn: serviceLocator(),
      fbSignOut: serviceLocator(),
      fbUser: serviceLocator()));

  serviceLocator
      .registerFactory(() => CreateUserBloc(createFbUser: serviceLocator()));

  serviceLocator
      .registerFactory(() => SignInUserBloc(signInUser: serviceLocator()));

  serviceLocator
      .registerFactory(() => AddTodoBloc(createTodo: serviceLocator()));

  serviceLocator
      .registerFactory(() => UpdateTodoBloc(updateTodo: serviceLocator()));

  serviceLocator
      .registerFactory(() => DeleteTodoBloc(deleteTodo: serviceLocator()));

  /**
   * * SingleTon or LazySingleTon will provide the same instance for the 
   * * subsequent calls
   */
  //? Use cases
  //? Use cases does not hold any state i.e. changing information
  //? So only a single instance is enough. LazySingleTon is registered when
  //? its required and Only Singleton is registered when the app is started.
  serviceLocator.registerLazySingleton(() => GetFbSignOut(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetFbSignedIn(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetFbUser(serviceLocator()));
  serviceLocator.registerLazySingleton(() => CreateFbUser(serviceLocator()));
  serviceLocator.registerLazySingleton(() => CreateTodo(serviceLocator()));
  serviceLocator.registerLazySingleton(() => UpdateTodo(serviceLocator()));
  serviceLocator.registerLazySingleton(() => DeleteTodo(serviceLocator()));
  serviceLocator.registerLazySingleton(() => SignInUser(serviceLocator()));

  //? Repository
  serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
      firebaseAuthDataSource: serviceLocator(), networkInfo: serviceLocator()));

  serviceLocator.registerLazySingleton<TodoRepository>(
      () => TodoRepositoryImpl(networkInfo: serviceLocator()));

  //? Data Sources
  serviceLocator.registerLazySingleton<FirebaseAuthDataSource>(
      () => FirebaseAuthDataSource(firebaseAuth: serviceLocator()));

  //! Core - network info etc
  serviceLocator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(serviceLocator()));

  //! External - Firebase, HTTP, DataConnection Checker, etc
  final firebaseAuth = FirebaseAuth.instance;
  serviceLocator.registerLazySingleton(() => firebaseAuth);
  serviceLocator.registerLazySingleton(() => DataConnectionChecker());

  //! Pages
  serviceLocator
      .registerLazySingleton(() => TodoHome(fbUser: serviceLocator()));

  serviceLocator.registerLazySingleton(() => FbUser(
      uid: firebaseAuth.currentUser.uid,
      email: firebaseAuth.currentUser.email));
}
