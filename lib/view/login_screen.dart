import 'dart:convert';

import 'package:deals_dray/view/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:platform_device_id_v3/platform_device_id.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPhoneSelected = true;
  TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> sendLoginInfo() async {
    String mobileNumber = _phoneController.text.trim();
    // String deviceId = "62b341aeb0ab5ebe28a758a3";
    String? deviceId = await PlatformDeviceId.getDeviceId;
    print(deviceId!);

    if (mobileNumber.isEmpty) {
      print("Mobile number is required.");
      return;
    }

    var loginInfo = {
      "mobileNumber": mobileNumber,
      "deviceId": deviceId,
    };
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => OtpScreen()));

    var url = Uri.parse(
        'http://devapiv4.dealsdray.com/api/v2/user/otp'); // Replace with your API endpoint

    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(loginInfo),
      );

      if (response.statusCode == 500) {
        print("Login info sent successfully");
        // You can navigate to the next screen here if needed
      } else {
        print("Failed to send login info. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error sending login info: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Icon(Icons.arrow_back_ios_new),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Center(
                child: Image(
                  image: AssetImage('images/ddLogo.png'),
                  height: 200,
                  width: 200,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPhoneSelected = true;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isPhoneSelected
                                ? Colors.red
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              'Phone',
                              style: TextStyle(
                                color: isPhoneSelected
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPhoneSelected = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: !isPhoneSelected
                                ? Colors.red
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              'Email',
                              style: TextStyle(
                                color: !isPhoneSelected
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      'Glad to see you!',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Please provide your phone number',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: sendLoginInfo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'SEND CODE',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
