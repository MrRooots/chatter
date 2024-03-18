import 'package:chatter/core/services/firebase_repository.dart';
import 'package:chatter/core/services/network_info.dart';
import 'package:chatter/features/data/auth/data_sources/local_data_source.dart';
import 'package:chatter/features/data/auth/data_sources/remote_data_source.dart';
import 'package:chatter/features/data/auth/repositories/auth_repository_impl.dart';
import 'package:chatter/features/data/profile/data_sources/local_data_source.dart';
import 'package:chatter/features/data/profile/data_sources/remote_data_source.dart';
import 'package:chatter/features/data/profile/repositories/profile_repository_impl.dart';
import 'package:chatter/features/domain/auth/repositories/auth_repository.dart';
import 'package:chatter/features/domain/auth/usecases/authenticate.dart';
import 'package:chatter/features/domain/auth/usecases/sign_in.dart';
import 'package:chatter/features/domain/auth/usecases/sign_out.dart';
import 'package:chatter/features/domain/auth/usecases/sign_up.dart';
import 'package:chatter/features/domain/messenger/usecases/create_dialog.dart';
import 'package:chatter/features/domain/messenger/usecases/get_dialogs_list.dart';
import 'package:chatter/features/domain/messenger/usecases/get_messages_list.dart';
import 'package:chatter/features/domain/messenger/usecases/send_message.dart';
import 'package:chatter/features/domain/profile/repositories/profile_repository.dart';
import 'package:chatter/features/domain/profile/usecases/profile_updates_stream.dart';
import 'package:chatter/features/domain/profile/usecases/update_password.dart';
import 'package:chatter/features/domain/profile/usecases/update_profile.dart';
import 'package:chatter/features/presentation/auth/bloc/sign_in/sign_in_bloc.dart';
import 'package:chatter/features/presentation/auth/bloc/sign_up/sign_up_bloc.dart';
import 'package:chatter/features/presentation/common/bloc/authentication/authentication_bloc.dart';
import 'package:chatter/features/presentation/messenger/bloc/dialog_bloc/dialog_bloc.dart';
import 'package:chatter/features/presentation/messenger/bloc/dialogs_list_bloc/dialogs_list_bloc.dart';
import 'package:chatter/features/presentation/profile/bloc/edit_password/edit_password_bloc.dart';
import 'package:chatter/features/presentation/profile/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:chatter/features/presentation/profile/bloc/edit_settings/edit_settings_bloc.dart';
import 'package:chatter/features/presentation/profile/bloc/show_onboarding/show_onboarding_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

void initializeBLoCs() {
  sl.registerLazySingleton(
    () => AuthenticationBloc(
      authenticateUser: sl(),
      signOutUser: sl(),
      profileUpdatesListen: sl(),
    ),
  );

  sl.registerFactory(() => SignInBloc(signInUser: sl()));

  sl.registerFactory(() => SignUpBloc(signUp: sl()));

  sl.registerLazySingleton(() => ShowOnboardingCubit());

  // Profile BLoC's
  sl.registerLazySingleton(() => EditProfileBloc(updateProfile: sl()));

  sl.registerLazySingleton(() => EditPasswordBloc(updatePassword: sl()));

  sl.registerFactory(() => EditSettingsBloc(updateProfile: sl()));

  // Messenger BLoc's
  sl.registerLazySingleton(() => DialogsListBloc(
        getDialogsList: sl(),
        createDialog: sl(),
      ));

  sl.registerFactory(() => DialogBloc(
        getMessagesList: sl(),
        sendMessage: sl(),
      ));
}

void initializeUsecases() {
  sl.registerLazySingleton(() => AuthenticateUserUsecase(repository: sl()));

  sl.registerLazySingleton(() => SignInUserUsecase(repository: sl()));

  sl.registerLazySingleton(() => SignUpUserUsecase(repository: sl()));

  sl.registerLazySingleton(() => SignOutUserUsecase(repository: sl()));

  sl.registerLazySingleton(() => UpdateProfileUsecase(repository: sl()));

  sl.registerLazySingleton(() => UpdatePasswordUsecase(repository: sl()));

  sl.registerLazySingleton(() => ProfileUpdatesListenUsecase(repository: sl()));

  sl.registerLazySingleton(() => GetDialogsListUsecase(repository: sl()));

  sl.registerLazySingleton(() => GetMessagesListUsecase(repository: sl()));

  sl.registerLazySingleton(() => CreateDialogUseCase(repository: sl()));

  sl.registerLazySingleton(() => SendMessageUsecase(repository: sl()));
}

void initializeRepositories() {
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ));

  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ));

  // Firebase Firestore repository
  sl.registerLazySingleton<FirebaseRepository>(() => FirebaseRepositoryImpl(
        networkInfo: sl(),
      ));
}

void initializeDataSources() {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(networkInfo: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(networkInfo: sl()),
  );

  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(sharedPreferences: sl()),
  );
}

Future<void> initializeServices() async {
  sl.registerLazySingleton(() => InternetConnectionChecker());

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}

Future<void> initializeDependencies() async {
  initializeBLoCs();

  initializeUsecases();

  initializeRepositories();

  initializeDataSources();

  await initializeServices();
}
