import 'package:flutter/material.dart';

import 'onbord2.dart';
double progress = 0.0;
class OnBordaingScreen extends StatefulWidget {
  const OnBordaingScreen({super.key});

  @override
  State<OnBordaingScreen> createState() => _OnBordaingScreenState();
}

class _OnBordaingScreenState extends State<OnBordaingScreen> {


  void _incrementProgress() {
    setState(() {
      if (progress != 1) {
        progress += 0.25;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Onbording2()),
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
              "assets/Frame.png",
              fit: BoxFit.cover,
              width: double.maxFinite,
            ),
          ),
          const SizedBox(height: 35),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              "Track Your Goal",
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
              "Don't worry if you have trouble determining your goals, We can help you determine your goals and track your goals",
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


