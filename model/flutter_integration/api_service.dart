// HTTP Service untuk API communication

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'models.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  final http.Client _client = http.Client();

  /// Get available laptop categories
  Future<CategoriesResponse> getCategories() async {
    try {
      final url = Uri.parse('$API_BASE_URL$API_CATEGORIES');
      
      final response = await _client.get(url).timeout(
        const Duration(seconds: API_TIMEOUT_SECONDS),
        onTimeout: () => throw ApiError(
          message: 'Request timeout - Server tidak merespons',
          code: 'TIMEOUT',
        ),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return CategoriesResponse.fromJson(json);
      } else {
        throw ApiError(
          message: 'Failed to fetch categories (${response.statusCode})',
          code: 'HTTP_ERROR',
        );
      }
    } on ApiError rethrow;
    catch (e) {
      throw ApiError(
        message: 'Error fetching categories: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Predict laptop category based on specs
  Future<PredictionResponse> predictLaptop({
    required String typeName,
    required String ram,
    required String memory,
    required String cpu,
    required String gpu,
    required String weight,
    required double priceEuros,
  }) async {
    try {
      final url = Uri.parse('$API_BASE_URL$API_PREDICT');
      
      final body = jsonEncode({
        'TypeName': typeName,
        'Ram': ram,
        'Memory': memory,
        'Cpu': cpu,
        'Gpu': gpu,
        'Weight': weight,
        'Price_euros': priceEuros,
      });

      print('[API] POST $url');
      print('[API] Body: $body');

      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      ).timeout(
        const Duration(seconds: API_TIMEOUT_SECONDS),
        onTimeout: () => throw ApiError(
          message: 'Prediction request timeout',
          code: 'TIMEOUT',
        ),
      );

      print('[API] Response: ${response.statusCode}');
      print('[API] Body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return PredictionResponse.fromJson(json);
      } else if (response.statusCode == 422) {
        final json = jsonDecode(response.body);
        throw ApiError(
          message: 'Validation error: ${jsonEncode(json['errors'])}',
          code: 'VALIDATION_ERROR',
        );
      } else {
        final json = jsonDecode(response.body);
        throw ApiError(
          message: json['message'] ?? 'Prediction failed',
          code: 'API_ERROR',
        );
      }
    } on ApiError rethrow;
    catch (e) {
      throw ApiError(
        message: 'Error predicting: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Get laptop recommendations
  Future<RecommendationsResponse> getRecommendations({
    required String typeName,
    required String ram,
    required String memory,
    required String cpu,
    required String gpu,
    required String weight,
    required double priceEuros,
    int topN = 5,
  }) async {
    try {
      final url = Uri.parse('$API_BASE_URL$API_RECOMMENDATIONS');
      
      final body = jsonEncode({
        'TypeName': typeName,
        'Ram': ram,
        'Memory': memory,
        'Cpu': cpu,
        'Gpu': gpu,
        'Weight': weight,
        'Price_euros': priceEuros,
        'top_n': topN,
      });

      print('[API] POST $url');
      print('[API] Body: $body');

      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      ).timeout(
        const Duration(seconds: API_TIMEOUT_SECONDS),
        onTimeout: () => throw ApiError(
          message: 'Recommendation request timeout',
          code: 'TIMEOUT',
        ),
      );

      print('[API] Response: ${response.statusCode}');
      print('[API] Body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return RecommendationsResponse.fromJson(json);
      } else if (response.statusCode == 422) {
        final json = jsonDecode(response.body);
        throw ApiError(
          message: 'Validation error: ${jsonEncode(json['errors'])}',
          code: 'VALIDATION_ERROR',
        );
      } else {
        final json = jsonDecode(response.body);
        throw ApiError(
          message: json['message'] ?? 'Recommendations failed',
          code: 'API_ERROR',
        );
      }
    } on ApiError rethrow;
    catch (e) {
      throw ApiError(
        message: 'Error getting recommendations: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Batch predict and recommend (convenience method)
  Future<(PredictionResponse, RecommendationsResponse)> predictAndRecommend({
    required String typeName,
    required String ram,
    required String memory,
    required String cpu,
    required String gpu,
    required String weight,
    required double priceEuros,
  }) async {
    try {
      // Run both requests in parallel
      final results = await Future.wait([
        predictLaptop(
          typeName: typeName,
          ram: ram,
          memory: memory,
          cpu: cpu,
          gpu: gpu,
          weight: weight,
          priceEuros: priceEuros,
        ),
        getRecommendations(
          typeName: typeName,
          ram: ram,
          memory: memory,
          cpu: cpu,
          gpu: gpu,
          weight: weight,
          priceEuros: priceEuros,
        ),
      ]);

      return (results[0] as PredictionResponse, results[1] as RecommendationsResponse);
    } catch (e) {
      rethrow;
    }
  }

  /// Check server connectivity
  Future<bool> checkServerConnection() async {
    try {
      final url = Uri.parse('$API_BASE_URL$API_CATEGORIES');
      final response = await _client.get(url).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
