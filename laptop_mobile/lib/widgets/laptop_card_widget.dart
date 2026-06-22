import 'package:flutter/material.dart';
import '../models/laptop_model.dart';

class LaptopCardWidget extends StatelessWidget {
  final LaptopModel laptop;
  final int rank;
  final int matchPercent;
  final bool isPrimary;
  final VoidCallback? onViewSpecs;
  final VoidCallback? onCompare;

  const LaptopCardWidget({
    super.key,
    required this.laptop,
    required this.rank,
    required this.matchPercent,
    this.isPrimary = false,
    this.onViewSpecs,
    this.onCompare,
  });

  Color get _matchColor {
    if (matchPercent >= 95) return const Color(0xFF1A73E8);
    if (matchPercent >= 85) return const Color(0xFF10B981);
    if (matchPercent >= 75) return const Color(0xFF7C3AED);
    return const Color(0xFF6B7280);
  }

  Color get _categoryColor {
    switch (laptop.kategori.toLowerCase()) {
      case 'gaming':
        return const Color(0xFFFF6B6B);
      case 'programming':
        return const Color(0xFF4ECDC4);
      case 'office':
        return const Color(0xFFFFA502);
      default:
        return const Color(0xFF1A73E8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            _ProductImage(
              kategori: laptop.kategori,
              isFeatured: rank == 1,
              categoryColor: _categoryColor,
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Match badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              laptop.product,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                                height: 1.25,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              laptop.company,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF9CA3AF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _MatchBadge(
                        percent: matchPercent,
                        color: _matchColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  // Spec badges
                  Wrap(
                    spacing: 5,
                    runSpacing: 4,
                    children: [
                      _SpecBadge(
                        icon: Icons.memory_outlined,
                        label: laptop.ramLabel,
                      ),
                      _SpecBadge(
                        icon: Icons.developer_board_outlined,
                        label: laptop.cpu,
                      ),
                      if (laptop.opSys != null && laptop.opSys!.isNotEmpty)
                        _SpecBadge(
                          icon: Icons.laptop_outlined,
                          label: laptop.opSys!,
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Price + Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PRICE',
                            style: TextStyle(
                              fontSize: 8,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          Text(
                            laptop.priceFormatted,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                      _ActionButton(
                        isPrimary: isPrimary,
                        onPressed: isPrimary ? onViewSpecs : onCompare,
                        label: isPrimary ? 'View Specs' : 'Compare',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ─────────────────────────────────────────────────

class _ProductImage extends StatelessWidget {
  final String kategori;
  final bool isFeatured;
  final Color categoryColor;

  const _ProductImage({
    required this.kategori,
    required this.isFeatured,
    required this.categoryColor,
  });

  IconData get _icon {
    switch (kategori.toLowerCase()) {
      case 'gaming':
        return Icons.sports_esports_outlined;
      case 'programming':
        return Icons.code;
      case 'office':
        return Icons.work_outline;
      default:
        return Icons.laptop_mac;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: categoryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: categoryColor.withValues(alpha: 0.20),
            ),
          ),
          child: Center(
            child: Icon(
              _icon,
              size: 34,
              color: categoryColor.withValues(alpha: 0.85),
            ),
          ),
        ),
        if (isFeatured)
          Positioned(
            top: -6,
            left: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB800),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'FEATURED',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _MatchBadge extends StatelessWidget {
  final int percent;
  final Color color;

  const _MatchBadge({required this.percent, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Text(
            '$percent%',
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'MATCH',
            style: TextStyle(
              color: color,
              fontSize: 7,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SpecBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: const Color(0xFF6B7280)),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF374151),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final bool isPrimary;
  final VoidCallback? onPressed;
  final String label;

  const _ActionButton({
    required this.isPrimary,
    this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A73E8),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1A73E8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        side: const BorderSide(color: Color(0xFF1A73E8)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}