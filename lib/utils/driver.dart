import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart' as loc;

class DriverActions {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  bool stopped = false;

  void getLocation(String id) async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc(id).set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> listenLocation(String id) async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      _locationSubscription = null;
      // setState(() {
      //   _locationSubscription = null;
      // });
    }).listen((loc.LocationData currentlocation) async {
      if (stopped == false) {
        await FirebaseFirestore.instance.collection('location').doc(id).set({
          'latitude': currentlocation.latitude,
          'longitude': currentlocation.longitude,
        }, SetOptions(merge: true));
      } else {
        _locationSubscription?.cancel();
        _locationSubscription = null;
        await FirebaseFirestore.instance
            .collection('location')
            .doc(id)
            .delete();
      }
    });
  }

  stopLocation(String id) async {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    stopped = true;
    await FirebaseFirestore.instance.collection('location').doc(id).delete();
    return _locationSubscription;
  }
}
