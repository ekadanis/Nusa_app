import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../routes/router.dart';

class EmptyResultView extends StatelessWidget {
  const EmptyResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No quiz result available',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.router.replace(const DashboardRoute());
              },
              child: const Text('Back to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
