// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:smart_content_recommendation_application/global_variable.dart';

// class FileUploadScreen extends StatefulWidget {
//   static const routeName = '/file';

//   @override
//   _FileUploadScreenState createState() => _FileUploadScreenState();
// }

// class _FileUploadScreenState extends State<FileUploadScreen> {
//   File? _selectedFile;
//   String? _summary;
//   bool _isLoading = false;

//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['txt', 'pdf'],
//     );

//     if (result != null) {
//       setState(() {
//         _selectedFile = File(result.files.single.path!);
//       });
//     }
//   }

//   Future<void> _uploadFile() async {
//     if (_selectedFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please select a file first.")),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _summary = null;
//     });

//     try {
//       Dio dio = Dio();
//       FormData formData = FormData.fromMap({
//         "file": await MultipartFile.fromFile(_selectedFile!.path,
//             filename: _selectedFile!.path.split('/').last),
//       });

//       Response response = await dio.post(
//         "$uri/api/file/upload",
//         data: formData,
//         options: Options(headers: {
//           "Content-Type": "multipart/form-data",
//         }),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           _summary = response.data["summary"] ?? "No summary available.";
//         });
//       } else {
//         setState(() {
//           _summary =
//               response.data["error"] ?? "Error: Unable to summarize the file.";
//         });
//       }
//     } catch (e) {
//   print("Upload Failed: $e");
//   if (e is DioException && e.response != null) {
//     print("Server Response: ${e.response?.data}");
//     setState(() {
//       _summary = "Error: ${e.response?.data['error'] ?? 'Unknown error'}";
//     });
//   } else {
//     setState(() {
//       _summary = "Error: Something went wrong!";
//     });
//   }
// }
//  finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("File Upload & Summary")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _pickFile,
//               child: Text("Select File"),
//             ),
//             if (_selectedFile != null)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Text("Selected: ${_selectedFile!.path.split('/').last}"),
//               ),
//             ElevatedButton(
//               onPressed: _uploadFile,
//               child: Text("Upload & Summarize"),
//             ),
//             if (_isLoading) CircularProgressIndicator(),
//             if (_summary != null)
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Card(
//                     color: Colors.grey[200],
//                     margin: EdgeInsets.only(top: 16),
//                     child: Padding(
//                       padding: EdgeInsets.all(12),
//                       child: Text(_summary ?? "No summary available."),
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:smart_content_recommendation_application/global_variable.dart';

// class FileUploadScreen extends StatefulWidget {
//   static const routeName = '/file';

//   @override
//   _FileUploadScreenState createState() => _FileUploadScreenState();
// }

// class _FileUploadScreenState extends State<FileUploadScreen> {
//   File? _selectedFile;
//   String? _summary;
//   bool _isLoading = false;

//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['txt', 'pdf'],
//     );

//     if (result != null) {
//       setState(() {
//         _selectedFile = File(result.files.single.path!);
//       });
//     }
//   }

//   Future<void> _uploadFile() async {
//     if (_selectedFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please select a file first.")),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _summary = null;
//     });

//     try {
//       Dio dio = Dio();
//       String fileName = _selectedFile!.path.split('/').last;

//       // Step 1: Request Pre-Signed URL from Backend
//       Response presignedResponse = await dio.post(
//         "$uri/api/file/presigned-url",
//         data: {"fileName": fileName},
//       );

//       if (presignedResponse.statusCode != 200 || 
//           presignedResponse.data["url"] == null) {
//         throw Exception("Failed to get pre-signed URL.");
//       }

//       String presignedUrl = presignedResponse.data["url"];
//       String fileUrl = presignedResponse.data["fileUrl"]; // S3 URL

//       // Step 2: Upload the File to S3
//       Response s3Response = await dio.put(
//         presignedUrl,
//         data: _selectedFile!.openRead(),
//         options: Options(headers: {
//           "Content-Type": "multipart/form-data",
//         }),
//       );

//       if (s3Response.statusCode != 200) {
//         throw Exception("Failed to upload to S3.");
//       }

//       // Step 3: Notify Backend about Uploaded File URL
//       Response backendResponse = await dio.post(
//         "$uri/api/file/save",
//         data: {"fileUrl": fileUrl},
//       );

//       if (backendResponse.statusCode == 200) {
//         setState(() {
//           _summary = backendResponse.data["summary"] ?? "No summary available.";
//         });
//       } else {
//         setState(() {
//           _summary = backendResponse.data["error"] ?? "Error in processing.";
//         });
//       }
//     } catch (e) {
//       print("Upload Failed: $e");
//       setState(() {
//         _summary = "Error: Something went wrong!";
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("File Upload & Summary")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _pickFile,
//               child: Text("Select File"),
//             ),
//             if (_selectedFile != null)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Text("Selected: ${_selectedFile!.path.split('/').last}"),
//               ),
//             ElevatedButton(
//               onPressed: _uploadFile,
//               child: Text("Upload & Summarize"),
//             ),
//             if (_isLoading) CircularProgressIndicator(),
//             if (_summary != null)
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Card(
//                     color: Colors.grey[200],
//                     margin: EdgeInsets.only(top: 16),
//                     child: Padding(
//                       padding: EdgeInsets.all(12),
//                       child: Text(_summary ?? "No summary available."),
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:smart_content_recommendation_application/content/services/contentService.dart';


class FileUploadScreen extends StatefulWidget {
  static const routeName = '/file';

  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  File? _selectedFile;
  String? _summary;
  bool _isLoading = false;

  final ContentService contentService = ContentService();

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

    String? summary = await contentService.uploadFile(_selectedFile!);

    setState(() {
      _summary = summary;
      _isLoading = false;
    });
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
