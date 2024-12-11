import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:photo_locker/constants/stringConstants.dart';
import 'package:photo_locker/main.dart';

class AuthBioMetricWidget {
  final LocalAuthentication auth = LocalAuthentication();
  SupportState supportState = SupportState.unknown;
  List<BiometricType>? availableBiometrics;

  Future<void> checkBiometric() async {
    late bool canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      debugPrint("${e}");
      canCheckBiometric = false;
    }
  }

  Future<void> getAvailableBiometrics() async {
    late List<BiometricType> biometricTypes;
    try {
      biometricTypes = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      debugPrint("${e}");
    }
    availableBiometrics = biometricTypes;
    box.write(
        ArgumentConstants.bioMetricTypeList,
        availableBiometrics
            ?.map(
              (e) => e.toString(),
            )
            .toList());
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      final authenticated = await auth.authenticate(
        localizedReason: "Authenticate with fingerprint or Face ID",
        options: AuthenticationOptions(
          stickyAuth: true,
          sensitiveTransaction: true,
        ),
      );
      return authenticated;
    } on PlatformException catch (e) {
      debugPrint("${e}");
      return false;
    }
  }
}

enum SupportState {
  unknown,
  supported,
  unSupported,
}
