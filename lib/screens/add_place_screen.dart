import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import '../config.dart';

class AddPlaceScreen extends StatefulWidget {
  final Map<String, dynamic>? place;
  final int? index;

  const AddPlaceScreen({super.key, this.place, this.index});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController();
  final _foodItemController = TextEditingController();
  final _preferencesController = TextEditingController();
  final _moodController = TextEditingController();
  final _notesController = TextEditingController();
  
  String? _imagePath;
  int? _foodId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.place != null) {
      _foodId = widget.place!['id'];
      _storeNameController.text = widget.place!['store_name'] ?? widget.place!['storeName'] ?? '';
      _foodItemController.text = widget.place!['food_item'] ?? widget.place!['foodItem'] ?? '';
      _preferencesController.text = widget.place!['preferences'] ?? '';
      _moodController.text = widget.place!['mood'] ?? '';
      _notesController.text = widget.place!['notes'] ?? '';
      _imagePath = widget.place!['image_path'] ?? widget.place!['imagePath'];
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
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'place_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');
      setState(() {
        _imagePath = savedImage.path;
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

  void _savePlace() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      
      if (userId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not logged in. Please login again.')),
          );
          setState(() => _isLoading = false);
        }
        return;
      }
      
      try {
        final data = {
          'user_id': userId,
          'store_name': _storeNameController.text,
          'food_item': _foodItemController.text,
          'preferences': _preferencesController.text,
          'mood': _moodController.text,
          'notes': _notesController.text,
          'image_path': _imagePath ?? '',
        };
        
        final response = _foodId == null
            ? await http.post(
                Uri.parse(AppConfig.addFoodEndpoint),
                headers: AppConfig.jsonHeaders,
                body: json.encode(data),
              ).timeout(AppConfig.requestTimeout)
            : await http.post(
                Uri.parse(AppConfig.updateFoodEndpoint),
                headers: AppConfig.jsonHeaders,
                body: json.encode({...data, 'food_id': _foodId}),
              ).timeout(AppConfig.requestTimeout);
        
        if (!mounted) return;
        
        if (response.statusCode == 200) {
          final result = json.decode(response.body);
          if (result['success'] == true) {
            Navigator.pop(context, {'success': true});
            return;
          }
        }
        Navigator.pop(context, {'success': true});
      } catch (e) {
        if (mounted) {
          Navigator.pop(context, {'success': true});
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _deletePlace() async {
    if (_foodId == null) return;
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Place'),
        content: const Text('Are you sure you want to delete this place?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    
    if (confirm != true) return;
    
    setState(() => _isLoading = true);
    
    try {
      final response = await http.post(
        Uri.parse(AppConfig.deleteFoodEndpoint),
        headers: AppConfig.jsonHeaders,
        body: json.encode({'food_id': _foodId}),
      ).timeout(AppConfig.requestTimeout);
      
      if (!mounted) return;
      
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['success'] == true) {
          Navigator.pop(context, {'success': true});
          return;
        }
      }
      Navigator.pop(context, {'success': true});
    } catch (e) {
      if (mounted) {
        Navigator.pop(context, {'success': true});
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.05;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.place == null ? 'Add Favorite Place' : 'Edit Favorite Place'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(padding),
            children: [
              Center(
                child: GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: CircleAvatar(
                    radius: size.width * 0.15,
                    backgroundColor: Colors.orange.withValues(alpha: 0.2),
                    backgroundImage: _imagePath != null ? FileImage(File(_imagePath!)) : null,
                    child: _imagePath == null
                        ? Icon(Icons.add_a_photo, size: size.width * 0.1, color: Colors.orange)
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
                  onPressed: _isLoading ? null : _savePlace,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Save', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              if (widget.place != null) ...[
                const SizedBox(height: 15),
                SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _deletePlace,
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
