import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyPocketPage extends StatefulWidget {
  const MyPocketPage({super.key});

  @override
  _MyPocketPageState createState() => _MyPocketPageState();
}

class _MyPocketPageState extends State<MyPocketPage> {
  List<Map<String, dynamic>> documents = [];
  String? _token;

  // Filter options
  String? selectedType;
  String? selectedStatus;
  String? titleFilter;
  String? startDate;
  String? endDate;

  @override
  void initState() {
    super.initState();
    _initializeTokenAndFetchDocuments();
  }

  Future<void> _initializeTokenAndFetchDocuments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      setState(() {
        _token = token;
      });
      _fetchDocuments();
    } else {
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }

  Future<void> _fetchDocuments({bool applyFilters = false}) async {
    final url = applyFilters
        ? _buildFilterUrl()
        : 'http://192.168.1.149:3005/api/documents';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $_token',
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          documents = List<Map<String, dynamic>>.from(responseData['documents']);
        });
      } else {
        _showMessage('Failed to fetch documents: ${response.statusCode}');
      }
    } catch (error) {
      _showMessage('Error fetching documents: $error');
    }
  }

  String _buildFilterUrl() {
    final params = <String, String>{};

    if (selectedType != null && selectedType!.isNotEmpty) {
      params['type'] = selectedType!;
    }
    if (selectedStatus != null && selectedStatus!.isNotEmpty) {
      params['status'] = selectedStatus!;
    }
    if (titleFilter != null && titleFilter!.isNotEmpty) {
      params['title'] = titleFilter!;
    }
    if (startDate != null && startDate!.isNotEmpty) {
      params['startDate'] = startDate!;
    }
    if (endDate != null && endDate!.isNotEmpty) {
      params['endDate'] = endDate!;
    }

    final query = Uri(queryParameters: params).query;
    return 'http://192.168.1.149:3005/api/documents/filter?$query';
  }

  Future<void> _deleteDocument(String documentId) async {
    final url = 'http://192.168.1.149:3005/api/documents/delete/$documentId';
    try {
      final response = await http.delete(Uri.parse(url), headers: {
        'Authorization': 'Bearer $_token',
      });

      if (response.statusCode == 200) {
        _showMessage('Document deleted successfully.');
        setState(() {
          documents.removeWhere((doc) => doc['document_id'] == documentId);
        });
      } else {
        _showMessage('Failed to delete document: ${response.statusCode}');
      }
    } catch (error) {
      _showMessage('Error deleting document: $error');
    }
  }

  Future<void> _downloadDocument(String documentId, String fileName) async {
    final url =
        'http://192.168.1.149:3005/api/documents/download/$documentId/file';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $_token',
      });

      if (response.statusCode == 200) {
        _showMessage('Download initiated for $fileName.');
      } else {
        _showMessage('Failed to download file: ${response.statusCode}');
      }
    } catch (error) {
      _showMessage('Error downloading file: $error');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedType,
                  hint: const Text('Filter by Type'),
                  items: const [
                    DropdownMenuItem(value: 'IDs', child: Text('IDs')),
                    DropdownMenuItem(value: 'Insurances', child: Text('Insurances')),
                    DropdownMenuItem(
                        value: 'Car Documents', child: Text('Car Documents')),
                    DropdownMenuItem(
                        value: 'HouseDocuments', child: Text('HouseDocuments')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  hint: const Text('Filter by Status'),
                  items: const [
                    DropdownMenuItem(value: 'active', child: Text('Active')),
                    DropdownMenuItem(value: 'expired', child: Text('Expired')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Filter by Title'),
                  onChanged: (value) {
                    titleFilter = value;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _fetchDocuments(applyFilters: true);
                        },
                        child: const Text('Apply Filters'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            selectedType = null;
                            selectedStatus = null;
                            titleFilter = null;
                            startDate = null;
                            endDate = null;
                          });
                          _fetchDocuments();
                        },
                        child: const Text('Reset Filters'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Documents'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _openFilterModal,
          ),
        ],
      ),
      body: documents.isEmpty
          ? const Center(child: Text('No documents available.'))
          : ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final doc = documents[index];
          return Card(
            child: ListTile(
              title: Text(doc['title']),
              subtitle:
              Text('Type: ${doc['type']}, Status: ${doc['status']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        _deleteDocument(doc['document_id']),
                  ),
                  IconButton(
                    icon: const Icon(Icons.download, color: Colors.green),
                    onPressed: () => _downloadDocument(
                        doc['document_id'], doc['title']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}