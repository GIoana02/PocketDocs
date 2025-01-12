import 'package:flutter/material.dart';

class MyPocketPage extends StatelessWidget {
  const MyPocketPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Documents list and index are defined here as part of the widget's properties
    List<String> documents = [
      'Document 1',
      'Document 2',
      'Document 3',
      'Document 4',
      'Document 5',
    ];

    int currentIndex = 0;

    // Functions to navigate between documents
    void nextDocument() {
      if (currentIndex < documents.length - 1) {
        currentIndex++;
      }
    }

    void previousDocument() {
      if (currentIndex > 0) {
        currentIndex--;
      }
    }

    void deleteDocument() {
      if (documents.isNotEmpty) {
        documents.removeAt(currentIndex);
        if (currentIndex >= documents.length) {
          currentIndex = documents.length - 1; // Adjust index if it goes out of range
        }
      }
    }

    void downloadDocument() {
      // Implement download logic here
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Logo and App Name (Positioned at the top)
                wrapTheText(),
                const SizedBox(height: 20),
                const Text(
                  "My Documents",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 40),

                // Document Box
                Container(
                  width: double.infinity,
                  height: 500,  // Adjust size for larger documents
                  color: Colors.grey[200],  // Background color for document box
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          documents.isNotEmpty
                              ? documents[currentIndex]
                              : 'No documents available',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      if (documents.isNotEmpty)
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: Row(
                            children: [
                              // Left Arrow
                              IconButton(
                                icon: const Icon(Icons.arrow_left, color: Colors.purple),
                                onPressed: previousDocument,
                              ),
                              // Right Arrow
                              IconButton(
                                icon: const Icon(Icons.arrow_right, color: Colors.purple),
                                onPressed: nextDocument,
                              ),
                              // Delete Icon
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: deleteDocument,
                              ),
                              // Download Icon
                              IconButton(
                                icon: const Icon(Icons.download, color: Colors.green),
                                onPressed: downloadDocument,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  // Function to create the top logo and app name
  Row wrapTheText() {
    return Row(
      children: [
        Image.asset(
          'assets/logo.jpg', // Make sure the asset path is correct
          width: 40,
          height: 40,
        ),
        const SizedBox(width: 8),
        const Expanded( // Wrap the Text widget in Expanded to avoid overflow
          child: Text(
            "PocketDocs",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
        ),
      ],
    );
  }
}
