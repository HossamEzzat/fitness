import 'package:flutter/material.dart';

class HealthyFoodSearchPage extends StatefulWidget {
  const HealthyFoodSearchPage({super.key});

  @override
  State<HealthyFoodSearchPage> createState() => _HealthyFoodSearchPageState();
}

class _HealthyFoodSearchPageState extends State<HealthyFoodSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> meals = [
    {'name': 'سلطة الكينوا', 'calories': '250'},
    {'name': 'صدر دجاج مشوي', 'calories': '300'},
    {'name': 'سمك مشوي', 'calories': '200'},
    {'name': 'سلطة فواكه', 'calories': '150'},
    {'name': 'زبادي بالعسل والمكسرات', 'calories': '180'},
    {'name': 'شوربة العدس', 'calories': '220'},
    {'name': 'سلطة التونة', 'calories': '230'},
    {'name': 'أرز بني مع خضروات', 'calories': '270'},
    {'name': 'بطاطا مشوية', 'calories': '190'},
    {'name': 'عصير طبيعي', 'calories': '120'},
  ];

  List<Map<String, String>> filteredMeals = [];

  @override
  void initState() {
    super.initState();
    filteredMeals = meals;
  }

  void _filterMeals(String query) {
    setState(() {
      filteredMeals = meals
          .where((meal) => meal['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectMeal(String name, String calories) {
    Navigator.pop(context, {'name': name, 'calories': double.parse(calories)});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000022),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('وجبات صحية', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterMeals,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'ابحث عن وجبة...',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMeals.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredMeals[index]['name']!, style: TextStyle(color: Colors.white)),
                  subtitle: Text("${filteredMeals[index]['calories']} سعر حراري",
                      style: TextStyle(color: Colors.white70)),
                  onTap: () => _selectMeal(
                    filteredMeals[index]['name']!,
                    filteredMeals[index]['calories']!,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
