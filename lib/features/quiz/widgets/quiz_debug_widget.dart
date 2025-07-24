import 'package:flutter/material.dart';
import '../services/quiz_firebase_service.dart';

class QuizDebugWidget extends StatelessWidget {
  const QuizDebugWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Quiz Debug Tools',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Debug User Stats Button
            ElevatedButton.icon(
              onPressed: () async {
                await QuizFirebaseService.debugUserStats();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Check console for debug info')),
                );
              },
              icon: const Icon(Icons.bug_report),
              label: const Text('Debug User Stats'),
            ),
            
            const SizedBox(height: 8),
            
            // Reset Day Streak Button
            ElevatedButton.icon(
              onPressed: () async {
                await QuizFirebaseService.resetDayStreak();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Day streak reset to 0')),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Day Streak'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
            
            const SizedBox(height: 8),
            
            // Simulate Yesterday Play Button
            ElevatedButton.icon(
              onPressed: () async {
                await QuizFirebaseService.simulateYesterdayPlay();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Simulated yesterday play')),
                );
              },
              icon: const Icon(Icons.history),
              label: const Text('Simulate Yesterday Play'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            
            const SizedBox(height: 12),
            
            const Text(
              'Instructions:\n'
              '1. Use "Debug User Stats" to check current data\n'
              '2. Use "Reset Day Streak" to start fresh\n'
              '3. Use "Simulate Yesterday Play" to test streak logic\n'
              '4. Then complete a quiz to see if streak increments',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
