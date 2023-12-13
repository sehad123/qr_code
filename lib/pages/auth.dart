import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qr_code/pages/login.dart';
import 'package:qr_code/pages/serviceBio.dart';

class Biometric extends StatefulWidget {
  const Biometric({Key? key}) : super(key: key);

  @override
  State<Biometric> createState() => _BiometricState();
}

class _BiometricState extends State<Biometric> {
  bool isAvailable = false;
  bool isAuth = false;
  String text = "Please check biometric";
  final LocalAuthentication localAuthentication = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () async {
                  final authenticate = await LocalAuth.authenticate();
                  setState(() {
                    isAuth = authenticate;
                    isAuth
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          )
                        : null;
                  });
                },
                child: Text(
                  "Authenticate",
                  style: GoogleFonts.poppins(),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isAuth ? Colors.green : Colors.red,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 3,
                    spreadRadius: 2,
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2,
              color: Colors.grey[200],
              child: Center(
                child: Text(text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
