import 'package:flutter/material.dart';

class FilterChipData {
  final String label;
  final bool removable;
  final bool hasDropdown;

  const FilterChipData({
    required this.label,
    this.removable = false,
    this.hasDropdown = false,
  });
}

class FilterRowWidget extends StatelessWidget {
  final List<FilterChipData> filters;
  final VoidCallback onClearAll;
  final ValueChanged<int> onRemoveFilter;

  const FilterRowWidget({
    super.key,
    required this.filters,
    required this.onClearAll,
    required this.onRemoveFilter,
  });

  @override
  Widget build(BuildContext context) {
    if (filters.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'FILTERS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: Color(0xFF6B7280),
                  ),
                ),
                GestureDetector(
                  onTap: onClearAll,
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A73E8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Chips row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 14),
            child: Row(
              children: filters.asMap().entries.map((entry) {
                final i = entry.key;
                final chip = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _FilterChip(
                    data: chip,
                    isFirst: i == 0,
                    onRemove: chip.removable ? () => onRemoveFilter(i) : null,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final FilterChipData data;
  final bool isFirst;
  final VoidCallback? onRemove;

  const _FilterChip({
    required this.data,
    required this.isFirst,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isFilled = isFirst;
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: isFilled ? const Color(0xFF1A73E8) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isFilled ? const Color(0xFF1A73E8) : const Color(0xFFD1D5DB),
        ),
        boxShadow: isFilled
            ? [
                BoxShadow(
                  color: const Color(0xFF1A73E8).withValues(alpha: 0.30),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 12,
              right: (data.removable || data.hasDropdown) ? 4 : 12,
            ),
            child: Text(
              data.label,
              style: TextStyle(
                color: isFilled ? Colors.white : const Color(0xFF374151),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (data.removable)
            GestureDetector(
              onTap: onRemove,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.close,
                  size: 13,
                  color: isFilled ? Colors.white : const Color(0xFF6B7280),
                ),
              ),
            ),
          if (data.hasDropdown)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: isFilled ? Colors.white : const Color(0xFF6B7280),
              ),
            ),
        ],
      ),
    );
  }
}