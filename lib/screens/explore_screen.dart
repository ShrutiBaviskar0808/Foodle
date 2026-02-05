import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<Map<String, dynamic>> allergies = [
    {'name': 'Peanuts', 'severity': 'High', 'color': Colors.red},
    {'name': 'Shellfish', 'severity': 'Medium', 'color': Colors.orange},
    {'name': 'Dairy', 'severity': 'Low', 'color': Colors.yellow[700]},
    {'name': 'Gluten', 'severity': 'High', 'color': Colors.red},
    {'name': 'Eggs', 'severity': 'Medium', 'color': Colors.orange},
    {'name': 'Soy', 'severity': 'Low', 'color': Colors.yellow[700]},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Allergies'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Track food allergies and dietary restrictions',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: allergies.length,
                itemBuilder: (context, index) {
                  final allergy = allergies[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: allergy['color'].withValues(alpha: 0.2),
                        child: Icon(Icons.warning, color: allergy['color']),
                      ),
                      title: Text(allergy['name']),
                      subtitle: Text('Severity: ${allergy['severity']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteAllergy(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAllergy,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _addAllergy() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        String severity = 'Low';
        return AlertDialog(
          title: const Text('Add Allergy'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Allergy Name'),
                onChanged: (value) => name = value,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                initialValue: severity,
                decoration: const InputDecoration(labelText: 'Severity'),
                items: ['Low', 'Medium', 'High'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => severity = value!,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (name.isNotEmpty) {
                  Color color = severity == 'High' ? Colors.red : 
                              severity == 'Medium' ? Colors.orange : Colors.yellow[700]!;
                  setState(() {
                    allergies.add({
                      'name': name,
                      'severity': severity,
                      'color': color,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAllergy(int index) {
    setState(() {
      allergies.removeAt(index);
    });
  }
}