part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

// Event => action / aksi / tindakan
// 1. state logout -> melakukan tindakan login
// 2. state logout ->  melakukan tindakan logout
// 3. state logout -> loading ...

class AuthEventLogin extends AuthEvent {
  AuthEventLogin(this.email, this.pass);
  final String email;
  final String pass;
}

class AuthEventLogout extends AuthEvent {}
