import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:smart_content_recommendation_application/global_variable.dart';

class FileUploadScreen extends StatefulWidget {
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  File? _selectedFile;
  String? _summary;
  bool _isLoading = false;

  final String backendUrl = "$uri/api/file/upload"; // Adjust for iOS/web

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a file first.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _summary = null;
    });

    try {
      Dio dio = Dio();
      String fileName = _selectedFile!.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(_selectedFile!.path, filename: fileName),
      });

      Response response = await dio.post(
        backendUrl,
        data: formData,
        options: Options(headers: {
          "Content-Type": "multipart/form-data",
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _summary = response.data["summary"] ?? "No summary available.";
        });
      } else {
        throw Exception("Failed to process file.");
      }
    } catch (e) {
      print("Upload Failed: $e");
      setState(() {
        _summary = "Error: Something went wrong!";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("File Upload & Summary")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              child: Text("Select File"),
            ),
            if (_selectedFile != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text("Selected: ${_selectedFile!.path.split('/').last}"),
              ),
            ElevatedButton(
              onPressed: _uploadFile,
              child: Text("Upload & Summarize"),
            ),
            if (_isLoading) CircularProgressIndicator(),
            if (_summary != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    color: Colors.grey[200],
                    margin: EdgeInsets.only(top: 16),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(_summary ?? "No summary available."),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
