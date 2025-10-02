import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class GeotagApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Geotagging Photo', home: GeotagPage());
  }
}

class GeotagPage extends StatefulWidget {
  @override
  _GeotagPageState createState() => _GeotagPageState();
}

class _GeotagPageState extends State<GeotagPage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _locationString;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    await Permission.camera.request();
    await Permission.location.request();
  }

  Future<void> capturePhotoAndTagLocation() async {
    try {
      // 1. Pick image
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile == null) return;

      // 2. Get location
      final Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _imageFile = File(pickedFile.path);
        _locationString = 'Lat: ${pos.latitude}, Lng: ${pos.longitude}';
      });

      // 3. Save metadata
      await savePhotoWithLocation(pickedFile, pos);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> savePhotoWithLocation(XFile image, Position pos) async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final imagePath = '${directory.path}/photo_$timestamp.jpg';

    // Save the image
    final savedImage = await File(image.path).copy(imagePath);

    // Save metadata (JSON)
    final metadata = {
      'imagePath': savedImage.path,
      'latitude': pos.latitude,
      'longitude': pos.longitude,
      'timestamp': DateTime.now().toIso8601String(),
    };

    final jsonFile = File('${directory.path}/metadata_$timestamp.json');
    await jsonFile.writeAsString(jsonEncode(metadata));

    print("Saved image: ${savedImage.path}");
    print("Saved metadata: ${jsonFile.path}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Geotagging Photo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageFile != null) Image.file(_imageFile!, height: 250),
            if (_locationString != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_locationString!),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: capturePhotoAndTagLocation,
              child: Text("Capture Photo with GPS"),
            ),
          ],
        ),
      ),
    );
  }
}
