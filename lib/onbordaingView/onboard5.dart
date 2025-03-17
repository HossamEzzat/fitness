import 'package:flutter/material.dart';

import '../Auth/login.dart';
import '../Auth/registerpage.dart';
import '../BMR/1BMR.dart';

class OnboardingPage5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000022),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 470, // Set a fixed height
            child: Image.asset(
              "assets/Frame4.png",
              fit: BoxFit.cover,
              width: double.maxFinite,
            ),
          ),
          Spacer(),
          CustomButton(text: "Calculator", onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NoLoginBmrCalculatorPage()));
          }),
          SizedBox(height: 15),
          CustomButton(text: "Sign Up", onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
          }),
          SizedBox(height: 15),
          CustomButton(text: "Log In", onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
          }),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
