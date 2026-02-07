class StoneData {
  final String name;
  final String type;
  final String formation;
  final String composition;
  final String hardness;
  final String color;
  final String uses;
  final int confidence;

  StoneData({
    required this.name,
    required this.type,
    required this.formation,
    required this.composition,
    required this.hardness,
    required this.color,
    required this.uses,
    required this.confidence,
  });
}

final List<StoneData> stoneDatabase = [
  StoneData(name: 'Granite', type: 'Igneous Rock', formation: 'Intrusive igneous rock formed from slowly cooling magma', composition: 'Quartz, Feldspar, Mica', hardness: '6-7 on Mohs scale', color: 'Pink, gray, white, or black', uses: 'Construction, monuments, countertops', confidence: 94),
  StoneData(name: 'Basalt', type: 'Igneous Rock', formation: 'Extrusive volcanic rock from rapid cooling lava', composition: 'Pyroxene, Plagioclase, Olivine', hardness: '5-6 on Mohs scale', color: 'Dark gray to black', uses: 'Road construction, concrete aggregate', confidence: 92),
  StoneData(name: 'Marble', type: 'Metamorphic Rock', formation: 'Metamorphosed limestone under heat and pressure', composition: 'Calcite, Dolomite', hardness: '3-4 on Mohs scale', color: 'White, pink, green, black', uses: 'Sculpture, building material, flooring', confidence: 89),
  StoneData(name: 'Limestone', type: 'Sedimentary Rock', formation: 'Formed from marine organisms and sediment', composition: 'Calcium Carbonate', hardness: '3-4 on Mohs scale', color: 'White, gray, yellow, brown', uses: 'Cement production, building stone', confidence: 91),
  StoneData(name: 'Sandstone', type: 'Sedimentary Rock', formation: 'Cemented sand grains over millions of years', composition: 'Quartz, Feldspar', hardness: '6-7 on Mohs scale', color: 'Red, brown, yellow, white', uses: 'Building material, paving', confidence: 88),
  StoneData(name: 'Slate', type: 'Metamorphic Rock', formation: 'Low-grade metamorphism of shale or mudstone', composition: 'Quartz, Muscovite, Chlorite', hardness: '3-4 on Mohs scale', color: 'Gray, black, green, purple', uses: 'Roofing, flooring, billiard tables', confidence: 87),
  StoneData(name: 'Quartzite', type: 'Metamorphic Rock', formation: 'Metamorphosed sandstone under high pressure', composition: 'Quartz', hardness: '7 on Mohs scale', color: 'White, gray, pink, red', uses: 'Decorative stone, countertops', confidence: 90),
  StoneData(name: 'Gneiss', type: 'Metamorphic Rock', formation: 'High-grade metamorphism with banded appearance', composition: 'Quartz, Feldspar, Mica', hardness: '6-7 on Mohs scale', color: 'Light and dark bands', uses: 'Building stone, decorative purposes', confidence: 86),
  StoneData(name: 'Obsidian', type: 'Igneous Rock', formation: 'Volcanic glass from rapid cooling lava', composition: 'Silica-rich volcanic glass', hardness: '5-6 on Mohs scale', color: 'Black, brown, green', uses: 'Jewelry, cutting tools, decorative', confidence: 93),
  StoneData(name: 'Pumice', type: 'Igneous Rock', formation: 'Volcanic rock with gas bubbles', composition: 'Volcanic glass, minerals', hardness: '6 on Mohs scale', color: 'White, gray, cream', uses: 'Abrasive, concrete aggregate', confidence: 85),
  StoneData(name: 'Shale', type: 'Sedimentary Rock', formation: 'Compacted clay and silt particles', composition: 'Clay minerals, Quartz', hardness: '2-3 on Mohs scale', color: 'Gray, black, brown, red', uses: 'Brick making, cement production', confidence: 84),
  StoneData(name: 'Conglomerate', type: 'Sedimentary Rock', formation: 'Rounded pebbles cemented together', composition: 'Various rock fragments', hardness: '4-6 on Mohs scale', color: 'Mixed colors', uses: 'Decorative stone, construction', confidence: 82),
  StoneData(name: 'Dolomite', type: 'Sedimentary Rock', formation: 'Chemical sedimentary rock from marine environments', composition: 'Calcium Magnesium Carbonate', hardness: '3.5-4 on Mohs scale', color: 'White, gray, pink', uses: 'Construction, agriculture', confidence: 88),
  StoneData(name: 'Schist', type: 'Metamorphic Rock', formation: 'Medium-grade metamorphism with foliated texture', composition: 'Mica, Quartz, Feldspar', hardness: '4-5 on Mohs scale', color: 'Gray, green, brown', uses: 'Decorative stone, roofing', confidence: 83),
  StoneData(name: 'Andesite', type: 'Igneous Rock', formation: 'Volcanic rock intermediate in composition', composition: 'Plagioclase, Pyroxene, Hornblende', hardness: '5-6 on Mohs scale', color: 'Gray, brown, green', uses: 'Road construction, aggregate', confidence: 87),
  StoneData(name: 'Rhyolite', type: 'Igneous Rock', formation: 'Volcanic rock similar to granite', composition: 'Quartz, Feldspar', hardness: '6-7 on Mohs scale', color: 'Light gray, pink, red', uses: 'Decorative stone, aggregate', confidence: 86),
  StoneData(name: 'Gabbro', type: 'Igneous Rock', formation: 'Intrusive igneous rock, coarse-grained', composition: 'Pyroxene, Plagioclase, Olivine', hardness: '6-7 on Mohs scale', color: 'Dark gray to black', uses: 'Dimension stone, monuments', confidence: 89),
  StoneData(name: 'Diorite', type: 'Igneous Rock', formation: 'Intrusive igneous rock, intermediate composition', composition: 'Plagioclase, Hornblende, Biotite', hardness: '6-7 on Mohs scale', color: 'Gray, dark gray', uses: 'Decorative stone, construction', confidence: 85),
  StoneData(name: 'Peridotite', type: 'Igneous Rock', formation: 'Ultramafic rock from Earth\'s mantle', composition: 'Olivine, Pyroxene', hardness: '6.5-7 on Mohs scale', color: 'Green, dark green', uses: 'Source of gemstones, research', confidence: 91),
  StoneData(name: 'Serpentinite', type: 'Metamorphic Rock', formation: 'Altered peridotite through hydration', composition: 'Serpentine minerals', hardness: '2.5-4 on Mohs scale', color: 'Green, yellow-green', uses: 'Decorative stone, asbestos source', confidence: 84),
  StoneData(name: 'Travertine', type: 'Sedimentary Rock', formation: 'Chemical precipitation from hot springs', composition: 'Calcium Carbonate', hardness: '3-4 on Mohs scale', color: 'White, tan, cream, brown', uses: 'Building facades, flooring', confidence: 88),
  StoneData(name: 'Breccia', type: 'Sedimentary Rock', formation: 'Angular rock fragments cemented together', composition: 'Various rock fragments', hardness: '4-6 on Mohs scale', color: 'Mixed colors', uses: 'Decorative stone, construction', confidence: 81),
  StoneData(name: 'Siltstone', type: 'Sedimentary Rock', formation: 'Compacted silt-sized particles', composition: 'Quartz, Clay minerals', hardness: '3-4 on Mohs scale', color: 'Gray, brown, red', uses: 'Building material, aggregate', confidence: 80),
  StoneData(name: 'Phyllite', type: 'Metamorphic Rock', formation: 'Low to medium-grade metamorphism of slate', composition: 'Quartz, Mica, Chlorite', hardness: '3-4 on Mohs scale', color: 'Gray, green, black', uses: 'Decorative stone, roofing', confidence: 82),
  StoneData(name: 'Amphibolite', type: 'Metamorphic Rock', formation: 'Metamorphosed basalt or gabbro', composition: 'Amphibole, Plagioclase', hardness: '5-6 on Mohs scale', color: 'Dark green to black', uses: 'Dimension stone, aggregate', confidence: 85),
  StoneData(name: 'Tuff', type: 'Igneous Rock', formation: 'Consolidated volcanic ash', composition: 'Volcanic ash, pumice fragments', hardness: '3-5 on Mohs scale', color: 'Gray, brown, yellow', uses: 'Building stone, lightweight aggregate', confidence: 83),
  StoneData(name: 'Chert', type: 'Sedimentary Rock', formation: 'Microcrystalline quartz from silica precipitation', composition: 'Microcrystalline Quartz', hardness: '7 on Mohs scale', color: 'White, gray, black, red', uses: 'Road construction, flint tools', confidence: 87),
  StoneData(name: 'Hornfels', type: 'Metamorphic Rock', formation: 'Contact metamorphism near igneous intrusions', composition: 'Various minerals', hardness: '6-7 on Mohs scale', color: 'Dark gray, black, brown', uses: 'Decorative stone, aggregate', confidence: 84),
  StoneData(name: 'Migmatite', type: 'Metamorphic Rock', formation: 'High-grade metamorphism with partial melting', composition: 'Quartz, Feldspar, Mica', hardness: '6-7 on Mohs scale', color: 'Mixed light and dark', uses: 'Decorative stone, dimension stone', confidence: 86),
  StoneData(name: 'Eclogite', type: 'Metamorphic Rock', formation: 'High-pressure metamorphism of basalt', composition: 'Garnet, Pyroxene', hardness: '7-8 on Mohs scale', color: 'Red and green', uses: 'Gemstones, research', confidence: 90),
  StoneData(name: 'Greywacke', type: 'Sedimentary Rock', formation: 'Poorly sorted sandstone with clay matrix', composition: 'Quartz, Feldspar, Rock fragments', hardness: '5-6 on Mohs scale', color: 'Gray, dark gray', uses: 'Building stone, aggregate', confidence: 81),
  StoneData(name: 'Arkose', type: 'Sedimentary Rock', formation: 'Feldspar-rich sandstone', composition: 'Feldspar, Quartz', hardness: '6-7 on Mohs scale', color: 'Pink, red, gray', uses: 'Building stone, decorative', confidence: 83),
  StoneData(name: 'Mudstone', type: 'Sedimentary Rock', formation: 'Compacted mud and clay', composition: 'Clay minerals, Silt', hardness: '2-3 on Mohs scale', color: 'Gray, brown, red', uses: 'Brick making, ceramics', confidence: 79),
  StoneData(name: 'Blueschist', type: 'Metamorphic Rock', formation: 'High-pressure, low-temperature metamorphism', composition: 'Glaucophane, Lawsonite', hardness: '6-7 on Mohs scale', color: 'Blue-gray', uses: 'Research, decorative stone', confidence: 88),
  StoneData(name: 'Granodiorite', type: 'Igneous Rock', formation: 'Intrusive igneous rock between granite and diorite', composition: 'Quartz, Plagioclase, Biotite', hardness: '6-7 on Mohs scale', color: 'Gray, light gray', uses: 'Building stone, monuments', confidence: 87),
  StoneData(name: 'Syenite', type: 'Igneous Rock', formation: 'Intrusive igneous rock with little quartz', composition: 'Alkali Feldspar, Hornblende', hardness: '6-7 on Mohs scale', color: 'Pink, gray, white', uses: 'Decorative stone, dimension stone', confidence: 85),
  StoneData(name: 'Pegmatite', type: 'Igneous Rock', formation: 'Very coarse-grained igneous rock', composition: 'Quartz, Feldspar, Mica', hardness: '6-7 on Mohs scale', color: 'White, pink, gray', uses: 'Source of gemstones, minerals', confidence: 89),
  StoneData(name: 'Scoria', type: 'Igneous Rock', formation: 'Vesicular volcanic rock', composition: 'Volcanic glass, minerals', hardness: '5-6 on Mohs scale', color: 'Dark red, black, brown', uses: 'Landscaping, lightweight aggregate', confidence: 84),
  StoneData(name: 'Dacite', type: 'Igneous Rock', formation: 'Volcanic rock intermediate in composition', composition: 'Plagioclase, Quartz, Pyroxene', hardness: '6-7 on Mohs scale', color: 'Light gray, brown', uses: 'Aggregate, decorative stone', confidence: 86),
  StoneData(name: 'Trachyte', type: 'Igneous Rock', formation: 'Volcanic rock rich in alkali feldspar', composition: 'Alkali Feldspar, minor Quartz', hardness: '6 on Mohs scale', color: 'Gray, white, pink', uses: 'Building stone, decorative', confidence: 83),
  StoneData(name: 'Phonolite', type: 'Igneous Rock', formation: 'Volcanic rock with nepheline', composition: 'Alkali Feldspar, Nepheline', hardness: '5-6 on Mohs scale', color: 'Gray, green, brown', uses: 'Decorative stone, aggregate', confidence: 82),
  StoneData(name: 'Komatiite', type: 'Igneous Rock', formation: 'Ancient ultramafic volcanic rock', composition: 'Olivine, Pyroxene', hardness: '6-7 on Mohs scale', color: 'Dark green, black', uses: 'Research, nickel ore source', confidence: 91),
  StoneData(name: 'Mylonite', type: 'Metamorphic Rock', formation: 'Fault zone metamorphism with fine grain', composition: 'Various minerals', hardness: '5-7 on Mohs scale', color: 'Gray, brown, green', uses: 'Research, decorative stone', confidence: 84),
  StoneData(name: 'Quartzite Schist', type: 'Metamorphic Rock', formation: 'Intermediate between quartzite and schist', composition: 'Quartz, Mica', hardness: '6-7 on Mohs scale', color: 'Gray, silver, brown', uses: 'Decorative stone, landscaping', confidence: 85),
  StoneData(name: 'Chalk', type: 'Sedimentary Rock', formation: 'Soft limestone from marine microorganisms', composition: 'Calcium Carbonate', hardness: '1-2 on Mohs scale', color: 'White, light gray', uses: 'Writing, cement production', confidence: 80),
  StoneData(name: 'Flint', type: 'Sedimentary Rock', formation: 'Hard variety of chert', composition: 'Microcrystalline Quartz', hardness: '7 on Mohs scale', color: 'Black, gray, brown', uses: 'Tools, fire starting, aggregate', confidence: 88),
  StoneData(name: 'Jasper', type: 'Sedimentary Rock', formation: 'Opaque variety of chalcedony', composition: 'Microcrystalline Quartz', hardness: '6.5-7 on Mohs scale', color: 'Red, yellow, brown, green', uses: 'Jewelry, decorative stone', confidence: 89),
  StoneData(name: 'Agate', type: 'Sedimentary Rock', formation: 'Banded variety of chalcedony', composition: 'Microcrystalline Quartz', hardness: '6.5-7 on Mohs scale', color: 'Various banded colors', uses: 'Jewelry, decorative objects', confidence: 90),
  StoneData(name: 'Onyx', type: 'Sedimentary Rock', formation: 'Parallel banded variety of chalcedony', composition: 'Microcrystalline Quartz', hardness: '6.5-7 on Mohs scale', color: 'Black and white bands', uses: 'Jewelry, decorative stone', confidence: 91),
  StoneData(name: 'Soapstone', type: 'Metamorphic Rock', formation: 'Talc-rich metamorphic rock', composition: 'Talc, Chlorite, Magnesite', hardness: '1-2 on Mohs scale', color: 'Gray, green, brown', uses: 'Carving, countertops, sinks', confidence: 86),
  StoneData(name: 'Alabaster', type: 'Sedimentary Rock', formation: 'Fine-grained gypsum or calcite', composition: 'Gypsum or Calcite', hardness: '2-3 on Mohs scale', color: 'White, cream, pink', uses: 'Sculpture, decorative objects', confidence: 87),
  StoneData(name: 'Serpentine', type: 'Metamorphic Rock', formation: 'Hydration of olivine-rich rocks', composition: 'Serpentine minerals', hardness: '2.5-4 on Mohs scale', color: 'Green, yellow-green', uses: 'Decorative stone, carving', confidence: 85),
  StoneData(name: 'Lapis Lazuli', type: 'Metamorphic Rock', formation: 'Contact metamorphism of limestone', composition: 'Lazurite, Calcite, Pyrite', hardness: '5-6 on Mohs scale', color: 'Deep blue with gold flecks', uses: 'Jewelry, pigment, decorative', confidence: 92),
  StoneData(name: 'Turquoise', type: 'Sedimentary Rock', formation: 'Secondary mineral in arid regions', composition: 'Copper Aluminum Phosphate', hardness: '5-6 on Mohs scale', color: 'Blue, blue-green', uses: 'Jewelry, decorative stone', confidence: 90),
  StoneData(name: 'Malachite', type: 'Sedimentary Rock', formation: 'Secondary copper mineral', composition: 'Copper Carbonate Hydroxide', hardness: '3.5-4 on Mohs scale', color: 'Bright green with bands', uses: 'Jewelry, decorative stone, pigment', confidence: 89),
  StoneData(name: 'Azurite', type: 'Sedimentary Rock', formation: 'Secondary copper mineral', composition: 'Copper Carbonate', hardness: '3.5-4 on Mohs scale', color: 'Deep blue', uses: 'Jewelry, pigment, decorative', confidence: 88),
];
