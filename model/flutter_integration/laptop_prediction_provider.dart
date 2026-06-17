// State Management Provider (using Provider package)

import 'package:flutter/foundation.dart';
import 'api_service.dart';
import 'models.dart';

class LaptopPredictionProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // State
  Map<String, dynamic> _specs = {
    'TypeName': 'Ultrabook',
    'Ram': '16GB',
    'Memory': '512GB SSD',
    'Cpu': 'Intel Core i7',
    'Gpu': 'Nvidia GeForce GTX 1650',
    'Weight': '1.5kg',
    'Price_euros': 1500.0,
  };
  
  PredictionResponse? _predictionResult;
  RecommendationsResponse? _recommendationsResult;
  bool _isLoading = false;
  String? _error;
  bool _serverConnected = false;

  // Getters
  Map<String, dynamic> get specs => _specs;
  PredictionResponse? get predictionResult => _predictionResult;
  RecommendationsResponse? get recommendationsResult => _recommendationsResult;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get serverConnected => _serverConnected;
  bool get hasPrediction => _predictionResult != null && _predictionResult!.success;
  bool get hasRecommendations => _recommendationsResult != null && _recommendationsResult!.success;

  // Setters
  void updateSpec(String key, dynamic value) {
    _specs[key] = value;
    notifyListeners();
  }

  void updateSpecs(Map<String, dynamic> newSpecs) {
    _specs.addAll(newSpecs);
    notifyListeners();
  }

  void resetSpecs() {
    _specs = {
      'TypeName': 'Ultrabook',
      'Ram': '16GB',
      'Memory': '512GB SSD',
      'Cpu': 'Intel Core i7',
      'Gpu': 'Nvidia GeForce GTX 1650',
      'Weight': '1.5kg',
      'Price_euros': 1500.0,
    };
    _predictionResult = null;
    _recommendationsResult = null;
    _error = null;
    notifyListeners();
  }

  // Check server connection
  Future<void> checkConnection() async {
    _serverConnected = await _apiService.checkServerConnection();
    notifyListeners();
  }

  // Predict laptop category
  Future<void> predictLaptop() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _predictionResult = await _apiService.predictLaptop(
        typeName: _specs['TypeName'] ?? '',
        ram: _specs['Ram'] ?? '',
        memory: _specs['Memory'] ?? '',
        cpu: _specs['Cpu'] ?? '',
        gpu: _specs['Gpu'] ?? '',
        weight: _specs['Weight'] ?? '',
        priceEuros: (_specs['Price_euros'] ?? 0).toDouble(),
      );

      if (!_predictionResult!.success) {
        _error = _predictionResult!.error ?? 'Prediction failed';
      }
    } on ApiError catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get recommendations
  Future<void> getRecommendations({int topN = 5}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _recommendationsResult = await _apiService.getRecommendations(
        typeName: _specs['TypeName'] ?? '',
        ram: _specs['Ram'] ?? '',
        memory: _specs['Memory'] ?? '',
        cpu: _specs['Cpu'] ?? '',
        gpu: _specs['Gpu'] ?? '',
        weight: _specs['Weight'] ?? '',
        priceEuros: (_specs['Price_euros'] ?? 0).toDouble(),
        topN: topN,
      );

      if (!_recommendationsResult!.success) {
        _error = _recommendationsResult!.error ?? 'Recommendations failed';
      }
    } on ApiError catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Predict and get recommendations in one call
  Future<void> predictAndRecommend({int topN = 5}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final (prediction, recommendations) = await _apiService.predictAndRecommend(
        typeName: _specs['TypeName'] ?? '',
        ram: _specs['Ram'] ?? '',
        memory: _specs['Memory'] ?? '',
        cpu: _specs['Cpu'] ?? '',
        gpu: _specs['Gpu'] ?? '',
        weight: _specs['Weight'] ?? '',
        priceEuros: (_specs['Price_euros'] ?? 0).toDouble(),
      );

      _predictionResult = prediction;
      _recommendationsResult = recommendations;

      if (!prediction.success) {
        _error = prediction.error ?? 'Prediction failed';
      } else if (!recommendations.success) {
        _error = recommendations.error ?? 'Recommendations failed';
      }
    } on ApiError catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear results
  void clearResults() {
    _predictionResult = null;
    _recommendationsResult = null;
    _error = null;
    notifyListeners();
  }
}
