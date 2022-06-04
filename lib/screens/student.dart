import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StudentScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const StudentScreen(this.latitude, this.longitude);
  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  Set<Marker> markers = Set<Marker>();
  BitmapDescriptor? pinLocationIcon;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    //custom marker icon from assets/images
    getBytesFromAsset('assets/images/bus.bmp', 64).then((onValue) {
      pinLocationIcon = BitmapDescriptor.fromBytes(onValue);
    });

    //read shuttles' locations from database every second and update widget
    timer =
        Timer.periodic(Duration(milliseconds: 1000), (Timer t) => getData());
  }

  //custom marker icon from assets/images
  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/images/bus.bmp');
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void getData() async {
    markers.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("location").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      markers.add(Marker(
        position: LatLng(a['latitude'], a['longitude']),
        // icon: await BitmapDescriptor.fromAssetImage(
        //     ImageConfiguration(size: Size(48, 48)), 'assets/images/bus.png'),
        markerId: MarkerId(a.id),
        icon: pinLocationIcon!,
        // icon: widget.markerbitmap
      ));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shuttle Tracker")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.latitude, widget.longitude), zoom: 15.00),
        markers: markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
