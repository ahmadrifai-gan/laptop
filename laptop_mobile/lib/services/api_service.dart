import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/laptop_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final _client = http.Client();
  final _timeout = Duration(seconds: AppConfig.timeoutSeconds);

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<bool> checkConnection() async {
    try {
      final response = await _client
          .get(Uri.parse('${AppConfig.apiUrl}/categories'), headers: _headers)
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<PredictionResult> predictLaptop({
    required String typeName,
    required String ram,
    required String memory,
    required String cpu,
    required String gpu,
    required String weight,
    required double priceEuros,
  }) async {
    final body = jsonEncode({
      'TypeName': typeName,
      'Ram': ram,
      'Memory': memory,
      'Cpu': cpu,
      'Gpu': gpu,
      'Weight': weight,
      'Price_euros': priceEuros,
    });

    final response = await _client
        .post(Uri.parse('${AppConfig.apiUrl}/predict'),
            headers: _headers, body: body)
        .timeout(_timeout);

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      return PredictionResult.fromJson(json);
    }
    throw Exception(json['message'] ?? 'Prediction failed');
  }

  Future<RecommendationResult> getRecommendations({
    required String typeName,
    required String ram,
    required String memory,
    required String cpu,
    required String gpu,
    required String weight,
    required double priceEuros,
    int topN = 5,
  }) async {
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

    final response = await _client
        .post(Uri.parse('${AppConfig.apiUrl}/recommendations'),
            headers: _headers, body: body)
        .timeout(_timeout);

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      return RecommendationResult.fromJson(json);
    }
    throw Exception(json['message'] ?? 'Recommendations failed');
  }

  Future<List<LaptopModel>> getLaptops({String? kategori}) async {
    var url = '${AppConfig.apiUrl}/laptops';
    if (kategori != null) url += '?kategori=$kategori';

    final response = await _client
        .get(Uri.parse(url), headers: _headers)
        .timeout(_timeout);

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      final data = json['data'];
      final list = (data is Map ? data['data'] : data) as List<dynamic>? ?? [];
      return list.map((e) => LaptopModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load laptops');
  }
}
