import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_map_live/screens/driver_login.dart';
import 'package:google_map_live/screens/student.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => MyApp(),
        '/driverLogin': (context) => DriverLoginScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
      },
      theme: ThemeData(
        primaryColor: Color.fromRGBO(83, 146, 87, 1),
        colorScheme: ColorScheme.light().copyWith(
            primary: Color.fromRGBO(83, 146, 87, 1),
            secondary: Color.fromARGB(255, 81, 81, 81)),
      )
      //   home: MyApp()
      ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final loc.Location location = loc.Location();

  @override
  void initState() {
    super.initState();
    _requestPermission();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('NUST Shuttle Tracker'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //logo image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
            child: Image.asset('assets/images/logo2.png'),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 45.0),
            child: Text("Continue as",
                style: TextStyle(
                  fontSize: 20.0,
                )),
          ),

          SizedBox(
            width: 180,
            height: 50,
            child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/driverLogin');
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => DriverLoginScreen()));
                },
                child: Text(
                  'Shuttle Driver',
                  style: TextStyle(fontSize: 18),
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Row(children: <Widget>[
            Expanded(
              child: new Container(
                  margin: const EdgeInsets.only(left: 60.0, right: 20.0),
                  child: Divider(
                    color: Colors.black26,
                    height: 36,
                  )),
            ),
            Text("OR"),
            Expanded(
              child: new Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 60.0),
                  child: Divider(
                    color: Colors.black26,
                    height: 36,
                  )),
            ),
          ]),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 180,
            height: 50,
            child: OutlinedButton(
                onPressed: () async {
                  final loc.LocationData locationResult =
                      await location.getLocation();

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => StudentScreen(
                            locationResult.latitude!,
                            locationResult.longitude!,
                          )));
                },
                child: Text('Shuttle User', style: TextStyle(fontSize: 18))),
          ),
        ],
      ),
    );
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
