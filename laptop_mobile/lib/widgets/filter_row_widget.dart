import 'package:flutter/material.dart';

class FilterRowWidget extends StatefulWidget {
  final List<Map<String, String>> filters;
  final VoidCallback onClearAll;

  const FilterRowWidget({
    super.key,
    required this.filters,
    required this.onClearAll,
  });

  @override
  State<FilterRowWidget> createState() => _FilterRowWidgetState();
}

class _FilterRowWidgetState extends State<FilterRowWidget> {
  late List<Map<String, String>> _activeFilters;

  @override
  void initState() {
    super.initState();
    _activeFilters = List.from(widget.filters);
  }

  void _removeFilter(int index) {
    setState(() {
      _activeFilters.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        children: [
          // Header row: FILTERS + Clear All
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'FILTERS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF888EA8),
                  letterSpacing: 1.0,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() => _activeFilters.clear());
                  widget.onClearAll();
                },
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
          const SizedBox(height: 8),
          // Scrollable chip row
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _activeFilters.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _activeFilters[index];
                final isFirst = index == 0;
                return _FilterChip(
                  label: filter['label'] ?? '',
                  isActive: isFirst,
                  onRemove: isFirst ? () => _removeFilter(index) : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onRemove;

  const _FilterChip({
    required this.label,
    required this.isActive,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1A73E8) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? const Color(0xFF1A73E8)
              : const Color(0xFFCDD0E0),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : const Color(0xFF444B6E),
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.close,
                size: 14,
                color: isActive ? Colors.white : const Color(0xFF444B6E),
              ),
            ),
          ] else ...[
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: isActive ? Colors.white : const Color(0xFF444B6E),
            ),
          ],
        ],
      ),
    );
  }
}
