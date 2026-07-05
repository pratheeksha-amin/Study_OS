import 'package:flutter/material.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text("Analytics and Insights Coming Soon!", style: TextStyle(fontSize: 18)),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text("Track your weekly progress and study streaks here.", textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
