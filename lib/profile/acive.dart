import 'package:flutter/material.dart';


class AchievementPage extends StatefulWidget {
  @override
  _AchievementPageState createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  List<Map<String, dynamic>> achievements = [
    {'title': 'Breakfast', 'completed': true},
    {'title': 'Lunch', 'completed': false},
    {'title': 'Dinner', 'completed': true},
    {'title': 'Snacks', 'completed': false},
    {'title': 'Exercise', 'completed': false},
    {'title': 'Water', 'completed': true},
  ];

  void toggleAchievement(int index) {
    setState(() {
      achievements[index]['completed'] = !achievements[index]['completed'];
    });
  }

  void editAchievement(int index) {
    TextEditingController controller =
    TextEditingController(text: achievements[index]['title']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Achievement'),
          content: TextField(
            controller: controller,
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  achievements[index]['title'] = controller.text;
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void removeAchievement(int index) {
    setState(() {
      achievements.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff000022),
      appBar: AppBar(
        backgroundColor: Color(0xff000022),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: Text(
          'Achievement',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              achievements[index]['title'],
              style: TextStyle(color: Colors.white),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    achievements[index]['completed']
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: achievements[index]['completed']
                        ? Colors.white
                        : Colors.grey,
                  ),
                  onPressed: () => toggleAchievement(index),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white70),
                  onPressed: () => editAchievement(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => removeAchievement(index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
