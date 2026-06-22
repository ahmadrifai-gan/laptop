import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
        backgroundColor: const Color(0xFF1A73E8),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A73E8).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(Icons.laptop_mac, size: 44, color: Color(0xFF1A73E8)),
                ),
                const SizedBox(height: 16),
                const Text('LapTopia', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text('Versi 1.0.0', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _InfoCard(
            title: 'Tentang Aplikasi',
            content: 'LapTopia adalah aplikasi rekomendasi laptop berbasis AI yang membantu pengguna menemukan laptop terbaik sesuai kebutuhan mereka.',
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Teknologi',
            items: const [
              'Algoritma: K-Nearest Neighbors (KNN)',
              'Akurasi Model: 96.93%',
              'Backend: Laravel 11',
              'Mobile: Flutter',
              'Dataset: 1303 laptop',
            ],
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Kategori Rekomendasi',
            items: const [
              '🎮 Gaming - Laptop bertenaga tinggi untuk gaming',
              '💻 Programming - Ideal untuk developer & programmer',
              '📁 Office - Ringan & efisien untuk pekerjaan kantor',
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String? content;
  final List<String>? items;

  const _InfoCard({required this.title, this.content, this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (content != null) Text(content!, style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.5)),
          if (items != null) ...items!.map((e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(children: [
              const Icon(Icons.check_circle_outline, size: 14, color: Color(0xFF1A73E8)),
              const SizedBox(width: 8),
              Expanded(child: Text(e, style: TextStyle(fontSize: 13, color: Colors.grey[700]))),
            ]),
          )),
        ],
      ),
    );
  }
}
