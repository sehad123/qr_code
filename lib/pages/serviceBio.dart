import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuth {
  static final _auth = LocalAuthentication();

  static Future<bool> _canAuthenticate() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  static Future<bool> authenticate() async {
    try {
      if (!await _canAuthenticate()) return false;

      // Authenticate and wait for the result
      bool isAuthenticated = await _auth.authenticate(
        localizedReason: "Use face id to authenticate",
        // You might need to adjust the AndroidAuthMessages based on the version of local_auth
        // Check the documentation for the correct usage
        // authMessages: const AndroidAuthMessages(
        //   signInTitle: 'Sign in',
        //   cancelButton: 'Mo Thanks',
        // ),
      );

      return isAuthenticated;
    } catch (e) {
      debugPrint('error $e');
      return false;
    }
  }
}
