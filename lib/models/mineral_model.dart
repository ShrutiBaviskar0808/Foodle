class MineralModel {
  final String name;
  final String mineralId;
  final String formula;
  final List<String> images;
  final PhysicalProperties physicalProperties;
  final String description;

  MineralModel({
    required this.name,
    required this.mineralId,
    required this.formula,
    required this.images,
    required this.physicalProperties,
    required this.description,
  });

  factory MineralModel.fromJson(Map<String, dynamic> json) {
    return MineralModel(
      name: json['name'] ?? '',
      mineralId: json['mineralId'] ?? '',
      formula: json['formula'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      physicalProperties: PhysicalProperties.fromJson(json['physicalProperties'] ?? {}),
      description: json['description'] ?? '',
    );
  }
}

class PhysicalProperties {
  final String color;
  final String hardness;
  final String luster;
  final String crystalSystem;
  final String specificGravity;
  final String streak;
  final String transparency;
  final String cleavage;

  PhysicalProperties({
    required this.color,
    required this.hardness,
    required this.luster,
    required this.crystalSystem,
    required this.specificGravity,
    required this.streak,
    required this.transparency,
    required this.cleavage,
  });

  factory PhysicalProperties.fromJson(Map<String, dynamic> json) {
    return PhysicalProperties(
      color: json['color'] ?? '',
      hardness: json['hardness'] ?? '',
      luster: json['luster'] ?? '',
      crystalSystem: json['crystalSystem'] ?? '',
      specificGravity: json['specificGravity'] ?? '',
      streak: json['streak'] ?? '',
      transparency: json['transparency'] ?? '',
      cleavage: json['cleavage'] ?? '',
    );
  }
}
