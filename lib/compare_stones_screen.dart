import 'package:flutter/material.dart';
import 'stone_detail_screen.dart';

class CompareStonesScreen extends StatelessWidget {
  const CompareStonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Compare Similar Stones'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Your Stone',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildStoneCard(
            context,
            'Granite',
            'Coarse-grained, pink/gray',
            true,
          ),
          const SizedBox(height: 24),
          const Text(
            'Similar Stones',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildStoneCard(
            context,
            'Diorite',
            'Medium-grained, salt & pepper appearance',
            false,
          ),
          const SizedBox(height: 12),
          _buildStoneCard(
            context,
            'Gabbro',
            'Coarse-grained, dark colored',
            false,
          ),
          const SizedBox(height: 12),
          _buildStoneCard(
            context,
            'Granodiorite',
            'Similar to granite, less pink feldspar',
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildStoneCard(BuildContext context, String name, String difference, bool isYourStone) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoneDetailScreen(stoneName: name),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isYourStone ? Colors.brown.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isYourStone ? Colors.brown : Colors.grey.shade300,
            width: isYourStone ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Icon(
                Icons.landscape,
                size: 40,
                color: Colors.grey.shade400,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isYourStone) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.brown,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Match',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      difference,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.arrow_forward, size: 16, color: Colors.brown.shade400),
                        const SizedBox(width: 4),
                        Text(
                          'Tap to view details',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.brown.shade400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
