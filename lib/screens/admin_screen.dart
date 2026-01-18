// lib/screens/admin_screen.dart
// Admin screen to manage food items and Firebase data

import 'package:flutter/material.dart';
import '../services/firebase_food_seeder.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final FirebaseFoodSeeder _seeder = FirebaseFoodSeeder();
  bool _isLoading = false;

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _seedFoods() async {
    setState(() => _isLoading = true);
    try {
      final exists = await _seeder.foodsExist();
      if (exists) {
        if (mounted) {
          _showSnackBar('Foods already exist in Firebase', isError: true);
        }
        return;
      }

      await _seeder.seedAllFoods();
      if (mounted) {
        _showSnackBar('Successfully added all sample foods to Firebase!');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteAllFoods() async {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Foods?'),
        content: const Text(
          'This will permanently delete all food items from Firebase. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _isLoading = true);
              try {
                await _seeder.deleteAllFoods();
                if (mounted) {
                  _showSnackBar('All foods deleted from Firebase');
                }
              } catch (e) {
                if (mounted) {
                  _showSnackBar('Error: $e', isError: true);
                }
              } finally {
                if (mounted) {
                  setState(() => _isLoading = false);
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Manage Foods',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Use the buttons below to manage food items in Firebase:',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _seedFoods,
                        icon: const Icon(Icons.cloud_upload),
                        label: const Text('Add Sample Foods to Firebase'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _deleteAllFoods,
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete All Foods'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Instructions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInstructionItem(
                        '1',
                        'Click "Add Sample Foods to Firebase" button above',
                      ),
                      _buildInstructionItem(
                        '2',
                        'Wait for the operation to complete',
                      ),
                      _buildInstructionItem(
                        '3',
                        'Go back to Home screen and refresh to see the foods',
                      ),
                      _buildInstructionItem(
                        '4',
                        'Foods will now appear in the grid with images',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'What Gets Added?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildFoodInfo('10 sample food items'),
                      _buildFoodInfo('Categories: Pizza, Burger, Dessert, Drinks, Asian'),
                      _buildFoodInfo('Real images from Unsplash'),
                      _buildFoodInfo('Prices ranging from \$4.99 to \$14.99'),
                    ],
                  ),
                ),
              ),
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      const Text('Processing...'),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodInfo(String info) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(info),
          ),
        ],
      ),
    );
  }
}
