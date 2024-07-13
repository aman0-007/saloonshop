import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class ULocation {
  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isDenied) {
      // Handle the case when the user denies the permission
      throw Exception('Location permission denied');
    }
  }

  Future<void> getCurrentLocation(void Function(Position) onLocationUpdate) async {
    await requestLocationPermission();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    onLocationUpdate(position);
  }
}
