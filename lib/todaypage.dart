import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'meal/healthyfood.dart';

class TodayPage extends StatefulWidget {
  @override
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  double bmr = 1905; // القيمة الافتراضية
  double totalFoodCalories = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// تحميل بيانات BMR والسعرات المستهلكة من التخزين
  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bmr = prefs.getDouble('bmr') ?? 1905; // قراءة BMR كـ double
      totalFoodCalories = prefs.getDouble('totalFoodCalories') ?? 0;
    });
  }

  /// تحديث السعرات الحرارية بعد إضافة وجبة
  Future<void> _updateCalories(double mealCalories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalFoodCalories += mealCalories;
    });
    await prefs.setDouble('totalFoodCalories', totalFoodCalories);
  }

  /// التنقل إلى صفحة البحث عن الوجبات وإضافة السعرات الحرارية
  void _navigateToMeals() async {
    final double? mealCalories = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HealthyFoodSearchPage()),
    );

    if (mealCalories != null) {
      _updateCalories(mealCalories);
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
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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

  /// عرض ملخص السعرات الحرارية
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

  /// إنشاء قسم للوجبات المختلفة
  Widget _buildMealSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
        GestureDetector(
          onTap: _navigateToMeals,
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
