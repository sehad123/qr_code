part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthStateLogin extends AuthState {}

final class AuthStateLoading extends AuthState {}

final class AuthStateLogout extends AuthState {}

final class AuthStateError extends AuthState {
  AuthStateError(this.message);
  final String message;
}

// State => kondisi saat ini
// 1. state logout -> tidak teruauntetifikasi
// 2. state logout ->  teruauntetifikasi
// 3. state logout -> loading ...
// 4. state error -> gagal logim ...