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
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Positioned(
            right: -getSmallerDiameter(context) / 3,
            top: -getSmallerDiameter(context) / 3,
            child: Container(
              width: getSmallerDiameter(context),
              height: getSmallerDiameter(context),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [Color(0xFFB226B2), Color(0xFFFF6DA7)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
            ),
          ),
          Positioned(
            left: -getBigrDiameter(context) / 4,
            top: -getBigrDiameter(context) / 4,
            child: Container(
              child: Center(
                  child: Text(
                "Kantin STIS",
                style: TextStyle(
                    fontFamily: 'Pacifico', fontSize: 30, color: Colors.white),
              )),
              width: getBigrDiameter(context),
              height: getBigrDiameter(context),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [Color(0xFFB226B2), Color(0xFFFF6DA7)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
            ),
          ),
          Positioned(
            right: -getBigrDiameter(context) / 4,
            bottom: -getBigrDiameter(context) / 4,
            child: Container(
                width: getBigrDiameter(context),
                height: getBigrDiameter(context),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey[200])),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 50),
            child: Align(
              alignment: Alignment.center,
              child: Image(
                image: AssetImage("assets/images/stis.png"),
                // image: AssetImage("../assets/images/stis.png"),
                width: 120,
                height: 120,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BlocConsumer<AuthBloc, AuthState>(
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
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      margin: EdgeInsets.fromLTRB(20, 450, 20, 10),
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 25),
                      child: Column(
                        children: [
                          TextField(
                            controller: emailC,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.email,
                                  color: Color(0xFFFF4891),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFFF4891))),
                                labelText: "Email : ",
                                labelStyle:
                                    TextStyle(color: Color(0xFFFF4891))),
                          ),
                          TextField(
                            obscureText: true,
                            controller: passC,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.key,
                                  color: Color(0xFFFF4891),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFFF4891))),
                                labelText: "Password : ",
                                labelStyle:
                                    TextStyle(color: Color(0xFFFF4891))),
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 20, 20),
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 40,
                            child: Container(
                              child: Material(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  splashColor: Colors.amber,
                                  onTap: () {
                                    // proses login
                                    context.read<AuthBloc>().add(
                                          AuthEventLogin(
                                              emailC.text, passC.text),
                                        );
                                  },
                                  child: Center(
                                    child: state is AuthStateLoading
                                        ? const CircularProgressIndicator()
                                        : const Text("LOGIN"),
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFB226B2),
                                        Color(0xFFFF4891)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)),
                            ),
                          ),
                          FloatingActionButton(
                            mini: true,
                            elevation: 0,
                            onPressed: null,
                            child: Icon(
                              Icons.facebook,
                              size: 30,
                            ),
                          ),
                          FloatingActionButton(
                            mini: true,
                            elevation: 0,
                            onPressed: null,
                            child: Icon(
                              Icons.adb,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't Have An Account ?      ",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "SIGN UP ",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFFF4891),
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
