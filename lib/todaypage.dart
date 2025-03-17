import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'meal/healthyfood.dart';
import 'dart:convert';

class TodayPage extends StatefulWidget {
  @override
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  double bmr = 1905;
  double totalFoodCalories = 0;
  Map<String, List<Map<String, dynamic>>> mealsByCategory = {
    'Breakfast': [],
    'Lunch': [],
    'Dinner': [],
    'Snacks': [],
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bmr = prefs.getDouble('bmr') ?? 1905;
      totalFoodCalories = prefs.getDouble('totalFoodCalories') ?? 0;

      mealsByCategory['Breakfast'] = _loadMealsFromPrefs(prefs, 'Breakfast');
      mealsByCategory['Lunch'] = _loadMealsFromPrefs(prefs, 'Lunch');
      mealsByCategory['Dinner'] = _loadMealsFromPrefs(prefs, 'Dinner');
      mealsByCategory['Snacks'] = _loadMealsFromPrefs(prefs, 'Snacks');
    });
  }

  List<Map<String, dynamic>> _loadMealsFromPrefs(SharedPreferences prefs, String key) {
    String? mealsJson = prefs.getString(key);
    if (mealsJson != null) {
      return List<Map<String, dynamic>>.from(json.decode(mealsJson));
    }
    return [];
  }

  Future<void> _updateCalories(String mealType, String mealName, double mealCalories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalFoodCalories += mealCalories;
      mealsByCategory[mealType]?.add({'name': mealName, 'calories': mealCalories});
    });

    await prefs.setDouble('totalFoodCalories', totalFoodCalories);
    await prefs.setString(mealType, json.encode(mealsByCategory[mealType]));
  }

  Future<void> _resetCalories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalFoodCalories = 0;
      mealsByCategory = {
        'Breakfast': [],
        'Lunch': [],
        'Dinner': [],
        'Snacks': [],
      };
    });

    await prefs.setDouble('totalFoodCalories', 0);
    await prefs.remove('Breakfast');
    await prefs.remove('Lunch');
    await prefs.remove('Dinner');
    await prefs.remove('Snacks');
  }

  void _navigateToMeals(String mealType) async {
    final Map<String, dynamic>? selectedMeal = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HealthyFoodSearchPage()),
    );

    if (selectedMeal != null) {
      await _updateCalories(mealType, selectedMeal['name'], selectedMeal['calories']);
    }
  }

  @override
  Widget build(BuildContext context) {
    double remainingCalories = bmr - totalFoodCalories;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Today", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetCalories,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildCaloriesSummary(bmr, totalFoodCalories, remainingCalories),
            SizedBox(height: 20),
            _buildMealSection("Breakfast"),
            _buildMealSection("Lunch"),
            _buildMealSection("Dinner"),
            _buildMealSection("Snacks"),
          ],
        ),
      ),
    );
  }

  Widget _buildCaloriesSummary(double bmr, double total, double remaining) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${bmr.toStringAsFixed(0)} - ${total.toStringAsFixed(0)} = ${remaining.toStringAsFixed(0)}",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
        ),
        SizedBox(height: 10),
        Text("Goal     Food     Remaining", style: TextStyle(color: Colors.white70)),
        Divider(color: Colors.white70),
      ],
    );
  }

  Widget _buildMealSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
        ...mealsByCategory[title]!.map((meal) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            "${meal['name']} - ${meal['calories']} kcal",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        )),
        GestureDetector(
          onTap: () => _navigateToMeals(title),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Add food", style: TextStyle(color: Colors.green, fontSize: 16)),
          ),
        ),
        Divider(color: Colors.white70),
      ],
    );
  }
}
