import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthStateLogout()) {
    FirebaseAuth auth = FirebaseAuth.instance;
    on<AuthEventLogin>((event, emit) async {
      try {
        emit(AuthStateLoading());
        // fungsi login
        await auth.signInWithEmailAndPassword(
            email: event.email, password: event.pass);
        emit(AuthStateLogin());
      } on FirebaseAuthException catch (e) {
        // Eror dari firebase auth
        emit(AuthStateError(e.message.toString()));
      } catch (e) {
        // eror general
        emit(AuthStateError(e.toString()));
      }
    });
    on<AuthEventLogout>((event, emit) async {
      try {
        emit(AuthStateLoading());
        // fungsi logout
        await auth.signOut();
        emit(AuthStateLogout());
      } on FirebaseAuthException catch (e) {
        emit(AuthStateError(e.message.toString()));
      } catch (e) {
        // eror general
        emit(AuthStateError(e.toString()));
      }
    });
  }
}
