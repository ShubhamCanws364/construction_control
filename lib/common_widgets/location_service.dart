import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class LocationService extends GetxService {
  final Rxn<double> latitude = Rxn<double>();
  final Rxn<double> longitude = Rxn<double>();
  final Rxn<double> heading = Rxn<double>();
  final Rxn<double> altitude = Rxn<double>();
  final Rxn<double> accuracy = Rxn<double>();
  final Rxn<String> timestamp = Rxn<String>();
  final Rxn<String> localTimestamp = Rxn<String>();
  final RxBool isLoading = false.obs;
  void clear() {
    latitude.value = null;
    longitude.value = null;
    heading.value = null;
    altitude.value = null;
    accuracy.value = null;
    timestamp.value = null;
  }
  Future<bool> _handlePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }

  Future<void> getCurrentLocation() async {
    isLoading.value = true;
    try {
      bool hasPermission = await _handlePermission();
      if (!hasPermission) return;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;
      heading.value = position.heading;
      altitude.value = position.altitude;
      accuracy.value = position.accuracy;
      final localTime = position.timestamp.toLocal();
      timestamp.value = DateFormat("dd MMM yyyy @ hh:mm a").format(localTime);

      localTimestamp.value = localTime.toIso8601String();

      debugPrint("Formatted Time => ${timestamp.value}");
      debugPrint("Local ISO Time => ${localTimestamp.value}");

    } catch (e) {
      debugPrint("Error fetching location: $e");
    } finally {
      isLoading.value = false; // 👈 stop loader
    }
  }
}


