import 'package:flutter/material.dart';

class RockCycleScreen extends StatelessWidget {
  const RockCycleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rock Cycle'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'The Rock Cycle',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomPaint(
                      painter: RockCyclePainter(),
                      child: const Center(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildRockTypeCard(
            'Igneous Rocks',
            'Formed from cooled magma or lava',
            'Melting → Cooling → Crystallization',
            Colors.red,
            Icons.whatshot,
          ),
          _buildRockTypeCard(
            'Sedimentary Rocks',
            'Formed from compressed sediments',
            'Weathering → Erosion → Deposition → Compaction',
            Colors.orange,
            Icons.layers,
          ),
          _buildRockTypeCard(
            'Metamorphic Rocks',
            'Formed by heat and pressure transformation',
            'Heat + Pressure → Recrystallization',
            Colors.purple,
            Icons.compress,
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Key Processes',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildProcessItem('Melting', 'Rock turns into magma'),
                  _buildProcessItem('Cooling', 'Magma solidifies into igneous rock'),
                  _buildProcessItem('Weathering', 'Rock breaks down into sediments'),
                  _buildProcessItem('Erosion', 'Sediments are transported'),
                  _buildProcessItem('Deposition', 'Sediments settle and accumulate'),
                  _buildProcessItem('Compaction', 'Sediments compress into rock'),
                  _buildProcessItem('Metamorphism', 'Heat/pressure transforms rock'),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildRockTypeCard(String title, String description, String process, Color color, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$description\n$process'),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildProcessItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.arrow_right, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87),
                children: [
                  TextSpan(text: '$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RockCyclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.3;

    paint.color = Colors.red;
    canvas.drawCircle(Offset(center.dx, center.dy - radius), 40, paint..style = PaintingStyle.fill);
    _drawText(canvas, 'Igneous', Offset(center.dx, center.dy - radius), Colors.white);

    paint.color = Colors.orange;
    canvas.drawCircle(Offset(center.dx - radius * 0.866, center.dy + radius * 0.5), 40, paint..style = PaintingStyle.fill);
    _drawText(canvas, 'Sedimentary', Offset(center.dx - radius * 0.866, center.dy + radius * 0.5), Colors.white);

    paint.color = Colors.purple;
    canvas.drawCircle(Offset(center.dx + radius * 0.866, center.dy + radius * 0.5), 40, paint..style = PaintingStyle.fill);
    _drawText(canvas, 'Metamorphic', Offset(center.dx + radius * 0.866, center.dy + radius * 0.5), Colors.white);

    paint.color = Colors.green;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    final path = Path()
      ..moveTo(center.dx, center.dy - radius + 40)
      ..quadraticBezierTo(center.dx - 50, center.dy - 50, center.dx - radius * 0.866 + 30, center.dy + radius * 0.5 - 30)
      ..moveTo(center.dx - radius * 0.866, center.dy + radius * 0.5 + 40)
      ..quadraticBezierTo(center.dx, center.dy + radius, center.dx + radius * 0.866 - 30, center.dy + radius * 0.5 + 30)
      ..moveTo(center.dx + radius * 0.866, center.dy + radius * 0.5 - 40)
      ..quadraticBezierTo(center.dx + 50, center.dy - 50, center.dx + 30, center.dy - radius + 30);
    canvas.drawPath(path, paint);
  }

  void _drawText(Canvas canvas, String text, Offset position, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(position.dx - textPainter.width / 2, position.dy - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
