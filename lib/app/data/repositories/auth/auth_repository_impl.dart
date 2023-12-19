import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:penilaian/app/core/helpers/result_helper.dart';
import 'package:penilaian/app/core/typedefs/typedefs.dart';

import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _auth = FirebaseAuth.instance;

  @override
  ResultResponse<String> changePassword(String email, String password) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  ResultResponse<String> forgotPassword(String email) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  ResultResponse<User> loginEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Result.success(credential.user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Result.error(message: 'Email tidak ditemukan!');
      } else if (e.code == 'wrong-password') {
        return Result.error(message: 'Password salah!');
      }
      return Result.error(message: e.message ?? 'Terjadi kesalahan!');
    } catch (e) {
      return Result.error(message: e.toString());
    }
  }

  @override
  ResultResponse<User> loginGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final result = await _auth.signInWithCredential(credential);
      return Result.success(result.user!);
    } catch (e) {
      return Result.error(message: "Login dibatalkan!");
    }
  }

  @override
  Future<void> logout() => _auth.signOut();

  @override
  ResultResponse<User> register(
      String name, String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);
      return Result.success(credential.user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Result.error(
            message: 'Password yang anda masukkan terlalu lemah!');
      } else if (e.code == 'email-already-in-use') {
        return Result.error(message: 'Email sudah digunakan!');
      }
      return Result.error(message: e.message ?? 'Terjadi kesalahan!');
    } catch (e) {
      return Result.error(message: e.toString());
    }
  }
}
