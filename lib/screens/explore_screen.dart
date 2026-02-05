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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
                      onTap: () => _showEditDeleteDialog(index),
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

  void _showEditDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(allergies[index]['name']),
        content: const Text('What would you like to do?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editAllergy(index);
            },
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAllergy(index);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editAllergy(int index) {
    String name = allergies[index]['name'];
    String severity = allergies[index]['severity'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Allergy'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Allergy Name'),
                controller: TextEditingController(text: name),
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
                Color color = severity == 'High' ? Colors.red : 
                            severity == 'Medium' ? Colors.orange : Colors.yellow[700]!;
                setState(() {
                  allergies[index]['name'] = name;
                  allergies[index]['severity'] = severity;
                  allergies[index]['color'] = color;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
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