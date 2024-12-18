import '../../../../core/api/api_url.dart';
import '../../../../core/constants/error_message.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/login_model.dart';
import '../models/register_model.dart';
import '../models/user_model.dart';


import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

sealed class AuthRemoteDataSource {
  Future<UserModel> login(LoginModel model);
  Future<void> logout();
  Future<void> register(RegisterModel model);
}


class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserModel> login(LoginModel model) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: model.email!,
        password: model.password!,
      );

      final user = userCredential.user;
      if (user == null || user.email == null) throw AuthException();

      // Récupérer les informations de l'utilisateur à partir de Firestore
      final userData = await _getUserData(user.uid);
      return userData;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw AuthException();
      }
      throw ServerException();
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  @override
  Future<void> register(RegisterModel model) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: model.email!,
        password: model.password!,
      );

      final user = userCredential.user;
      if (user != null) {
        await ApiUrl.users.doc(user.uid).set(model.toMap());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw DuplicateEmailException();
      }
      throw ServerException();
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  Future<UserModel> _getUserData(String uid) async {
    try {
      final doc = await ApiUrl.users.doc(uid).get();
      if (!doc.exists) throw EmptyException();
      return UserModel.fromJson(doc.data()!, uid);
    } catch (e) {
      if (e is EmptyException) throw EmptyException();
      logger.e(e);
      throw ServerException();
    }
  }
}




// sealed class AuthRemoteDataSource {
//   Future<UserModel> login(LoginModel model);
//   Future<void> logout();
//   Future<void> register(RegisterModel model);
// }
//
// class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
//   @override
//   Future<UserModel> login(LoginModel model) async {
//     try {
//       final user = await _getUserByEmail(model.email ?? "");
//
//       return user;
//     } on EmptyException {
//       throw AuthException();
//     } catch (e) {
//       logger.e(e);
//       if (e.toString() == noElement) {
//         throw AuthException();
//       }
//       throw ServerException();
//     }
//   }
//
//   @override
//   Future<void> logout() async {
//     try {
//       await Future.delayed(const Duration(seconds: 1));
//       return;
//     } catch (e) {
//       logger.e(e);
//       throw ServerException();
//     }
//   }
//
//   @override
//   Future<void> register(RegisterModel model) async {
//     try {
//       final user = await _getUserByEmail(model.email ?? "");
//       if (user.email == model.email) {
//         throw DuplicateEmailException();
//       }
//
//       return;
//     } on EmptyException {
//       await ApiUrl.users.add(model.toMap());
//     } on DuplicateEmailException {
//       rethrow;
//     } catch (e) {
//       logger.e(e);
//       throw ServerException();
//     }
//   }
//
//   Future<UserModel> _getUserByEmail(String email) async {
//     try {
//       final result = await ApiUrl.users.where("email", isEqualTo: email).get();
//       final doc = result.docs.first;
//       final user = UserModel.fromJson(doc.data(), doc.id);
//
//       return user;
//     } catch (e) {
//       if (e.toString() == noElement) {
//         throw EmptyException();
//       }
//       logger.e(e);
//       throw ServerException();
//     }
//   }
// }
