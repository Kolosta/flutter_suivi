import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/failure_converter.dart';
import '../../../../../core/utils/logger.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/change_profile_image_usecase.dart';
import '../../../domain/usecases/check_signin_status_usecase.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';
import '../../../domain/usecases/register_usecase.dart';
import '../../../domain/usecases/usecase_params.dart';



part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthLoginUseCase _loginUseCase;
  final AuthRegisterUseCase _registerUseCase;
  final AuthLogoutUseCase _logoutUseCase;
  final AuthCheckSignInStatusUseCase _checkSignInStatusUseCase;
  final ChangeProfileImageUseCase _changeProfileImageUseCase;

  AuthBloc(
      this._loginUseCase,
      this._logoutUseCase,
      this._registerUseCase,
      this._checkSignInStatusUseCase,
      this._changeProfileImageUseCase,
      ) : super(AuthInitialState()) {
    on<AuthLoginEvent>(_login);
    on<AuthLogoutEvent>(_logout);
    on<AuthRegisterEvent>(_register);
    on<AuthCheckSignInStatusEvent>(_checkSignInStatus);
    on<ChangeProfileImageEvent>(_onChangeProfileImage);
  }

  Future _login(AuthLoginEvent event, Emitter emit) async {
    emit(AuthLoginLoadingState());

    final result = await _loginUseCase.call(
      LoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
          (l) => emit(AuthLoginFailureState(mapFailureToMessage(l))),
          (r) => emit(AuthLoginSuccessState(r)),
    );
  }

  Future _logout(AuthLogoutEvent event, Emitter emit) async {
    emit(AuthLogoutLoadingState());

    final result = await _logoutUseCase.call(NoParams());

    result.fold(
          (l) => emit(AuthLogoutFailureState(mapFailureToMessage(l))),
          (r) => emit(const AuthLogoutSuccessState("Logout Success")),
    );
  }

  Future _register(AuthRegisterEvent event, Emitter emit) async {
    emit(AuthRegisterLoadingState());

    final result = await _registerUseCase.call(
      RegisterParams(
        username: event.username,
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
      ),
    );

    result.fold(
          (l) => emit(AuthRegisterFailureState(mapFailureToMessage(l))),
          (r) => emit(const AuthRegisterSuccessState("Register Success")),
    );
  }

  Future _checkSignInStatus(AuthCheckSignInStatusEvent event, Emitter emit) async {
    emit(AuthCheckSignInStatusLoadingState());

    final result = await _checkSignInStatusUseCase.call(NoParams());

    result.fold(
          (l) => emit(AuthCheckSignInStatusFailureState(mapFailureToMessage(l))),
          (r) => emit(AuthCheckSignInStatusSuccessState(r)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE AuthBloc =====");
    return super.close();
  }


  Future<void> _onChangeProfileImage(ChangeProfileImageEvent event, Emitter<AuthState> emit) async {
    emit(ChangeProfileImageLoadingState());
    final result = await _changeProfileImageUseCase.changeProfileImage(event.imageFile);
    result.fold(
          (failure) => emit(ChangeProfileImageFailureState(mapFailureToMessage(failure))),
          (base64Image) => emit(ChangeProfileImageSuccessState(base64Image)),
    );
  }

}