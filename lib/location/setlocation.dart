import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class GetLocation extends StatefulWidget {
  const GetLocation({super.key});

  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433); // Default center
  LatLng _lastMapPosition = const LatLng(45.521563, -122.677433); // Default position
  String _placeName = ""; // Variable to store place name
  String _address = ""; // Variable to store address

  final Set<Marker> _markers = {}; // Set of markers for Google Maps

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else if (status.isDenied) {
      // Handle the case when permissions are denied
      print("Location permission denied");
    } else if (status.isPermanentlyDenied) {
      // Handle the case when permissions are permanently denied
      print("Location permission permanently denied");
      // You can direct the user to app settings to grant permissions
      openAppSettings();
    }
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await _updateMarkerPosition(LatLng(position.latitude, position.longitude));
      // Move camera to current location
      mapController.animateCamera(
        CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
      );
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onCameraIdle() async {
    await _updateMarkerPosition(_lastMapPosition);
  }

  Future<void> _updateMarkerPosition(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String placeName = placemark.name ?? "";
        String thoroughfare = placemark.thoroughfare ?? "";
        String subThoroughfare = placemark.subThoroughfare ?? "";
        String locality = placemark.locality ?? "";
        String administrativeArea = placemark.administrativeArea ?? "";
        String postalCode = placemark.postalCode ?? "";
        String country = placemark.country ?? "";

        String title = placeName.isNotEmpty
            ? placeName
            : '${thoroughfare.isNotEmpty ? thoroughfare : ''} ${subThoroughfare.isNotEmpty ? subThoroughfare : ''}';

        String address = '';
        if (placeName.isNotEmpty) {
          address += '$placeName, ';
        }
        address +=
        '$thoroughfare $subThoroughfare, $locality, $administrativeArea $postalCode, $country';

        setState(() {
          _placeName = placeName;
          _address = address;

          _markers.clear();
          _markers.add(
            Marker(
              markerId: MarkerId(position.toString()),
              position: position,
              draggable: true,
              infoWindow: InfoWindow(
                title: _placeName,
                snippet: _address,
              ),
              onTap: () {
                _onMarkerTapped(position);
              },
              onDragEnd: _onMarkerDragEnd,
            ),
          );
        });
      }
    } catch (e) {
      print("Error updating marker: $e");
    }
  }

  void _onMarkerDragEnd(LatLng position) async {
    await _updateMarkerPosition(position);
  }

  void _onMarkerTapped(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String placeName = placemark.name ?? "";
        String thoroughfare = placemark.thoroughfare ?? "";
        String subThoroughfare = placemark.subThoroughfare ?? "";
        String locality = placemark.locality ?? "";
        String administrativeArea = placemark.administrativeArea ?? "";
        String postalCode = placemark.postalCode ?? "";
        String country = placemark.country ?? "";

        String title = placeName.isNotEmpty
            ? placeName
            : '${thoroughfare.isNotEmpty ? thoroughfare : ''} ${subThoroughfare.isNotEmpty ? subThoroughfare : ''}';

        String address = '';
        if (placeName.isNotEmpty) {
          address += '$placeName, ';
        }
        address +=
        '$thoroughfare $subThoroughfare, $locality, $administrativeArea $postalCode, $country';
      }
    } catch (e) {
      print("Error getting location details: $e");
    }
  }

  void _saveLocation() {
    // Create a LatLng object with last position
    LatLng position = _lastMapPosition;

    // Retrieve the selected address
    String selectedAddress = _address;

    // Navigate back to previous screen with data
    Navigator.pop(context, {
      'position': position,
      'selectedAddress': selectedAddress,
    });
  }

  void _goToCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(
        CameraUpdate.newLatLng(currentLatLng),
      );

      // Update marker position
      await _updateMarkerPosition(currentLatLng);
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveLocation,
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _goToCurrentLocation,
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        onCameraMove: _onCameraMove,
        onCameraIdle: _onCameraIdle,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15.0,
        ),
        myLocationEnabled: true,
        compassEnabled: true,
        zoomControlsEnabled: false,
        markers: _markers,
        onTap: (LatLng position) {
          _onMarkerDragEnd(position);
        },
      ),
    );
  }
}
