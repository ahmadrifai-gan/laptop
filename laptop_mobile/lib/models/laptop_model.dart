class LaptopModel {
  final String id;
  final int? laptopId;
  final String company;
  final String product;
  final String typeName;
  final double? inches;
  final String? screenResolution;
  final String cpu;
  final int ram;
  final String ramLabel;
  final int memory;
  final String memoryLabel;
  final String gpu;
  final String? opSys;
  final double? weight;
  final String? weightLabel;
  final double priceEuros;
  final String priceFormatted;
  final String kategori;

  LaptopModel({
    required this.id,
    this.laptopId,
    required this.company,
    required this.product,
    required this.typeName,
    this.inches,
    this.screenResolution,
    required this.cpu,
    required this.ram,
    required this.ramLabel,
    required this.memory,
    required this.memoryLabel,
    required this.gpu,
    this.opSys,
    this.weight,
    this.weightLabel,
    required this.priceEuros,
    required this.priceFormatted,
    required this.kategori,
  });

  factory LaptopModel.fromJson(Map<String, dynamic> json) {
    return LaptopModel(
      id: json['id']?.toString() ?? '',
      laptopId: json['laptop_id'] as int?,
      company: json['company'] ?? '',
      product: json['product'] ?? '',
      typeName: json['type_name'] ?? '',
      inches: (json['inches'] as num?)?.toDouble(),
      screenResolution: json['screen_resolution'],
      cpu: json['cpu'] ?? '',
      ram: (json['ram'] as num?)?.toInt() ?? 0,
      ramLabel: json['ram_label'] ?? '${json['ram']}GB',
      memory: (json['memory'] as num?)?.toInt() ?? 0,
      memoryLabel: json['memory_label'] ?? '${json['memory']}GB',
      gpu: json['gpu'] ?? '',
      opSys: json['op_sys'],
      weight: (json['weight'] as num?)?.toDouble(),
      weightLabel: json['weight_label'],
      priceEuros: (json['price_euros'] as num?)?.toDouble() ?? 0,
      priceFormatted: json['price_formatted'] ?? '€${json['price_euros']}',
      kategori: json['kategori'] ?? '',
    );
  }

  String get fullName => '$company $product';
}

class PredictionResult {
  final String prediction;
  final double confidence;
  final bool success;

  PredictionResult({
    required this.prediction,
    required this.confidence,
    required this.success,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      prediction: json['prediction'] ?? '',
      confidence:
          double.tryParse(json['confidence']?.toString() ?? '0') ?? 0,
      success: json['success'] ?? false,
    );
  }
}

class RecommendationResult {
  final String kategoriDiprediksi;
  final double confidence;
  final int totalRecommendations;
  final List<LaptopModel> recommendations;
  final bool success;

  RecommendationResult({
    required this.kategoriDiprediksi,
    required this.confidence,
    required this.totalRecommendations,
    required this.recommendations,
    required this.success,
  });

  factory RecommendationResult.fromJson(Map<String, dynamic> json) {
    final recs = (json['recommendations'] as List<dynamic>? ?? [])
        .map((r) => LaptopModel.fromJson(r as Map<String, dynamic>))
        .toList();

    return RecommendationResult(
      kategoriDiprediksi: json['kategori_diprediksi'] ?? '',
      confidence:
          double.tryParse(json['confidence']?.toString() ?? '0') ?? 0,
      totalRecommendations: json['total_recommendations'] ?? recs.length,
      recommendations: recs,
      success: json['success'] ?? false,
    );
  }
}
