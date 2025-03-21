import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/BMR/BMR.dart';
import 'package:fitness/meal/healthyfood.dart';
import 'package:fitness/profile/privce.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../onbordaingView/welcomeScreen.dart';
import 'acive.dart';
import 'contactUsPage.dart';

class ProfilePage extends StatelessWidget {
  final String? userId;

  ProfilePage({required this.userId});

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return Scaffold(
        backgroundColor: Color(0xff000022),
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Text(
            'Please log in to view your profile.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff000022), Color(0xff000033)],
          ),
        ),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.white));
            }

            if (!snapshot.hasData || snapshot.hasError) {
              return Center(
                child: Text(
                  'Error fetching data',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};

            // Convert values safely to integers
            int height = _parseNum(userData['height']);
            int weight = _parseNum(userData['weight']);
            int age = _parseNum(userData['age']);

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue, Colors.purple],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            FirebaseAuth.instance.currentUser?.email?.isNotEmpty == true
                                ? FirebaseAuth.instance.currentUser!.email![0].toUpperCase()
                                : '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    userData['name'] ?? 'Name not available',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    userData['program'] ?? 'Program not available',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InfoCard(label: 'Height', value: '$height cm', icon: Icons.height),
                          SizedBox(width: 10),
                          InfoCard(label: 'Weight', value: '$weight kg', icon: Icons.fitness_center),
                          SizedBox(width: 10),
                          InfoCard(label: 'Age', value: '$age', icon: Icons.cake),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AccountSection(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Helper function to safely parse numbers from Firestore
  int _parseNum(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  InfoCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 30),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}

class AccountSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> logout() async {
      try {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
        );
        print('User logged out successfully');
      } catch (e) {
        print('Logout failed: $e');
      }
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Divider(color: Colors.white.withOpacity(0.3)),
          _buildListTile(context, icon: Icons.done_all_outlined, title: 'Achievements', page: AchievementPage()),
          _buildListTile(context, icon: Icons.food_bank, title: 'Meals', page: HealthyFoodSearchPage()),
          _buildListTile(context, icon: Icons.contact_page, title: 'Contact Us', page: ContactUsPage()),
          _buildListTile(context, icon: Icons.calculate_outlined, title: 'BMR Calculate', page: BmrCalculatorPage()),
          _buildListTile(context, icon: Icons.privacy_tip, title: 'Privacy Policy', page: PrivacyPolicyPage()),
          _buildListTile(context, icon: Icons.logout, title: 'Logout', onTap: logout),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, {required IconData icon, required String title, Widget? page, Function? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
      onTap: () {
        if (onTap != null) {
          onTap();
        } else if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        }
      },
    );
  }
}
