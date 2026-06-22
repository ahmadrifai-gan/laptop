// Input Specs Screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../laptop_prediction_provider.dart';

class InputSpecsScreen extends StatefulWidget {
  const InputSpecsScreen({Key? key}) : super(key: key);

  @override
  State<InputSpecsScreen> createState() => _InputSpecsScreenState();
}

class _InputSpecsScreenState extends State<InputSpecsScreen> {
  late TextEditingController _typeNameController;
  late TextEditingController _ramController;
  late TextEditingController _memoryController;
  late TextEditingController _cpuController;
  late TextEditingController _gpuController;
  late TextEditingController _weightController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<LaptopPredictionProvider>();
    _typeNameController = TextEditingController(text: provider.specs['TypeName']);
    _ramController = TextEditingController(text: provider.specs['Ram']);
    _memoryController = TextEditingController(text: provider.specs['Memory']);
    _cpuController = TextEditingController(text: provider.specs['Cpu']);
    _gpuController = TextEditingController(text: provider.specs['Gpu']);
    _weightController = TextEditingController(text: provider.specs['Weight']);
    _priceController = TextEditingController(text: provider.specs['Price_euros'].toString());
  }

  @override
  void dispose() {
    _typeNameController.dispose();
    _ramController.dispose();
    _memoryController.dispose();
    _cpuController.dispose();
    _gpuController.dispose();
    _weightController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laptop Specifications'),
        centerTitle: true,
      ),
      body: Consumer<LaptopPredictionProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Preset Buttons
                const Text(
                  'Quick Select Presets',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildPresetButton('Gaming', () {
                        provider.updateSpecs(DefaultSpecs.gaming);
                        _updateControllers(provider);
                      }),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildPresetButton('Programming', () {
                        provider.updateSpecs(DefaultSpecs.programming);
                        _updateControllers(provider);
                      }),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildPresetButton('Office', () {
                        provider.updateSpecs(DefaultSpecs.office);
                        _updateControllers(provider);
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Form Fields
                _buildTextField(
                  'Type Name',
                  _typeNameController,
                  (value) => provider.updateSpec('TypeName', value),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'RAM',
                  _ramController,
                  (value) => provider.updateSpec('Ram', value),
                  hint: 'e.g., 16GB',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'Memory/Storage',
                  _memoryController,
                  (value) => provider.updateSpec('Memory', value),
                  hint: 'e.g., 512GB SSD',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'CPU',
                  _cpuController,
                  (value) => provider.updateSpec('Cpu', value),
                  hint: 'e.g., Intel Core i7',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'GPU',
                  _gpuController,
                  (value) => provider.updateSpec('Gpu', value),
                  hint: 'e.g., Nvidia GeForce GTX 1650',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'Weight',
                  _weightController,
                  (value) => provider.updateSpec('Weight', value),
                  hint: 'e.g., 1.5kg',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'Price (EUR)',
                  _priceController,
                  (value) {
                    final price = double.tryParse(value) ?? 0;
                    provider.updateSpec('Price_euros', price);
                  },
                  keyboardType: TextInputType.number,
                  hint: 'e.g., 1500',
                ),
                const SizedBox(height: 24),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          await provider.predictAndRecommend();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Predicting...')),
                            );
                          }
                        },
                        icon: const Icon(Icons.search),
                        label: const Text('Predict & Recommend'),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            provider.resetSpecs();
                            _updateControllers(provider);
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPresetButton(String label, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    Function(String) onChanged, {
    TextInputType keyboardType = TextInputType.text,
    String hint = '',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  void _updateControllers(LaptopPredictionProvider provider) {
    _typeNameController.text = provider.specs['TypeName'];
    _ramController.text = provider.specs['Ram'];
    _memoryController.text = provider.specs['Memory'];
    _cpuController.text = provider.specs['Cpu'];
    _gpuController.text = provider.specs['Gpu'];
    _weightController.text = provider.specs['Weight'];
    _priceController.text = provider.specs['Price_euros'].toString();
  }
}
