// Script to upload sample food data to Firebase Firestore
// Run this once to populate your database

import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/sample_food_data.dart';

Future<void> uploadSampleDataToFirebase() async {
  final firestore = FirebaseFirestore.instance;
  final foods = SampleFoodData.getSampleFoods();

  print('Starting upload of ${foods.length} food items...');

  try {
    // Create a batch write for better performance
    final batch = firestore.batch();

    for (var food in foods) {
      final docRef = firestore.collection('foods').doc(food.id);
      batch.set(docRef, food.toMap());
    }

    // Commit the batch
    await batch.commit();

    print('✅ Successfully uploaded ${foods.length} food items to Firebase!');
  } catch (e) {
    print('❌ Error uploading data: $e');
    rethrow;
  }
}
