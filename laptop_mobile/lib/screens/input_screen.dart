import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/recommendation_provider.dart';

class InputScreen extends StatefulWidget {
  final VoidCallback? onSearchDone;
  const InputScreen({super.key, this.onSearchDone});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  String _typeName = 'Notebook';
  String _ram = '8GB';
  String _memory = '512GB SSD';
  String _cpu = 'Intel Core i5';
  String _gpu = 'Intel HD Graphics';
  String _weight = '2.0kg';
  double _price = 800;

  final _typeNames = ['Notebook', 'Ultrabook', 'Gaming', '2 in 1 Convertible', 'Workstation', 'Netbook'];
  final _rams = ['2GB', '4GB', '6GB', '8GB', '12GB', '16GB', '32GB', '64GB'];
  final _cpus = [
    'Intel Core i3', 'Intel Core i5', 'Intel Core i7', 'Intel Core i9',
    'AMD Ryzen 3', 'AMD Ryzen 5', 'AMD Ryzen 7', 'AMD Ryzen 9',
    'Intel Celeron', 'Intel Pentium',
  ];
  final _gpus = [
    'Intel HD Graphics', 'Intel UHD Graphics', 'Intel Iris Plus',
    'Nvidia GeForce GTX 1050', 'Nvidia GeForce GTX 1060', 'Nvidia GeForce GTX 1070',
    'Nvidia GeForce RTX 2060', 'Nvidia GeForce RTX 3060',
    'AMD Radeon RX 580', 'AMD Radeon Vega 8',
  ];

  void _applyPreset(String preset) {
    setState(() {
      switch (preset) {
        case 'gaming':
          _typeName = 'Gaming'; _ram = '16GB'; _memory = '512GB SSD';
          _cpu = 'Intel Core i7'; _gpu = 'Nvidia GeForce GTX 1060'; _weight = '2.5kg'; _price = 1500;
          break;
        case 'programming':
          _typeName = 'Ultrabook'; _ram = '16GB'; _memory = '512GB SSD';
          _cpu = 'Intel Core i7'; _gpu = 'Intel UHD Graphics'; _weight = '1.4kg'; _price = 1200;
          break;
        case 'office':
          _typeName = 'Notebook'; _ram = '8GB'; _memory = '256GB SSD';
          _cpu = 'Intel Core i5'; _gpu = 'Intel HD Graphics'; _weight = '1.8kg'; _price = 500;
          break;
      }
    });
  }

  Future<void> _submit() async {
    final provider = context.read<RecommendationProvider>();
    provider.typeName = _typeName;
    provider.ram = _ram;
    provider.memory = _memory;
    provider.cpu = _cpu;
    provider.gpu = _gpu;
    provider.weight = _weight;
    provider.priceEuros = _price;

    await provider.getRecommendations();

    if (!mounted) return;

    if (provider.state == AppState.success) {
      widget.onSearchDone?.call();
    } else if (provider.state == AppState.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1A73E8), width: 2)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B3E),
        title: const Text('Cari Rekomendasi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Preset Buttons
          const Text('Pilih Preset', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF374151))),
          const SizedBox(height: 10),
          Row(children: [
            _PresetButton(label: '🎮 Gaming', onTap: () => _applyPreset('gaming'), color: const Color(0xFFFF6B6B)),
            const SizedBox(width: 8),
            _PresetButton(label: '💻 Programming', onTap: () => _applyPreset('programming'), color: const Color(0xFF4ECDC4)),
            const SizedBox(width: 8),
            _PresetButton(label: '📁 Office', onTap: () => _applyPreset('office'), color: const Color(0xFFFFA502)),
          ]),
          const SizedBox(height: 22),

          _buildDropdown('Tipe Laptop', _typeName, _typeNames, (v) => setState(() => _typeName = v!)),
          _buildDropdown('RAM', _ram, _rams, (v) => setState(() => _ram = v!)),
          _buildDropdown('Prosesor (CPU)', _cpu, _cpus, (v) => setState(() => _cpu = v!)),
          _buildDropdown('Kartu Grafis (GPU)', _gpu, _gpus, (v) => setState(() => _gpu = v!)),

          // Storage field
          _buildTextField('Storage', _memory, 'Contoh: 512GB SSD', (v) => _memory = v),
          // Weight field
          _buildTextField('Berat', _weight, 'Contoh: 2.0kg', (v) => _weight = v),

          // Price Slider
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Budget', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A73E8).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '€${_price.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A73E8)),
                  ),
                ),
              ]),
              Slider(
                value: _price, min: 200, max: 5000, divisions: 96,
                activeColor: const Color(0xFF1A73E8),
                inactiveColor: const Color(0xFFE5E7EB),
                onChanged: (v) => setState(() => _price = v),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('€200', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                Text('€5000', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              ]),
              const SizedBox(height: 14),
            ],
          ),

          const SizedBox(height: 8),
          Consumer<RecommendationProvider>(
            builder: (context, provider, _) => ElevatedButton.icon(
              onPressed: provider.isLoading ? null : _submit,
              icon: provider.isLoading
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.auto_awesome),
              label: Text(
                provider.isLoading ? 'Menganalisis...' : 'Dapatkan Rekomendasi',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A73E8),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String initial, String hint, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initial,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1A73E8), width: 2)),
            filled: true, fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}

class _PresetButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
  const _PresetButton({required this.label, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Center(
            child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          ),
        ),
      ),
    );
  }
}
