import 'dart:developer';

import 'package:chatter/core/exceptions/exceptions.dart';
import 'package:chatter/core/services/network_info.dart';
import 'package:chatter/features/data/common/models/user_model.dart';
import 'package:chatter/features/data/common/models/user_settings_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRemoteDataSource {
  /// Load extended customer data from cloud store
  Future<UserModel> _loadUserData({required final String uid});

  /// Restore current user session
  Future<UserModel> authenticate();

  /// Login with provided credentials
  Future<void> signIn({
    required final String email,
    required final String password,
  });

  /// Create bew account
  Future<void> signUp({
    required final String email,
    required final String password,
    required final String firstname,
    required final String lastname,
    required final String username,
  });

  /// Add user record to [FirebaseFirestore]
  Future<void> addUserToDatabase({required final UserModel user});

  /// Logout current user
  Future<void> signOut();
}

final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkInfo networkInfo;

  const AuthRemoteDataSourceImpl({required this.networkInfo});

  @override
  Future<UserModel> authenticate() async {
    log('authenticate', name: 'AuthRemoteDataSource');
    if (await networkInfo.isConnected) {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        return await _loadUserData(uid: user.uid);
      }

      throw const AuthorizationException(message: '');
    }
    throw const ConnectionException(message: '');
  }

  @override
  Future<void> signIn({
    required final String email,
    required final String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        throw AuthorizationException(
          message: e.message ?? 'Invalid credentials',
        );
      }
    } else {
      throw const ConnectionException(message: '');
    }
  }

  @override
  Future<void> signUp({
    required final String email,
    required final String password,
    required final String firstname,
    required final String lastname,
    required final String username,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final UserCredential credentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        if (credentials.user == null) {
          throw const AuthorizationException(
            message: 'User is null after authorization!',
          );
        }

        await addUserToDatabase(
          user: UserModel(
            id: credentials.user!.uid,
            firstname: firstname,
            lastname: lastname,
            email: email,
            username: username,
            status: 'Wassup, I\'m using Chatter!',
            settings: UserSettingsModel.empty(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        throw AuthorizationException(
          message: e.message ?? 'Invalid credentials',
        );
      }
    } else {
      throw const ConnectionException(message: '');
    }
  }

  @override
  Future<void> addUserToDatabase({required final UserModel user}) async {
    if (await networkInfo.isConnected) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .set(user.toJson());
      } on FirebaseException catch (e) {
        throw AuthorizationException(
          message: e.message ?? 'Invalid credentials',
        );
      }
    } else {
      throw const ConnectionException(message: '');
    }
  }

  @override
  Future<void> signOut() async {
    if (await networkInfo.isConnected) {
      return await FirebaseAuth.instance.signOut();
    }
    throw const ConnectionException(message: '');
  }

  @override
  Future<UserModel> _loadUserData({required final String uid}) async {
    print('Searching for uid: $uid');

    final CollectionReference collection =
        FirebaseFirestore.instance.collection('users');
    final DocumentSnapshot document = await collection.doc(uid).get();

    if (document.exists) {
      log('_loadUserData(), user found', name: 'AuthRemoteDataSource');

      return UserModel.fromJson(json: document.data() as Map<String, dynamic>);
    }

    throw const AuthorizationException(message: 'No user found!');
  }
}
