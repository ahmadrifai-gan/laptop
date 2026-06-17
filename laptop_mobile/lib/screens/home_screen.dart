import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/recommendation_provider.dart';
import '../widgets/search_banner_widget.dart';
import '../widgets/filter_row_widget.dart';
import '../widgets/laptop_card_widget.dart';
import '../models/laptop_model.dart';
import 'input_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _HomeTab(onGoToSearch: () => _onNavTapped(1)),
          InputScreen(onSearchDone: () => _onNavTapped(0)),
          const _MyPicksTab(),
          const AboutScreen(),
        ],
      ),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}

// ── Bottom Navigation Bar ─────────────────────────────────────

class _BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNavBar({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Home'},
      {'icon': Icons.search_outlined, 'activeIcon': Icons.search, 'label': 'Search'},
      {'icon': Icons.bookmark_outline, 'activeIcon': Icons.bookmark, 'label': 'My Picks'},
      {'icon': Icons.person_outline, 'activeIcon': Icons.person, 'label': 'Profile'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final isSelected = i == selectedIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF1A73E8).withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? item['activeIcon'] as IconData
                            : item['icon'] as IconData,
                        size: 22,
                        color: isSelected
                            ? const Color(0xFF1A73E8)
                            : const Color(0xFF9CA3AF),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 6),
                        Text(
                          item['label'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A73E8),
                          ),
                        ),
                      ],
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

// ── Home Tab ──────────────────────────────────────────────────

class _HomeTab extends StatelessWidget {
  final VoidCallback onGoToSearch;
  const _HomeTab({required this.onGoToSearch});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecommendationProvider>(
      builder: (context, provider, _) {
        return CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              pinned: true,
              backgroundColor: const Color(0xFF0D1B3E),
              systemOverlayStyle: SystemUiOverlayStyle.light,
              toolbarHeight: 64,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: const Color(0xFF0D1B3E),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A73E8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.laptop_mac, size: 20, color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'LapTopia',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              Text(
                                'PRECISION DISCOVERY',
                                style: TextStyle(
                                  color: Color(0xFF5B9EF4),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          _NotificationBell(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            if (provider.state == AppState.success &&
                provider.recommendations != null) ...[
              // Search Banner
              SliverToBoxAdapter(
                child: SearchBannerWidget(
                  searchQuery: provider.searchQuery,
                  topMatchPercent: provider.topMatchPercent,
                  bestValuePercent: provider.bestValuePercent,
                ),
              ),
              // Filter Row
              SliverToBoxAdapter(
                child: FilterRowWidget(
                  filters: provider.activeFilters.map((f) => FilterChipData(
                    label: f['label'] ?? '',
                    removable: f['removable'] == 'true',
                    hasDropdown: f['dropdown'] == 'true',
                  )).toList(),
                  onClearAll: () => provider.clearFilters(),
                  onRemoveFilter: (i) => provider.removeFilter(i),
                ),
              ),
              // Results count
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    '${provider.rankedRecommendations.length} laptop ditemukan',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
              ),
              // Laptop Cards
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = provider.rankedRecommendations[index];
                    final laptop = item['laptop'] as LaptopModel;
                    final match = item['match'] as int;
                    final rank = item['rank'] as int;
                    return LaptopCardWidget(
                      laptop: laptop,
                      rank: rank,
                      matchPercent: match,
                      isPrimary: rank == 1 || rank % 2 == 1,
                      onViewSpecs: () {
                        _showLaptopDetail(context, laptop);
                      },
                      onCompare: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${laptop.product} ditambahkan ke perbandingan'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    );
                  },
                  childCount: provider.rankedRecommendations.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ] else if (provider.state == AppState.loading) ...[
              const SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Color(0xFF1A73E8)),
                      SizedBox(height: 16),
                      Text('Menganalisis kebutuhanmu...', style: TextStyle(color: Color(0xFF6B7280))),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Empty / Welcome state
              SliverFillRemaining(
                hasScrollBody: false,
                child: _WelcomeState(onSearch: onGoToSearch),
              ),
            ],
          ],
        );
      },
    );
  }

  void _showLaptopDetail(BuildContext context, LaptopModel laptop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LaptopDetailSheet(laptop: laptop),
    );
  }
}

// ── Notification Bell ─────────────────────────────────────────

class _NotificationBell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
        ),
        Positioned(
          top: 8,
          right: 8,
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
    );
  }
}

// ── Welcome State ─────────────────────────────────────────────

class _WelcomeState extends StatelessWidget {
  final VoidCallback onSearch;
  const _WelcomeState({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFF1A73E8).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(Icons.laptop_mac, size: 48, color: Color(0xFF1A73E8)),
          ),
          const SizedBox(height: 24),
          const Text(
            'Temukan Laptop\nTerbaik Untukmu',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Rekomendasi berbasis AI dengan akurasi 96.93%\nBerdasarkan 1.303 data laptop',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280), height: 1.5),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: onSearch,
            icon: const Icon(Icons.search),
            label: const Text('Mulai Cari Laptop', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A73E8),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
          ),
          const SizedBox(height: 16),
          // Category pills
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CategoryPill('🎮 Gaming', const Color(0xFFFF6B6B)),
              const SizedBox(width: 8),
              _CategoryPill('💻 Programming', const Color(0xFF4ECDC4)),
              const SizedBox(width: 8),
              _CategoryPill('📁 Office', const Color(0xFFFFA502)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String label;
  final Color color;
  const _CategoryPill(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

// ── My Picks Tab ──────────────────────────────────────────────

class _MyPicksTab extends StatelessWidget {
  const _MyPicksTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B3E),
        title: const Text('My Picks', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bookmark_outline, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('Belum ada laptop tersimpan', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            const Text('Bookmark laptop favoritmu dari hasil rekomendasi',
                style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
          ],
        ),
      ),
    );
  }
}

// ── Laptop Detail Bottom Sheet ────────────────────────────────

class _LaptopDetailSheet extends StatelessWidget {
  final LaptopModel laptop;
  const _LaptopDetailSheet({required this.laptop});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    laptop.fullName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(laptop.kategori,
                      style: const TextStyle(color: Color(0xFF1A73E8), fontWeight: FontWeight.w600)),
                  const SizedBox(height: 20),
                  _DetailRow('Tipe', laptop.typeName),
                  _DetailRow('CPU', laptop.cpu),
                  _DetailRow('RAM', laptop.ramLabel),
                  _DetailRow('Storage', laptop.memoryLabel),
                  _DetailRow('GPU', laptop.gpu),
                  if (laptop.opSys != null) _DetailRow('OS', laptop.opSys!),
                  if (laptop.weightLabel != null) _DetailRow('Berat', laptop.weightLabel!),
                  if (laptop.inches != null) _DetailRow('Layar', '${laptop.inches}"'),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A73E8).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Harga', style: TextStyle(fontWeight: FontWeight.w600)),
                        Text(
                          laptop.priceFormatted,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A73E8),
                          ),
                        ),
                      ],
                    ),
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

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
