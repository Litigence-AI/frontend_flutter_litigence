// analyze_document_button.dart
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'file_data.dart';
import '../constants.dart';

class AnalyzeDocumentButton extends StatefulWidget {
  const AnalyzeDocumentButton({super.key});

  @override
  State<AnalyzeDocumentButton> createState() => _AnalyzeDocumentButtonState();
}

class _AnalyzeDocumentButtonState extends State<AnalyzeDocumentButton> {
  bool _isLoading = false;

  void _analyzeDocument() async {
    setState(() {
      _isLoading = true;
    });
    final apiService = ApiService();
    final fileData = FileData(
      fileData: sampleFileData,
      mimeType: 'application/pdf',
      filename: 'contract.pdf',
    );
    try {
      final response = await apiService.askMultimodal(
        question: 'Can you analyze this document and tell me what it means?',
        userId: 'test_user',
        chatTitle: 'Document Analysis',
        files: [fileData],
      );
      // For now, print the response; later iterations can display it in the UI
      print(response);
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Error'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _analyzeDocument,
      child:
          _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Analyze Document'),
    );
  }
}
