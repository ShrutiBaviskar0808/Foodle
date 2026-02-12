import 'package:flutter/material.dart';
import 'stone_detail_screen.dart';
import 'models/stone_model.dart';

class CollectionDetailScreen extends StatefulWidget {
  final String stoneName;
  final String imagePath;
  final StoneModel? stoneData;

  const CollectionDetailScreen({super.key, required this.stoneName, required this.imagePath, this.stoneData});

  @override
  State<CollectionDetailScreen> createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  final TextEditingController _notesController = TextEditingController(text: 'Found during hiking trip. Beautiful specimen with visible crystals.');
  final TextEditingController _locationController = TextEditingController(text: 'Rocky Mountains, Colorado');
  bool _isEditing = false;

  String _getStoneType(String stoneName) {
    final types = {
      'Granite': 'Igneous Rock',
      'Quartz': 'Mineral',
      'Marble': 'Metamorphic Rock',
      'Basalt': 'Igneous Rock',
      'Limestone': 'Sedimentary Rock',
      'Amethyst': 'Crystal',
    };
    return types[stoneName] ?? 'Rock';
  }

  @override
  void dispose() {
    _notesController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.stoneName),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
              if (!_isEditing) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Changes saved!'), backgroundColor: Colors.green),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Stone'),
                  content: const Text('Are you sure you want to delete this stone from your collection?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Stone deleted'), backgroundColor: Colors.red),
                        );
                      },
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Image
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.landscape, size: 80, color: Colors.grey.shade400);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Stone Name
            Text(
              widget.stoneName,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            const SizedBox(height: 8),
            
            // Type Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.brown.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.stoneData?.gemProperties.rarity ?? _getStoneType(widget.stoneName),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.brown),
              ),
            ),
            const SizedBox(height: 20),
            
            // Description from API
            if (widget.stoneData != null) ...[
              const Text(
                'Description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                widget.stoneData!.stoneDescription,
                style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
              ),
              const SizedBox(height: 20),
              
              // Gem Properties
              const Text(
                'Properties',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              _buildPropertyRow('Colors', widget.stoneData!.gemProperties.colors),
              _buildPropertyRow('Hardness', widget.stoneData!.gemProperties.hardness),
              _buildPropertyRow('Transparency', widget.stoneData!.gemProperties.transparency),
              _buildPropertyRow('Luster', widget.stoneData!.gemProperties.luster),
              _buildPropertyRow('Durability', widget.stoneData!.gemProperties.durability),
              _buildPropertyRow('Jewelry Use', widget.stoneData!.gemProperties.jewelryUse),
              if (widget.stoneData!.gemProperties.opticalEffects.isNotEmpty)
                _buildPropertyRow('Optical Effects', widget.stoneData!.gemProperties.opticalEffects),
              const SizedBox(height: 20),
            ],
            
            // Identification Details
            _buildSection('Identification Details', 'Confidence: 94%\nIdentified on: December 15, 2024'),
            
            // User Notes (Editable)
            const Text(
              'My Notes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              enabled: _isEditing,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.brown, width: 2),
                ),
                filled: !_isEditing,
                fillColor: _isEditing ? Colors.white : Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 16),
            
            // Location (Editable)
            const Text(
              'Location',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _locationController,
              enabled: _isEditing,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on, color: Colors.brown),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.brown, width: 2),
                ),
                filled: !_isEditing,
                fillColor: _isEditing ? Colors.white : Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildSection('Date Added', 'December 15, 2024'),
            const SizedBox(height: 20),
            
            // View Full Details Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoneDetailScreen(stoneName: widget.stoneName, imagePath: widget.imagePath),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('View Full Encyclopedia Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

