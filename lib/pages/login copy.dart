import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code/bloc/auth/auth_bloc.dart';
import 'package:qr_code/routes/router.dart';

// ignore: use_key_in_widget_constructors
class LoginPage extends StatelessWidget {
  double getSmallerDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 2 / 3;
  double getBigrDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 7 / 8;
  final TextEditingController emailC =
      TextEditingController(text: "admin@gmail.com");
  final TextEditingController passC = TextEditingController(text: "admin123");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LOGIN PAGE"),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthStateLogin) {
            context.goNamed(Routes.home);
          }
          if (state is AuthStateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextField(
                autocorrect: false,
                controller: emailC,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                autocorrect: false,
                controller: passC,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // proses login
                  context.read<AuthBloc>().add(
                        AuthEventLogin(emailC.text, passC.text),
                      );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: state is AuthStateLoading
                    ? const CircularProgressIndicator()
                    : const Text("LOGIN"),
              ),
            ],
          );
        },
      ),
    );
  }
}
