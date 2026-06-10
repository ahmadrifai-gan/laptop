import 'package:flutter/material.dart';

class SearchBannerWidget extends StatelessWidget {
  final String searchQuery;
  final int topMatchPercentage;
  final int bestValuePercentage;

  const SearchBannerWidget({
    super.key,
    required this.searchQuery,
    required this.topMatchPercentage,
    required this.bestValuePercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D1B3E), Color(0xFF1A2F5A)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search context text
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.4,
              ),
              children: [
                const TextSpan(text: 'Based on your recent search for '),
                TextSpan(
                  text: '"$searchQuery"',
                  style: const TextStyle(
                    color: Color(0xFF5B9EF4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Stat cards row
          Row(
            children: [
              _StatCard(
                label: 'Top Match',
                value: '$topMatchPercentage%',
              ),
              const SizedBox(width: 10),
              _StatCard(
                label: 'Best Value',
                value: '$bestValuePercentage%',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
