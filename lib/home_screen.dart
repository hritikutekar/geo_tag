import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geo_location/geo_service.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();

  String _currentLatitude = "";
  String _currentLongitude = "";
  String? _imagePath;

  bool _isLoading = false;

  _getCurrentLocation() async {
    try {
      var location = await GeoService.shared.determinePosition();
      setState(() {
        _currentLatitude = location.latitude.toString();
        _currentLongitude = location.longitude.toString();
      });
    } catch (e) {
      log("Error", error: e);
    }
  }

  _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _isLoading = true;
    });
    await _getCurrentLocation();
    setState(() {
      _imagePath = photo?.path;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Geo Tag")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(),
          ElevatedButton(
            onPressed: _openCamera,
            child: const Text("Open Camera"),
          ),
          const SizedBox(height: 16.0),
          _imagePath != null
              ? Image.file(
                  File(_imagePath!),
                  height: 250.0,
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 16.0),
          _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    Text("Latitude: $_currentLatitude"),
                    const SizedBox(height: 4.0),
                    Text("Longitude: $_currentLongitude"),
                  ],
                ),
        ],
      ),
    );
  }
}
