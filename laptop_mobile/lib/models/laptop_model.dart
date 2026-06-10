class Laptop {
  final String id;
  final String name;
  final String brand;
  final String processor;
  final String color;
  final String ramLabel;
  final String storageOrGpu;
  final double price;
  final int matchPercentage;
  final bool isFeatured;
  final String imageUrl;
  final List<String> tags;

  const Laptop({
    required this.id,
    required this.name,
    required this.brand,
    required this.processor,
    required this.color,
    required this.ramLabel,
    required this.storageOrGpu,
    required this.price,
    required this.matchPercentage,
    this.isFeatured = false,
    required this.imageUrl,
    this.tags = const [],
  });

  String get priceFormatted =>
      '\$${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
}
