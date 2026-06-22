// Models untuk response dari API

class CategoriesResponse {
  final bool success;
  final List<String> categories;
  final String? message;

  CategoriesResponse({
    required this.success,
    required this.categories,
    this.message,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    return CategoriesResponse(
      success: json['success'] ?? false,
      categories: List<String>.from(json['data']['categories'] ?? []),
      message: json['message'],
    );
  }
}

class PredictionResponse {
  final bool success;
  final String prediction;
  final double confidence;
  final List<int> neighborIndices;
  final List<double> distances;
  final String? message;
  final String? error;

  PredictionResponse({
    required this.success,
    required this.prediction,
    required this.confidence,
    required this.neighborIndices,
    required this.distances,
    this.message,
    this.error,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    if (!json['success']) {
      return PredictionResponse(
        success: false,
        prediction: '',
        confidence: 0,
        neighborIndices: [],
        distances: [],
        error: json['error'] ?? json['message'],
      );
    }

    final data = json['data'] ?? {};
    return PredictionResponse(
      success: true,
      prediction: data['prediction'] ?? '',
      confidence: (data['confidence'] ?? 0).toDouble(),
      neighborIndices: List<int>.from(data['neighbors']['indices'] ?? []),
      distances: List<double>.from(
        (data['neighbors']['distances'] ?? []).map((e) => (e as num).toDouble()),
      ),
    );
  }
}

class LaptopRecommendation {
  final String? company;
  final String? product;
  final String? typeName;
  final int? ram;
  final int? memory;
  final String? cpu;
  final String? gpu;
  final double? weight;
  final double? price;
  final String? opSys;

  LaptopRecommendation({
    this.company,
    this.product,
    this.typeName,
    this.ram,
    this.memory,
    this.cpu,
    this.gpu,
    this.weight,
    this.price,
    this.opSys,
  });

  factory LaptopRecommendation.fromJson(Map<String, dynamic> json) {
    return LaptopRecommendation(
      company: json['Company'],
      product: json['Product'],
      typeName: json['TypeName'],
      ram: json['Ram'],
      memory: json['Memory'],
      cpu: json['Cpu'],
      gpu: json['Gpu'],
      weight: (json['Weight'] as num?)?.toDouble(),
      price: (json['Price_euros'] as num?)?.toDouble(),
      opSys: json['OpSys'],
    );
  }
}

class RecommendationsResponse {
  final bool success;
  final String kategoriDiprediksi;
  final double confidence;
  final int totalRecommendations;
  final List<LaptopRecommendation> recommendations;
  final String? message;
  final String? error;

  RecommendationsResponse({
    required this.success,
    required this.kategoriDiprediksi,
    required this.confidence,
    required this.totalRecommendations,
    required this.recommendations,
    this.message,
    this.error,
  });

  factory RecommendationsResponse.fromJson(Map<String, dynamic> json) {
    if (!json['success']) {
      return RecommendationsResponse(
        success: false,
        kategoriDiprediksi: '',
        confidence: 0,
        totalRecommendations: 0,
        recommendations: [],
        error: json['error'] ?? json['message'],
      );
    }

    final data = json['data'] ?? {};
    final recList = data['recommendations'] ?? [];
    
    return RecommendationsResponse(
      success: true,
      kategoriDiprediksi: data['kategori_diprediksi'] ?? '',
      confidence: (data['confidence'] ?? 0).toDouble(),
      totalRecommendations: data['total_recommendations'] ?? 0,
      recommendations: (recList as List)
          .map((e) => LaptopRecommendation.fromJson(e))
          .toList(),
    );
  }
}

class ApiError implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  ApiError({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => message;
}
