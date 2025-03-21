import 'package:flutter/material.dart';

class NoLoginBmrCalculatorPage extends StatefulWidget {
  @override
  _NoLoginBmrCalculatorPageState createState() => _NoLoginBmrCalculatorPageState();
}

class _NoLoginBmrCalculatorPageState extends State<NoLoginBmrCalculatorPage> {
  double height = 170;
  double weight = 70;
  int age = 25;
  String gender = 'Male';
  double bmr = 0;
  String advice = '';

  void calculateBmr() {
    setState(() {
      if (gender == 'Male') {
        bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
      } else {
        bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
      }
      advice = 'Your BMR is the number of calories your body needs to maintain basic functions while at rest.';
    });
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
                Card(
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
                              'Height (cm)',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            Text(
                              '${height.toStringAsFixed(1)} cm',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                        Slider(
                          value: height,
                          min: 100,
                          max: 220,
                          onChanged: (value) {
                            setState(() {
                              height = value;
                            });
                          },
                          activeColor: Colors.blue,
                          inactiveColor: Colors.grey,
                          thumbColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Card(
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
                              'Weight (kg)',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            Text(
                              '${weight.toStringAsFixed(1)} kg',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                        Slider(
                          value: weight,
                          min: 30,
                          max: 150,
                          onChanged: (value) {
                            setState(() {
                              weight = value;
                            });
                          },
                          activeColor: Colors.blue,
                          inactiveColor: Colors.grey,
                          thumbColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Card(
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
                              'Age',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            Text(
                              '$age years',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                        Slider(
                          value: age.toDouble(),
                          min: 10,
                          max: 100,
                          onChanged: (value) {
                            setState(() {
                              age = value.toInt();
                            });
                          },
                          activeColor: Colors.blue,
                          inactiveColor: Colors.grey,
                          thumbColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Card(
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
                                title: Text(
                                  'Male',
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: 'Male',
                                groupValue: gender,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value.toString();
                                  });
                                },
                                activeColor: Colors.blue,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                title: Text(
                                  'Female',
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: 'Female',
                                groupValue: gender,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value.toString();
                                  });
                                },
                                activeColor: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
                bmr == 0
                    ? Text(
                  'Enter values to calculate BMR',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                )
                    : Card(
                  color: Colors.white.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Your BMR is: ${bmr.toStringAsFixed(2)} kcal/day',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Text(
                          advice,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}