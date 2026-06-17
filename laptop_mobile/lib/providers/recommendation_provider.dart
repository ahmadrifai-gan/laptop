import 'package:flutter/material.dart';
import '../models/laptop_model.dart';
import '../services/api_service.dart';

enum AppState { initial, loading, success, error }

class RecommendationProvider extends ChangeNotifier {
  final _api = ApiService();

  AppState _state = AppState.initial;
  String _errorMessage = '';
  bool _isConnected = false;

  PredictionResult? _prediction;
  RecommendationResult? _recommendations;

  // Search query display
  String _searchQuery = '';

  // Active filter chips
  List<Map<String, String>> _activeFilters = [];

  // Form data
  String typeName = 'Notebook';
  String ram = '8GB';
  String memory = '512GB SSD';
  String cpu = 'Intel Core i5';
  String gpu = 'Intel HD Graphics';
  String weight = '2.0kg';
  double priceEuros = 800;

  // Getters
  AppState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isConnected => _isConnected;
  PredictionResult? get prediction => _prediction;
  RecommendationResult? get recommendations => _recommendations;
  bool get isLoading => _state == AppState.loading;
  String get searchQuery => _searchQuery;
  List<Map<String, String>> get activeFilters => List.unmodifiable(_activeFilters);

  // Ranked recommendations with match percentage
  List<Map<String, dynamic>> get rankedRecommendations {
    if (_recommendations == null) return [];
    final laptops = _filteredLaptops;
    return laptops.asMap().entries.map((e) {
      final rank = e.key + 1;
      final laptop = e.value;
      final baseConf = _recommendations!.confidence;
      final match = rank == 1
          ? baseConf.round().clamp(80, 99)
          : (baseConf.round() - (rank - 1) * 9).clamp(65, 98);
      return {'laptop': laptop, 'match': match, 'rank': rank};
    }).toList();
  }

  List<LaptopModel> get _filteredLaptops {
    if (_recommendations == null) return [];
    var list = List<LaptopModel>.from(_recommendations!.recommendations);
    for (final f in _activeFilters) {
      final key = f['key']!;
      final val = f['value']!.toLowerCase();
      if (key == 'Brand') {
        list = list.where((l) => l.company.toLowerCase() == val).toList();
      } else if (key == 'Kategori') {
        list = list.where((l) => l.kategori.toLowerCase() == val).toList();
      }
    }
    return list;
  }

  int get topMatchPercent {
    if (rankedRecommendations.isEmpty) return 0;
    return rankedRecommendations.first['match'] as int;
  }

  int get bestValuePercent {
    if (rankedRecommendations.isEmpty) return 0;
    return (topMatchPercent - 14).clamp(60, 99);
  }

  Future<void> checkConnection() async {
    _isConnected = await _api.checkConnection();
    notifyListeners();
  }

  Future<void> getRecommendations() async {
    _state = AppState.loading;
    _errorMessage = '';
    _activeFilters = [];
    notifyListeners();

    try {
      final result = await _api.getRecommendations(
        typeName: typeName,
        ram: ram,
        memory: memory,
        cpu: cpu,
        gpu: gpu,
        weight: weight,
        priceEuros: priceEuros,
      );

      _recommendations = result;
      _state = AppState.success;

      // Build human-readable search query
      final cpuShort = cpu.replaceAll('Intel ', '').replaceAll('AMD ', '');
      _searchQuery = '$typeName, $cpuShort, $ram RAM';

      // Auto-add price filter chip
      _activeFilters = [
        {
          'key': 'Budget',
          'value': '≤€${priceEuros.toStringAsFixed(0)}',
          'label': 'Budget: ≤€${priceEuros.toStringAsFixed(0)}',
          'removable': 'true',
        },
        {
          'key': 'Kategori',
          'value': result.kategoriDiprediksi,
          'label': result.kategoriDiprediksi,
          'removable': 'false',
          'dropdown': 'true',
        },
      ];
    } catch (e) {
      _state = AppState.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }
    notifyListeners();
  }

  void removeFilter(int index) {
    if (index < _activeFilters.length) {
      _activeFilters.removeAt(index);
      notifyListeners();
    }
  }

  void clearFilters() {
    _activeFilters.clear();
    notifyListeners();
  }

  void reset() {
    _state = AppState.initial;
    _prediction = null;
    _recommendations = null;
    _errorMessage = '';
    _searchQuery = '';
    _activeFilters = [];
    notifyListeners();
  }
}
