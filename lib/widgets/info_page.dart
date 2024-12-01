import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Health Effects After Quitting Smoking')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildInfoCard('1 Hour After Quitting',
                '1 hour after quitting, your body begins to remove nicotine, and your blood pressure starts to decrease.'),
            _buildInfoCard('1 Day After Quitting',
                '1 day after quitting, the carbon monoxide levels in your blood drop, and the health of your heart improves.'),
            _buildInfoCard('1 Week After Quitting',
                '1 week after quitting, your nervous system starts to recover, and the cravings for nicotine begin to decrease.'),
            _buildInfoCard('1 Year After Quitting',
                '1 year after quitting, the risk of heart disease is reduced by half, and the functioning of your blood vessels improves.'),
            _buildInfoCard('10 Years After Quitting',
                '10 years after quitting, the risk of lung cancer is cut in half, and cardiovascular diseases become less common.'),
          ],
        ),
      ),
    );
  }

  // Helper method to build the info card for each interval
  Widget _buildInfoCard(String title, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}
