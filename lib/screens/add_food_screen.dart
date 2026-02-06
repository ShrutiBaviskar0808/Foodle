import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddFoodScreen extends StatefulWidget {
  final Map<String, dynamic>? food;
  final int? index;

  const AddFoodScreen({super.key, this.food, this.index});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController();
  final _foodItemController = TextEditingController();
  final _preferencesController = TextEditingController();
  final _moodController = TextEditingController();
  final _notesController = TextEditingController();
  
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    if (widget.food != null) {
      _storeNameController.text = widget.food!['storeName'] ?? '';
      _foodItemController.text = widget.food!['foodItem'] ?? '';
      _preferencesController.text = widget.food!['preferences'] ?? '';
      _moodController.text = widget.food!['mood'] ?? '';
      _notesController.text = widget.food!['notes'] ?? '';
      _imagePath = widget.food!['imagePath'];
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveFood() {
    if (_formKey.currentState!.validate()) {
      final foodData = {
        'storeName': _storeNameController.text,
        'foodItem': _foodItemController.text,
        'preferences': _preferencesController.text,
        'mood': _moodController.text,
        'notes': _notesController.text,
        'imagePath': _imagePath,
      };
      Navigator.pop(context, {'data': foodData, 'index': widget.index});
    }
  }

  void _deleteFood() {
    Navigator.pop(context, {'delete': true, 'index': widget.index});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food == null ? 'Add Favorite Food' : 'Edit Favorite Food'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.orange.withValues(alpha: 0.2),
                    backgroundImage: _imagePath != null ? FileImage(File(_imagePath!)) : null,
                    child: _imagePath == null
                        ? const Icon(Icons.add_a_photo, size: 40, color: Colors.orange)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _storeNameController,
                decoration: const InputDecoration(
                  labelText: 'Store Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Store name is required' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _foodItemController,
                decoration: const InputDecoration(
                  labelText: 'Food Item *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Food item is required' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _preferencesController,
                decoration: const InputDecoration(
                  labelText: 'Preferences',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Extra spicy, No onions',
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _moodController,
                decoration: const InputDecoration(
                  labelText: 'Mood',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Happy, Comfort food',
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                  hintText: 'Additional notes',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveFood,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Save', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              if (widget.food != null) ...[
                const SizedBox(height: 15),
                SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: _deleteFood,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Delete', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _foodItemController.dispose();
    _preferencesController.dispose();
    _moodController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
