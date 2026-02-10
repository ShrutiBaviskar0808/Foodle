import 'package:flutter/material.dart';

class SelectAllergiesScreen extends StatefulWidget {
  final List<String>? initialAllergies;
  
  const SelectAllergiesScreen({super.key, this.initialAllergies});

  @override
  State<SelectAllergiesScreen> createState() => _SelectAllergiesScreenState();
}

class _SelectAllergiesScreenState extends State<SelectAllergiesScreen> {
  final List<String> availableAllergies = [
    'Watermelon',
    'Mustered',
    'Humans',
    'Cucumber',
    'Bikes',
    'Peanuts',
    'Shellfish',
    'Dairy',
    'Gluten',
    'Soy',
  ];
  
  List<String> selectedAllergies = [];
  TextEditingController searchController = TextEditingController();
  List<String> filteredAllergies = [];

  @override
  void initState() {
    super.initState();
    selectedAllergies = widget.initialAllergies ?? [];
    filteredAllergies = availableAllergies;
  }

  void _filterAllergies(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredAllergies = availableAllergies;
      } else {
        filteredAllergies = availableAllergies
            .where((allergy) => allergy.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Select Allergies',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 30),
            if (selectedAllergies.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Wrap(
                  spacing: 10,
                  children: selectedAllergies.map((allergy) => Chip(
                    label: Text(allergy),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      setState(() {
                        selectedAllergies.remove(allergy);
                      });
                    },
                    backgroundColor: const Color(0xFFE8D4B8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  )).toList(),
                ),
              ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: searchController,
                onChanged: _filterAllergies,
                decoration: InputDecoration(
                  hintText: 'Search or add new a...',
                  prefixIcon: const Icon(Icons.search, size: 28),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD4B896)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD4B896)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                itemCount: filteredAllergies.length,
                itemBuilder: (context, index) {
                  final allergy = filteredAllergies[index];
                  final isSelected = selectedAllergies.contains(allergy);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedAllergies.remove(allergy);
                          } else {
                            selectedAllergies.add(allergy);
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              allergy,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(4),
                              color: isSelected ? Colors.orange : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, color: Colors.white, size: 20)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 18, color: Colors.brown),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, selectedAllergies),
                    child: const Text(
                      'Done',
                      style: TextStyle(fontSize: 18, color: Colors.brown),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
