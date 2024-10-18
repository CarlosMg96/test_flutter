import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  XFile? _imageFile;
  String? _errorMessage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final compressedImage = await _compressImage(pickedFile);
        setState(() {
          _imageFile = compressedImage;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Future<XFile> _compressImage(XFile file) async {
    // Read the image file as bytes
    final bytes = await file.readAsBytes();
    // Decode the image
    img.Image? image = img.decodeImage(bytes);

    if (image != null) {
      // Compress the image to fit under 1MB
      int quality = 100;
      int maxSize = 1024 * 1024; // 1 MB
      List<int> compressedBytes;

      do {
        compressedBytes = img.encodeJpg(image, quality: quality);
        quality -= 10; // Decrease quality by 10 each iteration
      } while (compressedBytes.length > maxSize && quality > 0);

      // Save the compressed image to a temporary file
      final compressedFile = File('${file.path}_compressed.jpg');
      await compressedFile.writeAsBytes(compressedBytes);

      return XFile(compressedFile.path);
    } else {
      throw Exception('Failed to decode image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Photo'),
      ),
      body: Center(
        child: _imageFile == null
            ? Text(_errorMessage ?? 'No image selected.')
            : Image.file(File(_imageFile!.path)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Take Photo',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
