import 'package:flutter/material.dart';
import '../../domain/models/branch_model.dart';

class BranchPerformance extends StatelessWidget {
  final BranchModel branch;
  const BranchPerformance({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text('Performance (Today)', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _PerfCard(
              icon: Icons.person_add,
              label: 'New Subscriptions',
              value: branch.newSubscriptions.toString(),
              color: Colors.orange[50]!,
            ),
            _PerfCard(
              icon: Icons.attach_money,
              label: 'Revenue (EGP)',
              value: branch.revenue.toString(),
              color: Colors.green[50]!,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _PerfCard(
              icon: Icons.check_circle,
              label: 'Check-ins Count',
              value: branch.checkIns.toString(),
              color: Colors.blue[50]!,
            ),
            _PerfCard(
              icon: Icons.cancel,
              label: 'Expired Subscriptions',
              value: branch.expiredSubscriptions.toString(),
              color: Colors.red[50]!,
            ),
          ],
        ),
      ],
    );
  }
}

class _PerfCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _PerfCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
