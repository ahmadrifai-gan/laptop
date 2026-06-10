import 'package:flutter/material.dart';
import '../models/laptop_model.dart';

class LaptopCardWidget extends StatelessWidget {
  final Laptop laptop;
  final bool isPrimary; // true = blue "View Specs", false = outlined button

  const LaptopCardWidget({
    super.key,
    required this.laptop,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Top row: image + info + match badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image with optional FEATURED badge
                _ProductImage(
                  imageUrl: laptop.imageUrl,
                  isFeatured: laptop.isFeatured,
                ),
                const SizedBox(width: 12),
                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + Match badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              laptop.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A2040),
                                height: 1.3,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          _MatchBadge(percentage: laptop.matchPercentage),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Processor • Color
                      Text(
                        '${laptop.processor} • ${laptop.color}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF888EA8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Specs row
                      Row(
                        children: [
                          _SpecBadge(
                            icon: Icons.memory,
                            label: laptop.ramLabel,
                          ),
                          const SizedBox(width: 8),
                          _SpecBadge(
                            icon: _specIcon(laptop.storageOrGpu),
                            label: laptop.storageOrGpu,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Divider
            Container(
              height: 1,
              color: const Color(0xFFF0F1F6),
            ),
            const SizedBox(height: 12),
            // Bottom row: Price + Action Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  laptop.priceFormatted,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A2040),
                  ),
                ),
                _ActionButton(
                  isPrimary: isPrimary,
                  label: isPrimary ? 'View Specs' : _buttonLabel(laptop),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _specIcon(String spec) {
    final lower = spec.toLowerCase();
    if (lower.contains('cpu') || lower.contains('core')) {
      return Icons.developer_board;
    } else if (lower.contains('rtx') || lower.contains('gpu')) {
      return Icons.videogame_asset;
    } else if (lower.contains('ssd') || lower.contains('tb') || lower.contains('gb')) {
      return Icons.storage;
    }
    return Icons.memory;
  }

  String _buttonLabel(Laptop laptop) {
    if (laptop.matchPercentage >= 85) return 'Compare';
    return 'View Specs';
  }
}

// ─── Product Image ────────────────────────────────────────────────────────────
class _ProductImage extends StatelessWidget {
  final String imageUrl;
  final bool isFeatured;

  const _ProductImage({required this.imageUrl, required this.isFeatured});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imageUrl,
            width: 90,
            height: 90,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _PlaceholderImage(),
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return _PlaceholderImage();
                        },
          ),
        ),
        if (isFeatured)
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: const BoxDecoration(
                color: Color(0xFFFFC107),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: const Text(
                'FEATURED',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2040),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.laptop_mac,
        size: 40,
        color: Color(0xFFBBBFD4),
      ),
    );
  }
}

// ─── Match Badge ──────────────────────────────────────────────────────────────
class _MatchBadge extends StatelessWidget {
  final int percentage;

  const _MatchBadge({required this.percentage});

  Color get _color {
    if (percentage >= 95) return const Color(0xFF1A73E8);
    if (percentage >= 85) return const Color(0xFF0B9E72);
    return const Color(0xFF7B61FF);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: _color,
            ),
          ),
          Text(
            'MATCH',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: _color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Spec Badge ───────────────────────────────────────────────────────────────
class _SpecBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SpecBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5FB),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF888EA8)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF444B6E),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Action Button ────────────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final bool isPrimary;
  final String label;

  const _ActionButton({required this.isPrimary, required this.label});

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A73E8),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF444B6E),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        side: const BorderSide(color: Color(0xFFCDD0E0), width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
