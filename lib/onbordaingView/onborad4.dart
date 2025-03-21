import 'package:flutter/material.dart';
import '../BMR/1BMR.dart';
import 'onboard5.dart';
import 'onbordaing.dart';

class onbording4 extends StatefulWidget {
  const onbording4({super.key});

  @override
  State<onbording4> createState() => _onbording4State();
}

class _onbording4State extends State<onbording4> {

  void _incrementProgress() {
    setState(() {
      if (progress != 1) {
        progress += 0.25;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingPage5()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000022),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 470, // Set a fixed height
            child: Image.asset(
              "assets/Frame4.png",
              fit: BoxFit.cover,
              width: double.maxFinite,
            ),
          ),
          const SizedBox(height: 35),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              "Improve Sleep  Quality",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Improve the quality of your sleep with us, good quality sleep can bring a good mood in the morning",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: _incrementProgress,
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: CircularProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                          strokeWidth: 6,
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
