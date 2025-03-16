import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BmrCalculatorPage extends StatefulWidget {
  @override
  _BmrCalculatorPageState createState() => _BmrCalculatorPageState();
}

class _BmrCalculatorPageState extends State<BmrCalculatorPage> {
  int height = 170; // Make height an int
  int weight = 70;  // Make weight an int
  int age = 25;     // Keep age as an int
  String gender = 'Male';
  double bmr = 0;
  String advice = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    loadBmr();
  }

  /// تحميل BMR المخزن مسبقًا
  void loadBmr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bmr = prefs.getDouble('bmr') ?? 0;
    });
  }

  /// حساب BMR وحفظه في Firestore و SharedPreferences
  void calculateBmr() async {
    if (_auth.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to save your BMR.')),
      );
      return;
    }

    setState(() {
      if (gender == 'Male') {
        bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
      } else {
        bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
      }
      advice = 'Your BMR is the number of calories your body needs to maintain basic functions while at rest.';
    });

    try {
      // حفظ BMR في Firestore
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'bmr': bmr,
        'height': height,   // Use height as int
        'weight': weight,   // Use weight as int
        'age': age,         // Use age as int
        'gender': gender,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // حفظ BMR في SharedPreferences
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
                  setState(() => height = value.toInt());  // Ensure height is an int
                }),
                SizedBox(height: 16),
                _buildSlider('Weight (kg)', weight.toDouble(), 30, 150, (value) {
                  setState(() => weight = value.toInt());  // Ensure weight is an int
                }),
                SizedBox(height: 16),
                _buildSlider('Age', age.toDouble(), 10, 100, (value) {
                  setState(() => age = value.toInt());  // Keep age as int
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

  /// إنشاء ويدجت شريط التمرير لكل من الطول والوزن والعمر
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

  /// اختيار الجنس
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

  /// عرض نتيجة BMR
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
