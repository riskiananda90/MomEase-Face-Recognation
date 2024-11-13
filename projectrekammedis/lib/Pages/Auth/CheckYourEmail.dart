import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projectrekammedis/Component/AppColor.dart';
import 'package:url_launcher/url_launcher.dart';

class Checkyouremail extends StatefulWidget {
  const Checkyouremail({super.key});

  @override
  State<Checkyouremail> createState() => _CheckyouremailState();
}

class _CheckyouremailState extends State<Checkyouremail> {
  Future<void> _openEmailApp() async {
    final Uri emailLaunchUri = Uri(scheme: "mailto");

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      Get.snackbar("Error", "Email app not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.Primary,
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text("Check Your Email",
                      style: TextStyle(
                          height: 1,
                          color: Appcolor.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 45)),
                  SizedBox(height: 10),
                  Text(
                    "We have sent a reset password to your email address",
                    style: TextStyle(fontSize: 15, color: Appcolor.textPrimary),
                  ),
                  SizedBox(
                    child: Image.asset("Images/ChangePassword.png"),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Appcolor.textPrimary),
                        onPressed: _openEmailApp,
                        child: Text(
                          "Open Email App",
                          style: TextStyle(color: Appcolor.Primary),
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("you remember your password ?",
                          style: TextStyle(color: Appcolor.textPrimary)),
                      TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () {},
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Appcolor.textPrimary,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
                ])),
          )),
    );
  }
}
