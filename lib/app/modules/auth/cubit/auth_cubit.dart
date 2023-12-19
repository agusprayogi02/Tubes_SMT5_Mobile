import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:penilaian/app/core/helpers/usecase_helper.dart';
import 'package:penilaian/app/data/usecase/auth/login_with_email.dart';
import 'package:penilaian/app/data/usecase/auth/login_with_google.dart';
import 'package:penilaian/app/data/usecase/auth/register_with_email.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> loginEmail(Map<String, dynamic> params) async {
    emit(AuthLoading());
    final param = LoginWithEmailParams.fromMap(params);
    final rest = await LoginWithEmail().call(param);
    rest.when(
      success: (data) {
        emit(AuthSuccess(data));
      },
      error: (message) {
        emit(AuthError(message));
      },
    );
  }

  Future<void> loginGoogle() async {
    emit(AuthLoading());
    final rest = await LoginWithGoogleUseCase().call(NoParams());
    await rest.when(
      success: (data) async {
        emit(AuthSuccess(data));
      },
      error: (message) {
        emit(AuthError(message));
      },
    );
  }

  Future<void> registerEmail(Map<String, dynamic> params) async {
    emit(AuthLoading());
    final param = RegisterWithEmailParams.fromMap(params);
    final rest = await RegisterWithEmail().call(param);
    rest.when(
      success: (data) {
        emit(AuthSuccess(data));
      },
      error: (message) {
        emit(AuthError(message));
      },
    );
  }
}
