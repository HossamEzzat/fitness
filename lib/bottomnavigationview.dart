import 'package:fitness/todaypage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:fitness/profile/profile.dart';
import 'package:fitness/QR/qr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'BMR/BMR.dart';
import 'WorkoutTrackerPage.dart';
import 'meal/healthyfood.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      WorkoutTrackerPage(),
      TodayPage(),
      HealthyFoodSearchPage(),
      QRScanPage(),
      userId != null ? ProfilePage(userId: userId!) : const Center(child: Text('Please log in to view profile')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: GNav(
            backgroundColor: Colors.white,
            rippleColor: Colors.green.shade100,
            hoverColor: Colors.green.shade50,
            haptic: true, // Adds haptic feedback
            gap: 8,
            activeColor: Colors.green,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Colors.green.withOpacity(0.2),
            color: Colors.grey[800],
            tabs: const [
              GButton(
                icon: Icons.fitness_center,
                text: 'Fitness',
              ),
              GButton(
                icon: Icons.calculate_outlined,
                text: 'BMR',
              ),
              GButton(
                icon: Icons.food_bank,
                text: 'Meals',
              ),
              GButton(
                icon: Icons.qr_code,
                text: 'QR',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
            selectedIndex: _currentIndex,
            onTabChange: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
