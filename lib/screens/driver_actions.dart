import 'dart:async';

import 'package:flutter/material.dart';
import '../utils/driver.dart';
import 'package:location/location.dart' as loc;

class DriverScreen extends StatefulWidget {
  final String id;
  const DriverScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  final DriverActions driver = new DriverActions();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Driver'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
            child: Image.asset('assets/images/logo2.png'),
          ),
          SizedBox(
            width: 180,
            height: 50,
            child: OutlinedButton(
                onPressed: shareLocation,
                child: Text(
                  'START',
                  style: TextStyle(fontSize: 18),
                )),
          ),
          // SizedBox(height: 10),
          // SizedBox(
          //   width: 180,
          //   height: 50,
          //   child: OutlinedButton(
          //       onPressed: enableLiveLocation,
          //       child: Text(
          //         'ENABLE LIVE',
          //         style: TextStyle(fontSize: 18),
          //       )),
          // ),
          SizedBox(height: 10),
          SizedBox(
            width: 180,
            height: 50,
            child: OutlinedButton(
                onPressed: endLocationSharing,
                child: Text(
                  'END',
                  style: TextStyle(fontSize: 18),
                )),
          ),
          // TextButton(onPressed: shareLocation, child: Text('add my location')),
          // TextButton(
          //     onPressed: enableLiveLocation,
          //     child: Text('enable live location')),
          // TextButton(
          //     onPressed: endLocationSharing, child: Text('stop live location')),
        ],
      ),
    );
  }

  void shareLocation() {
    driver.getLocation(widget.id);
    driver.listenLocation(widget.id);
  }

  void endLocationSharing() async {
    var sub = await driver.stopLocation(widget.id);

    Navigator.pop(context);
    Navigator.pushNamed(context, '/');
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }
}
