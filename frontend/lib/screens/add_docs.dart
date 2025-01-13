import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddDocs extends StatefulWidget {
  const AddDocs({super.key});

  @override
  _AddDocsState createState() => _AddDocsState();
}

class _AddDocsState extends State<AddDocs> {
  File? selectedFile;
  String fileTitle = "";
  String fileType = "IDs"; // Default type
  bool isUploading = false;

  Future<void> _pickFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedFile = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected')),
      );
    }
  }

  Future<void> _uploadFile() async {
    if (selectedFile == null || fileTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file and provide a title')),
      );
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception("Token not found. Please log in again.");
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.149:3005/api/documents/upload'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['title'] = fileTitle;
      request.fields['type'] = fileType;
      request.files.add(await http.MultipartFile.fromPath('document', selectedFile!.path));

      final response = await request.send();

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File uploaded successfully!')),
        );

        setState(() {
          fileTitle = "";
          fileType = "IDs";
          selectedFile = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload file')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Document"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // File Title Input
              TextField(
                decoration: const InputDecoration(
                  labelText: "Title of the document",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    fileTitle = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // File Type Dropdown
              DropdownButtonFormField<String>(
                value: fileType,
                decoration: const InputDecoration(
                  labelText: "Type of the document",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "IDs", child: Text("IDs")),
                  DropdownMenuItem(value: "Insurances", child: Text("Insurances")),
                  DropdownMenuItem(value: "Car Documents", child: Text("Car Documents")),
                  DropdownMenuItem(value: "HouseDocuments", child: Text("House Documents")),
                ],
                onChanged: (value) {
                  setState(() {
                    fileType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // File Picker Button
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.attach_file),
                label: const Text("Choose File"),
              ),
              const SizedBox(height: 16),

              // Display Selected File
              selectedFile != null
                  ? Text("File Selected: ${selectedFile!.path.split('/').last}")
                  : const Text("No file selected"),
              const SizedBox(height: 16),

              // Upload Button
              ElevatedButton.icon(
                onPressed: isUploading ? null : _uploadFile,
                icon: const Icon(Icons.upload),
                label: isUploading
                    ? const Text("Uploading...")
                    : const Text("Upload Document"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isUploading ? Colors.grey : Colors.purple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
