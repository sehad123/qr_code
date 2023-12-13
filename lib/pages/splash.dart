import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code/pages/auth.dart';
import 'package:qr_code/routes/router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin STIS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        // ...add other routes
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash_screen";

  @override
  Widget build(BuildContext context) {
    return SplashPage();
  }
}

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    navigateToNextScreen();
  }

  void navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3));
    // ignore: use_build_context_synchronously
    // context.goNamed(Routes.biometric);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Biometric()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                "assets/images/stis.png",
                height: 150,
                width: 190,
              ),
            ),
            SizedBox(height: 20), // Jarak antara gambar dan teks
            Text(
              'Kantin STIS',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
