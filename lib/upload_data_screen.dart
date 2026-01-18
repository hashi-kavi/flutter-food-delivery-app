// Temporary screen to upload sample data to Firebase
// You can navigate to this screen once to populate your database

import 'package:flutter/material.dart';
import 'utils/upload_sample_data.dart';

class UploadDataScreen extends StatefulWidget {
  const UploadDataScreen({super.key});

  @override
  State<UploadDataScreen> createState() => _UploadDataScreenState();
}

class _UploadDataScreenState extends State<UploadDataScreen> {
  bool _isUploading = false;
  String _message = '';

  Future<void> _uploadData() async {
    setState(() {
      _isUploading = true;
      _message = 'Uploading sample data to Firebase...';
    });

    try {
      await uploadSampleDataToFirebase();
      setState(() {
        _isUploading = false;
        _message = '✅ Data uploaded successfully!';
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
        _message = '❌ Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Sample Data')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_upload, size: 80, color: Colors.orange),
              const SizedBox(height: 24),
              const Text(
                'Upload Sample Food Data',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'This will populate your Firebase Firestore with sample food items.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (_isUploading)
                const CircularProgressIndicator()
              else
                ElevatedButton.icon(
                  onPressed: _uploadData,
                  icon: const Icon(Icons.upload),
                  label: const Text('Upload Data to Firebase'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              if (_message.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _message.contains('✅')
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _message,
                    style: TextStyle(
                      color: _message.contains('✅')
                          ? Colors.green.shade900
                          : Colors.red.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
