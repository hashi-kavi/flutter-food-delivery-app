// lib/screens/admin/admin_food_management_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/food_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/food.dart';
import 'food_form_screen.dart';

class AdminFoodManagementScreen extends StatefulWidget {
  const AdminFoodManagementScreen({super.key});

  @override
  State<AdminFoodManagementScreen> createState() =>
      _AdminFoodManagementScreenState();
}

class _AdminFoodManagementScreenState extends State<AdminFoodManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FoodProvider>(context, listen: false).fetchFoods();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final foodProvider = Provider.of<FoodProvider>(context);

    // Security check - only admins can access
    if (authProvider.currentUser?.isAdmin != true) {
      return Scaffold(
        appBar: AppBar(title: const Text('Access Denied')),
        body: const Center(
          child: Text('You do not have permission to access this page'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Foods'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => foodProvider.fetchFoods(),
          ),
        ],
      ),
      body: foodProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : foodProvider.errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 64, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(foodProvider.errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => foodProvider.fetchFoods(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : foodProvider.foods.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.restaurant_menu,
                              size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          const Text('No foods added yet'),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => _navigateToAddFood(context),
                            icon: const Icon(Icons.add),
                            label: const Text('Add First Food'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: foodProvider.foods.length,
                      itemBuilder: (context, index) {
                        final food = foodProvider.foods[index];
                        return _buildFoodCard(context, food, foodProvider);
                      },
                    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddFood(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Food'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildFoodCard(
      BuildContext context, Food food, FoodProvider foodProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                food.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: const Icon(Icons.restaurant),
                  );
                },
              ),
            ),
            title: Text(
              food.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('\$${food.price.toStringAsFixed(2)}'),
                Text(
                  food.category,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            trailing: Switch(
              value: food.isAvailable,
              onChanged: (value) async {
                final success =
                    await foodProvider.toggleAvailability(food.id, value);
                if (!success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to update availability'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _navigateToEditFood(context, food),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _confirmDelete(context, food, foodProvider),
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  label:
                      const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAddFood(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FoodFormScreen(),
      ),
    );
    if (result == true) {
      Provider.of<FoodProvider>(context, listen: false).fetchFoods();
    }
  }

  void _navigateToEditFood(BuildContext context, Food food) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodFormScreen(food: food),
      ),
    );
    if (result == true) {
      Provider.of<FoodProvider>(context, listen: false).fetchFoods();
    }
  }

  void _confirmDelete(
      BuildContext context, Food food, FoodProvider foodProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Food?'),
        content: Text('Are you sure you want to delete "${food.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await foodProvider.deleteFood(food.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Food deleted successfully'
                          : 'Failed to delete food',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
