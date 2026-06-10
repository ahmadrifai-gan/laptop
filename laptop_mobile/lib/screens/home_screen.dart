import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../widgets/search_banner_widget.dart';
import '../widgets/filter_row_widget.dart';
import '../widgets/laptop_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FB),
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── AppBar ──────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 16,
      title: Row(
        children: [
          // Logo icon circle
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFF1A73E8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.laptop_mac, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'LapTopia',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2040),
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'PRECISION DISCOVERY',
                style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF888EA8),
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Color(0xFF444B6E),
                size: 24,
              ),
              onPressed: () {},
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A73E8),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: const Color(0xFFF0F1F6), height: 1),
      ),
    );
  }

  // ─── Body ────────────────────────────────────────────────────────────────────
  Widget _buildBody() {
    final laptops = DummyData.laptops;

    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      children: [
        // Search context banner
        SearchBannerWidget(
          searchQuery: DummyData.recentSearch,
          topMatchPercentage: DummyData.topMatchPercentage,
          bestValuePercentage: DummyData.bestValuePercentage,
        ),

        const SizedBox(height: 4),

        // Filter row
        FilterRowWidget(
          filters: DummyData.activeFilters,
          onClearAll: () {},
        ),

        const SizedBox(height: 4),

        // Laptop cards
        ...laptops.asMap().entries.map((entry) {
          final index = entry.key;
          final laptop = entry.value;
          return LaptopCardWidget(
            laptop: laptop,
            // First card (highest match) uses primary blue button style
            isPrimary: index == 0,
          );
        }),
      ],
    );
  }

  // ─── Bottom Navigation ────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    const items = [
      _NavItem(icon: Icons.home_rounded, label: 'Home'),
      _NavItem(icon: Icons.search_rounded, label: 'Search'),
      _NavItem(icon: Icons.bookmark_rounded, label: 'My Picks'),
      _NavItem(icon: Icons.person_rounded, label: 'Profile'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF0F1F6), width: 1)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 62,
          child: Row(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = _selectedNavIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedNavIndex = index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: isSelected
                                                        ? const Color(0xFF1A73E8).withValues(alpha: 0.1)
                                                        : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          item.icon,
                          size: 22,
                          color: isSelected
                              ? const Color(0xFF1A73E8)
                              : const Color(0xFFAEB3CC),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFF1A73E8)
                              : const Color(0xFFAEB3CC),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}
