import 'package:flutter/material.dart';
import 'guide_detail_screen.dart';

class LearnGuidesScreen extends StatelessWidget {
  const LearnGuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Learn & Explore', style: TextStyle(fontWeight: FontWeight.bold)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.brown.shade700,
                      Colors.brown.shade500,
                      Colors.orange.shade400,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Icon(Icons.school, size: 200, color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -30,
                      child: Icon(Icons.landscape, size: 150, color: Colors.white.withValues(alpha: 0.1)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Popular Guides',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown),
                  ),
                  const SizedBox(height: 16),
                  _buildFeaturedCard(
                    context,
                    'How to Identify Stones',
                    'Master the art of stone identification',
                    Icons.search,
                    [Colors.blue.shade400, Colors.blue.shade700],
                    _getIdentificationGuide(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSmallCard(
                          context,
                          'Photo Tips',
                          Icons.camera_alt,
                          [Colors.green.shade400, Colors.green.shade700],
                          _getPhotoTipsGuide(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSmallCard(
                          context,
                          'Rocks vs Minerals',
                          Icons.compare,
                          [Colors.orange.shade400, Colors.orange.shade700],
                          _getRocksMineralsGuide(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Learning Paths',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown),
                  ),
                  const SizedBox(height: 16),
                  _buildLearningPathCard(
                    context,
                    'Beginner Geology',
                    'Start your journey',
                    Icons.school,
                    [Colors.purple.shade400, Colors.purple.shade700],
                    _getGeologyLessonsGuide(),
                    '6 Lessons',
                  ),
                  const SizedBox(height: 12),
                  _buildLearningPathCard(
                    context,
                    'Fun Stone Facts',
                    'Discover amazing facts',
                    Icons.lightbulb,
                    [Colors.amber.shade400, Colors.amber.shade700],
                    _getFunFactsGuide(),
                    '15+ Facts',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context, String title, String subtitle, IconData icon, List<Color> colors, String content) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GuideDetailScreen(title: title, content: content))),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: colors[1].withValues(alpha: 0.4), blurRadius: 15, offset: const Offset(0, 8)),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Icon(icon, size: 150, color: Colors.white.withValues(alpha: 0.2)),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.9)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallCard(BuildContext context, String title, IconData icon, List<Color> colors, String content) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GuideDetailScreen(title: title, content: content))),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: colors[1].withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -15,
              bottom: -15,
              child: Icon(icon, size: 80, color: Colors.white.withValues(alpha: 0.2)),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningPathCard(BuildContext context, String title, String subtitle, IconData icon, List<Color> colors, String content, String badge) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GuideDetailScreen(title: title, content: content))),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: colors[1].withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.9)),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                badge,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getIdentificationGuide() {
    return '''How to Identify Stones

1. Observe the Color
Look at the overall color and any color variations. Note if the color is uniform or has patterns.

2. Check the Texture
Feel the surface - is it smooth, rough, grainy, or glassy? This tells you about crystal size and formation.

3. Test the Hardness
Use the Mohs scale. Try scratching with your fingernail (2.5), copper coin (3.5), or steel knife (5.5).

4. Look for Crystal Structure
Are there visible crystals? What shape are they? This indicates how the rock formed.

5. Check the Weight
Is it heavy or light for its size? Density can help identify mineral content.

6. Examine the Luster
Is it shiny (metallic), glassy (vitreous), dull, or pearly? Luster reveals mineral composition.

7. Look for Layers
Sedimentary rocks often show distinct layers or bands.

8. Test with Acid
Some rocks fizz with vinegar (limestone, marble) due to calcium carbonate.

Remember: Take multiple observations and compare with reference materials for accurate identification.''';
  }

  String _getPhotoTipsGuide() {
    return '''Tips for Better Photos

1. Good Lighting
• Use natural daylight when possible
• Avoid harsh shadows
• Overcast days provide even lighting
• Use a white background for contrast

2. Focus and Clarity
• Clean the stone before photographing
• Hold camera steady or use a tripod
• Get close enough to see details
• Ensure the entire stone is in focus

3. Multiple Angles
• Take photos from different sides
• Include top, bottom, and side views
• Capture any unique features or patterns
• Show scale with a coin or ruler

4. Background
• Use plain, neutral backgrounds
• White or light gray works best
• Avoid busy or colorful backgrounds
• Ensure good contrast with the stone

5. Camera Settings
• Use highest resolution available
• Turn off flash if possible
• Use macro mode for close-ups
• Adjust exposure if needed

6. What to Capture
• Overall shape and size
• Surface texture and patterns
• Any crystals or unique features
• Color variations
• Any damage or weathering

Better photos = Better identification results!''';
  }

  String _getRocksMineralsGuide() {
    return '''Rocks vs Minerals: Key Differences

MINERALS
• Pure substances with specific chemical formulas
• Have definite crystal structures
• Building blocks of rocks
• Examples: Quartz, Feldspar, Mica, Calcite

Characteristics:
- Naturally occurring
- Inorganic (not from living things)
- Solid at room temperature
- Specific chemical composition
- Ordered atomic structure

ROCKS
• Made of one or more minerals
• Don't have specific chemical formulas
• Classified by how they form
• Examples: Granite, Basalt, Limestone, Marble

Three Types of Rocks:

1. IGNEOUS
Formed from cooled magma or lava
Examples: Granite, Basalt, Obsidian

2. SEDIMENTARY
Formed from compressed sediments
Examples: Sandstone, Limestone, Shale

3. METAMORPHIC
Formed from heat and pressure
Examples: Marble, Slate, Gneiss

SIMPLE ANALOGY
Think of minerals as ingredients and rocks as the recipe:
• Minerals = Flour, Sugar, Eggs
• Rocks = Cake made from those ingredients

A rock can contain many different minerals, just like a cake contains many ingredients!''';
  }

  String _getGeologyLessonsGuide() {
    return '''Beginner Geology Lessons

LESSON 1: The Rock Cycle
Rocks constantly change from one type to another through:
• Melting → Igneous rocks
• Weathering & Erosion → Sedimentary rocks
• Heat & Pressure → Metamorphic rocks

LESSON 2: Earth's Layers
• Crust: Thin outer layer (rocks we see)
• Mantle: Hot, flowing rock
• Outer Core: Liquid metal
• Inner Core: Solid metal

LESSON 3: Plate Tectonics
Earth's crust is broken into plates that:
• Move slowly over time
• Create mountains when they collide
• Form volcanoes at boundaries
• Cause earthquakes

LESSON 4: Weathering & Erosion
• Weathering: Breaking down rocks
  - Physical (ice, temperature)
  - Chemical (water, acids)
  - Biological (plants, animals)

• Erosion: Moving broken rock
  - Water, wind, ice, gravity

LESSON 5: Geological Time
Earth is 4.6 billion years old!
• Rocks preserve Earth's history
• Fossils show ancient life
• Layers tell stories of past environments

LESSON 6: Common Rock-Forming Minerals
• Quartz: Very hard, glassy
• Feldspar: Most common mineral
• Mica: Flaky, shiny layers
• Calcite: Fizzes with acid
• Olivine: Green, glassy

Start observing rocks around you - every stone has a story!''';
  }

  String _getFunFactsGuide() {
    return '''Fun Stone Facts

AMAZING ROCK FACTS

🌋 Obsidian is volcanic glass that forms when lava cools so quickly that crystals don't have time to form!

💎 Diamonds are the hardest natural substance on Earth, but they can burn!

🏔️ The oldest rocks on Earth are over 4 billion years old - almost as old as Earth itself!

⚡ Pumice is the only rock that floats on water because it's full of air bubbles!

🌈 Opals can contain up to 20% water and display rainbow colors!

🔥 Granite countertops are slightly radioactive (but completely safe)!

MINERAL MARVELS

✨ Quartz is the second most abundant mineral in Earth's crust

🎨 The same mineral can be different colors - ruby and sapphire are both corundum!

🧲 Magnetite is naturally magnetic and was used in ancient compasses

💧 Salt (halite) is a mineral we eat every day!

🌟 Some minerals glow under UV light (fluorescence)

GEOLOGICAL WONDERS

🏔️ Mountains are still growing! The Himalayas grow about 5mm per year

🌊 Most of Earth's surface is covered by sedimentary rocks

🔥 There's enough gold in Earth's core to coat the entire surface!

⏰ It takes thousands to millions of years to form most rocks

🌍 Every continent was once part of a supercontinent called Pangaea

RECORD HOLDERS

Hardest: Diamond (10 on Mohs scale)
Softest: Talc (1 on Mohs scale)
Heaviest: Osmium (twice as heavy as lead!)
Lightest: Pumice (can float on water)
Most Common: Feldspar (makes up 60% of Earth's crust)

Keep exploring - geology rocks! 🪨''';
  }
}
