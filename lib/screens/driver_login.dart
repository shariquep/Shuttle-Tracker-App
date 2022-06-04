// ignore_for_file: deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'driver_actions.dart';

class DriverLoginScreen extends StatefulWidget {
  @override
  _DriverLoginScreenState createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  final idTextController = TextEditingController();

  getDriversIDs() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("drivers").get();

    var a = querySnapshot.docs[0];
    return (a['names']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text("Driver Credentials")),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
                child: Image.asset('assets/images/logo2.png'),
              ),
              Text(
                "Enter Valid Driver ID",
                style: TextStyle(fontSize: 22),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
                child: TextField(
                  controller: idTextController,
                  decoration: InputDecoration(
                      // focusedBorder: OutlineInputBorder(
                      //   borderSide:
                      //       const BorderSide(color: Colors.white, width: 2.0),
                      //   borderRadius: BorderRadius.circular(25.0),
                      // ),
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      hintText: "Enter ID"),
                ),
              ),
              // ignore: deprecated_member_use
              SizedBox(
                height: 40,
                width: 140,
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text(
                    'Proceed',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  onPressed: () async {
                    var id = idTextController.text;

                    var ids = await getDriversIDs();
                    if (ids.contains(id)) {
                      print("match found");
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DriverScreen(id: id)));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Invalid ID! Enter valid ID.'),
                      ));
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
