import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BmrCalculatorPage extends StatefulWidget {
  @override
  _BmrCalculatorPageState createState() => _BmrCalculatorPageState();
}

class _BmrCalculatorPageState extends State<BmrCalculatorPage> {
  int height = 170; // Height in cm
  int weight = 70;  // Weight in kg
  int age = 25;     // Age in years
  String gender = 'Male'; // Default gender
  double bmr = 0; // BMR value
  String advice = ''; // Advice based on BMR
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    loadBmr(); // Load saved BMR when the page initializes
  }

  /// Load saved BMR from SharedPreferences
  void loadBmr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bmr = prefs.getDouble('bmr') ?? 0; // Load BMR or default to 0
    });
  }

  /// Calculate BMR and save it to Firestore and SharedPreferences
  void calculateBmr() async {
    if (_auth.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to save your BMR.')),
      );
      return;
    }

    setState(() {
      // Calculate BMR based on gender
      if (gender == 'Male') {
        bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
      } else {
        bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
      }
      advice = 'Your BMR is the number of calories your body needs to maintain basic functions while at rest.';
    });

    try {
      // Save BMR and user data to Firestore
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'bmr': bmr,
        'height': height,   // Save height as int
        'weight': weight,   // Save weight as int
        'age': age,         // Save age as int
        'gender': gender,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Save BMR to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('bmr', bmr);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('BMR saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save BMR: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff000022), Color(0xff000033)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(
                    'BMR Calculator',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  centerTitle: true,
                ),
                SizedBox(height: 20),
                _buildSlider('Height (cm)', height.toDouble(), 100, 220, (value) {
                  setState(() => height = value.toInt());  // Update height
                }),
                SizedBox(height: 16),
                _buildSlider('Weight (kg)', weight.toDouble(), 30, 150, (value) {
                  setState(() => weight = value.toInt());  // Update weight
                }),
                SizedBox(height: 16),
                _buildSlider('Age', age.toDouble(), 10, 100, (value) {
                  setState(() => age = value.toInt());  // Update age
                }),
                SizedBox(height: 16),
                _buildGenderSelection(),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: calculateBmr,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff73C254),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Calculate BMR',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 24),
                _buildBmrResult(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build a slider widget for height, weight, and age
  Widget _buildSlider(String label, double value, double min, double max, Function(double) onChanged) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  '${value.toStringAsFixed(1)}',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
              activeColor: Colors.blue,
              inactiveColor: Colors.grey,
              thumbColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  /// Build gender selection radio buttons
  Widget _buildGenderSelection() {
    return Card(
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gender',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: Text('Male', style: TextStyle(color: Colors.white)),
                    value: 'Male',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() => gender = value.toString());
                    },
                    activeColor: Colors.blue,
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text('Female', style: TextStyle(color: Colors.white)),
                    value: 'Female',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() => gender = value.toString());
                    },
                    activeColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build the BMR result card
  Widget _buildBmrResult() {
    return bmr == 0
        ? Text(
      'Enter values to calculate BMR',
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      textAlign: TextAlign.center,
    )
        : Card(
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Your BMR is: ${bmr.toStringAsFixed(2)} kcal/day',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center),
            SizedBox(height: 16),
            Text(advice, style: TextStyle(fontSize: 18, color: Colors.white), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}