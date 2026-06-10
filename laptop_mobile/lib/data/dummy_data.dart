import '../models/laptop_model.dart';

class DummyData {
  static const String recentSearch = '4K Video Editing';
  static const int topMatchPercentage = 98;
  static const int bestValuePercentage = 84;

  // Dummy image URLs from public placeholder service
  static const String macbookImg =
      'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=300&h=200&fit=crop';
  static const String xpsImg =
      'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=300&h=200&fit=crop';
  static const String bladeImg =
      'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=300&h=200&fit=crop';

  static final List<Laptop> laptops = [
    Laptop(
      id: '1',
      name: 'MacBook Pro 16"',
      brand: 'Apple',
      processor: 'M3 Max',
      color: 'Space Black',
      ramLabel: '32GB RAM',
      storageOrGpu: '14-Core CPU',
      price: 2499,
      matchPercentage: 98,
      isFeatured: true,
      imageUrl: macbookImg,
      tags: ['Best for Creatives', 'Pro'],
    ),
    Laptop(
      id: '2',
      name: 'XPS 15 High Performance',
      brand: 'Dell',
      processor: 'i9-13900H',
      color: 'Platinum',
      ramLabel: '64GB RAM',
      storageOrGpu: 'RTX 4970',
      price: 2199,
      matchPercentage: 89,
      isFeatured: false,
      imageUrl: xpsImg,
      tags: ['Gaming', 'Creator'],
    ),
    Laptop(
      id: '3',
      name: 'Blade 14 Studio Edition',
      brand: 'Razer',
      processor: 'Ryzen 9',
      color: 'Mercury White',
      ramLabel: '16GB RAM',
      storageOrGpu: '1TB Gen4 SSD',
      price: 1899,
      matchPercentage: 82,
      isFeatured: false,
      imageUrl: bladeImg,
      tags: ['Portable', 'Value'],
    ),
  ];

  static final List<Map<String, String>> activeFilters = [
    {'label': 'Brand: Apple', 'key': 'brand'},
    {'label': 'Price: \$1500+', 'key': 'price'},
    {'label': 'RAM: 16GB+', 'key': 'ram'},
  ];
}
