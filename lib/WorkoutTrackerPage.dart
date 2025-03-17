import 'package:flutter/material.dart';

class WorkoutTrackerPage extends StatelessWidget {
  const WorkoutTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000022),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Workout Tracker',
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'What Do You Want to Train',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: const [
                  WorkoutCard('Fullbody Workout', '11 Exercises | 32mins'),
                  WorkoutCard('Upperbody Workout', '10 Exercises | 40mins'),
                  WorkoutCard('Lowebody Workout', '12 Exercises | 40mins'),
                  WorkoutCard('AB Workout', '14 Exercises | 20mins'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const WorkoutCard(this.title, this.subtitle, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () {},
          child: const Text('View more'),
        ),
      ),
    );
  }
}