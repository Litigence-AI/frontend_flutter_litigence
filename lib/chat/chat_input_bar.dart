// chat_input_bar.dart
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../multimodal/file_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

final ImagePicker _imagePicker = ImagePicker();

// Add this as a class field in ChatInputBar:
class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final bool isTextEmpty;
  final Function() sendMessage;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.isTextEmpty,
    required this.sendMessage,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final ImagePicker _imagePicker = ImagePicker();
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isTextEmpty = true;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    widget.controller.addListener(_updateTextStatus);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateTextStatus);
    _speechToText.stop();
    super.dispose();
  }

  void _updateTextStatus() {
    setState(() {
      _isTextEmpty = widget.controller.text.isEmpty;
    });
  }

  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: (status) {
        // Handle status changes like "listening", "not listening", etc.
        // You might want to show a UI indicator when listening is active
        print('Speech recognition status: $status');
      },
    );
  }

  Future<void> _startListening(BuildContext context) async {
    // Initialize speech recognition if not already done
    if (!_speechEnabled) {
      await _initSpeech();
    }

    // If we couldn't initialize speech recognition
    if (!_speechEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Speech recognition not available on this device'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Start listening
    await _speechToText.listen(
      onResult: (SpeechRecognitionResult result) {
        // Update text field with recognized speech
        widget.controller.text = result.recognizedWords;

        // This will trigger the isTextEmpty listener in the parent widget
        if (result.finalResult && result.recognizedWords.isNotEmpty) {
          // Move cursor to end of text
          widget.controller.selection = TextSelection.fromPosition(
            TextPosition(offset: widget.controller.text.length),
          );
        }
      },
      listenFor: const Duration(seconds: 30), // Max listening time
      pauseFor: const Duration(seconds: 3), // Auto-stop after 3s of silence
      localeId: 'en_US', // Change this based on your app's language needs
    );

    // Show feedback that listening has started
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Listening...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

// Add method to stop listening (useful if you want a way to cancel):
  void _stopListening() {
    _speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () => _showAttachmentOptions(context),
        ),
        Expanded(
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (KeyEvent event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.enter) {
                widget.sendMessage();
              }
            },
            child: TextField(
              controller: widget.controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Text',
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surface.withOpacity(0.6),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            widget.isTextEmpty ? Icons.mic : Icons.send,
            color: Colors.white,
          ),
          onPressed: () {
            if (widget.isTextEmpty) {
              _startListening(context);
            } else {
              widget.sendMessage();
            }
          },
        ),
      ],
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              if (!kIsWeb)
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.white),
                  title: const Text(
                    'Camera',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _handleCameraCapture(context);
                    // Camera functionality will be implemented later
                  },
                ),
              ListTile(
                leading: const Icon(
                  Icons.add_photo_alternate_outlined,
                  color: Colors.white,
                ),
                title: const Text(
                  'Gallery',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _handleImagePick(context);
                  // Gallery functionality will be implemented later
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_file, color: Colors.white),
                title: const Text(
                  'Files',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _handleFileUpload(context);
                  // Files functionality will be implemented later
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<void> _handleCameraCapture(BuildContext context) async {
  try {
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85, // Adjust quality to help with file size
      preferredCameraDevice: CameraDevice.rear, // Default to rear camera
    );

    if (photo == null) {
      // User cancelled the camera
      return;
    }

    // Get file size
    final File file = File(photo.path);
    final int fileSize = await file.length();

    // Validate the captured image
    final result = FileValidator.validateFileFromPath(
        photo.path,
        photo.name,
        fileSize
    );

    if (!result['success']) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error']),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Photo is valid, you can now use it
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Photo captured successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // TODO: Add code to handle the valid photo
    // The file path is available at: photo.path
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error capturing photo: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// Add this method to handle image picking:
Future<void> _handleImagePick(BuildContext context) async {
  try {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85, // Adjust quality to help with file size
    );

    if (image == null) {
      // User cancelled the picker
      return;
    }

    // Convert XFile to PlatformFile format for validation
    final File file = File(image.path);
    final int fileSize = await file.length();

    // Create a map that mimics PlatformFile properties needed for validation
    final platformFileSimulation = PlatformFile(
      name: image.name,
      size: fileSize,
      path: image.path,
    );

    // Validate the image using our existing validator
    final result = FileValidator.validateFile(platformFileSimulation);

    if (!result['success']) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error']),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Image is valid, you can now use it
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Image selected: ${result['file_details']['filename']}'),
        backgroundColor: Colors.green,
      ),
    );

    // TODO: Add code to handle the valid image
    // The file path is available at: image.path
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error picking image: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


// Add this method to the ChatInputBar class to handle file uploads:
Future<void> _handleFileUpload(BuildContext context) async {
  final result = await FileValidator.pickAndValidateFile();

  if (result == null) {
    // User cancelled the picker
    return;
  }

  if (!result['success']) {
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['error']), backgroundColor: Colors.red),
    );
    return;
  }

  // File is valid, you can now use it
  // For example, you might want to:
  // 1. Show the file name in the message box
  // 2. Upload it to a server
  // 3. Process it in some way

  // Here's a simple feedback to show it worked:
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('File selected: ${result['file_details']['filename']}'),
      backgroundColor: Colors.green,
    ),
  );

  // TODO: Add code to handle the valid file
  // The file object is available at: result['file_details']['file']
}


