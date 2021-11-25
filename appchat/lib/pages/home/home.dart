import 'dart:async';

import 'package:appchat/models/user_model.dart';
import 'package:appchat/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Completer<GoogleMapController> _controller = Completer();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.004107192135967, -74.80699203175993),
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .get()
      .then((value) {
        loggedInUser = UserModel.fromMap(value.data());
      setState((){});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MapChat"),
        //centerTitle: true,
        actions: [
          ToggleSwitch(
            minWidth: 60.0,
            initialLabelIndex: switchToggle(),
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.transparent,
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            icons: const [Icons.person, Icons.person_off,
            ],
            iconSize: 40.0,
            activeBgColors: const [[Colors.teal, Colors.tealAccent], [Colors.black45, Colors.teal]],
            animate: true, // with just animate set to true, default curve = Curves.easeIn
            curve: Curves.bounceInOut, // animate must be set to true when using custom curve
            onToggle: (index) {
              changeStatus(index);
              print('switched to: $index');
            },
          ),
        ],
      ),
      body: const GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        zoomControlsEnabled: false,
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.black,
        curve: Curves.easeIn,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.logout_rounded, color: Colors.black),
            label: 'Salir',
            backgroundColor: Colors.teal,
            onTap: (){
              logOut(context);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.person, color: Colors.black),
            label: "Usuario: ${loggedInUser.name} ${loggedInUser.lastName}",
            backgroundColor: Colors.teal,
            onTap: (){},
          ),
        ],
      ),
    );
  }

  Future<void> logOut(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>const Login()));
  }

  changeStatus(int index) async{
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    firebaseFirestore
        .collection('users')
        .doc(loggedInUser.uid)
        .update({
          'status':  index.toString()
        });
    if(index == 0){
      Fluttertoast.showToast(msg: 'ONLINE');
    } else if(index == 1){
      Fluttertoast.showToast(msg: 'OFFLINE');
    }

  }

  switchToggle(){
    if (loggedInUser.status == '0'){
      return 0;
    } else if(loggedInUser.status == '1'){
      return 1;
    } else{
      return 1;
    }
  }
}


