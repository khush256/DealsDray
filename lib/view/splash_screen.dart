import 'dart:async';
import 'dart:convert';

import 'package:deals_dray/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    sendDeviceInfo();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen())));
  }

  Future<void> sendDeviceInfo() async {
    var deviceInfo = {
      "deviceType": "android",
      "deviceId": "C6179909526098",
      "deviceName": "Samsung-MT200",
      "deviceOSVersion": "2.3.6",
      "deviceIPAddress": "11.433.445.66",
      "lat": 9.9312,
      "long": 76.2673,
      "buyer_gcmid": "",
      "buyer_pemid": "",
      "app": {
        "version": "1.20.5",
        "installTimeStamp": "2022-02-10T12:33:30.696Z",
        "uninstallTimeStamp": "2022-02-10T12:33:30.696Z",
        "downloadTimeStamp": "2022-02-10T12:33:30.696Z"
      }
    };

    var url = Uri.parse(
        'http://devapiv4.dealsdray.com/api/v2/user/device/add'); // Replace with your API endpoint

    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(deviceInfo),
      );

      if (response.statusCode == 200) {
        print("Device info sent successfully");
        // You can navigate to the next screen here if needed
      } else {
        print(
            "Failed to send device info. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error sending device info: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(fit: StackFit.expand, children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/ddSplash.jpg'), fit: BoxFit.cover),
            ),
          ),
          const SpinKitFadingCircle(
            color: Colors.redAccent,
            size: 50,
          ),
          const Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Image(
              image: AssetImage('images/ddLogo.png'),
              height: 200,
              width: 200,
            ),
          ),
        ]),
      ),
    );
  }
}
