import 'package:flutter/material.dart';
import 'guide_detail_screen.dart';

class LearnGuidesScreen extends StatelessWidget {
  const LearnGuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Learn & Guides'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildGuideCard(
            context,
            'How to Identify Stones',
            'Learn the basics of stone identification',
            Icons.search,
            Colors.blue,
            _getIdentificationGuide(),
          ),
          _buildGuideCard(
            context,
            'Tips for Better Photos',
            'Capture clear images for accurate identification',
            Icons.camera_alt,
            Colors.green,
            _getPhotoTipsGuide(),
          ),
          _buildGuideCard(
            context,
            'Rocks vs Minerals',
            'Understand the key differences',
            Icons.compare,
            Colors.orange,
            _getRocksMineralsGuide(),
          ),
          _buildGuideCard(
            context,
            'Beginner Geology Lessons',
            'Start your geology journey here',
            Icons.school,
            Colors.purple,
            _getGeologyLessonsGuide(),
          ),
          _buildGuideCard(
            context,
            'Fun Stone Facts',
            'Fascinating facts about rocks and minerals',
            Icons.lightbulb,
            Colors.amber,
            _getFunFactsGuide(),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard(BuildContext context, String title, String subtitle, IconData icon, Color color, String content) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GuideDetailScreen(title: title, content: content),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
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
