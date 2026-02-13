class StoneModel {
  final int id;
  final String stoneName;
  final String stoneDescription;
  final String thumbImageUrl;
  final List<String> images;
  final GemProperties gemProperties;

  StoneModel({
    required this.id,
    required this.stoneName,
    required this.stoneDescription,
    required this.thumbImageUrl,
    required this.images,
    required this.gemProperties,
  });

  factory StoneModel.fromJson(Map<String, dynamic> json) {
    // Extract images from imageUrl1, imageUrl2, imageUrl3
    List<String> imagesList = [];
    if (json['imageUrl1'] != null && json['imageUrl1'].toString().isNotEmpty) {
      imagesList.add(json['imageUrl1']);
    }
    if (json['imageUrl2'] != null && json['imageUrl2'].toString().isNotEmpty) {
      imagesList.add(json['imageUrl2']);
    }
    if (json['imageUrl3'] != null && json['imageUrl3'].toString().isNotEmpty) {
      imagesList.add(json['imageUrl3']);
    }
    
    return StoneModel(
      id: json['id'],
      stoneName: json['stoneName'],
      stoneDescription: json['stoneDescription'],
      thumbImageUrl: json['thumbImageUrl'],
      images: imagesList,
      gemProperties: GemProperties.fromJson(json['gemProperties']),
    );
  }
}

class GemProperties {
  final String colors;
  final String rarity;
  final String jewelryUse;
  final String durability;
  final String transparency;
  final String opticalEffects;
  final String hardness;
  final String luster;

  GemProperties({
    required this.colors,
    required this.rarity,
    required this.jewelryUse,
    required this.durability,
    required this.transparency,
    required this.opticalEffects,
    required this.hardness,
    required this.luster,
  });

  factory GemProperties.fromJson(Map<String, dynamic> json) {
    return GemProperties(
      colors: json['colors'] ?? '',
      rarity: json['rarity'] ?? '',
      jewelryUse: json['jewelryUse'] ?? '',
      durability: json['durability'] ?? '',
      transparency: json['transparency'] ?? '',
      opticalEffects: json['opticalEffects'] ?? '',
      hardness: json['hardness'] ?? '',
      luster: json['luster'] ?? '',
    );
  }
}
