// ignore_for_file: avoid_unnecessary_containers, avoid_print, use_build_context_synchronously, prefer_const_constructors, sized_box_for_whitespace

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color mainColor = Color.fromARGB(255, 32, 61, 222);

  String connectedLock = "";

  /// BLE OBJECT
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? connection;

  /// BLUETOOTH VARIABLES
  List<BluetoothDevice> bluetoothDevices = [];
  String addressToConnectTo = "";
  List bluetoothAddresses = [];
  List bluetoothNames = [];
  bool bluetoothON = false;

  /// USER DETAILS
  String userGmail = "";
  String userFingerID = "";

  /// ENABLE
  void enableBluetooth() {
    bluetooth.requestEnable();
  }

  /// SCAN
  Future<void> scanDevices() async {
    try {
      bluetoothDevices = await bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    for (int x = 0; x < bluetoothDevices.length; x++) {
      print(bluetoothDevices[x].address);
      print(bluetoothDevices[x].name);
      setState(() {
        bluetoothAddresses.add(bluetoothDevices[x].address);
        bluetoothNames.add(bluetoothDevices[x].name);
      });
      print("");
    }
  }

  /// CONNECT
  void bluetoothConnect(String addressToConnectTo) async {
    try {
      connection = await BluetoothConnection.toAddress(addressToConnectTo);
      print('Connected to the device');
      int addressId = bluetoothAddresses.indexOf(addressToConnectTo);
      setState(() {
        connectedLock = bluetoothNames[addressId];
      });
      Navigator.pop(context);
    } catch (exception) {
      print('Cannot connect, exception occured');
    }
  }

  /// SEND
  void sendShockData() async {
    connection?.output.add(ascii.encode('Open door'));
    print("A");
  }

  /// DISPLAY THE LOCK NAMES DROPDOWN
  Widget connectScanDisplay() {
    return Positioned(
        bottom: 5,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width * 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  scanDevices();
                },
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 3,
                            spreadRadius: 1,
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "SCAN",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                        Icon(
                          Icons.cast_connected,
                          color: Colors.black,
                        ),
                      ],
                    )),
              ),
              GestureDetector(
                onTap: () {
                  showBluetoothDevices(context);
                },
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 3,
                            spreadRadius: 1,
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "CONNECT",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                        Icon(
                          Icons.cast_connected,
                          color: Colors.black,
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }

  void showBluetoothDevices(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: Container(
          height: MediaQuery.of(context).size.height * 0.35,
          width: MediaQuery.of(context).size.width * 1,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: ListView.builder(
              itemCount: bluetoothNames.length,
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: () {
                    print(bluetoothNames[index]);
                    print(bluetoothAddresses[index]);
                    bluetoothConnect(bluetoothAddresses[index]);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 1,
                    margin: const EdgeInsets.only(bottom: 3),
                    decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          bluetoothNames[index],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          bluetoothAddresses[index],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                );
              })),
        ));
      },
    );
  }

  /// FINGER ID DISPLAY
  Widget displayLockName() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 1,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Lock Name",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {});
              },
              readOnly: true,
              decoration: InputDecoration(
                hintText: connectedLock,
                contentPadding: EdgeInsets.all(10.0),
                hintStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// LOCK NAME DISPLAY
  Widget displayFingerID() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 1,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Finger ID",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  userFingerID = value;
                });
              },
              readOnly: true,
              decoration: const InputDecoration(
                hintText: "84202014",
                contentPadding: EdgeInsets.all(10.0),
                hintStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// USER DETAILS DISPLAY
  Widget displayUserDetails() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 1,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Gmail",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  userGmail = value;
                });
              },
              readOnly: false,
              decoration: const InputDecoration(
                hintText: "Enter your gmail",
                contentPadding: EdgeInsets.all(10.0),
                hintStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// OPEN LOCK BUTTON
  Widget saveButton() {
    return Container(
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ElevatedButton(
          onPressed: () {
            saveUserDetails();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: mainColor,
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)))),
          child: const Text("SAVE"),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: mainColor,
        child: SafeArea(
            child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  connectScanDisplay(),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 3,
                            spreadRadius: 1,
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        displayUserDetails(),
                        displayFingerID(),
                        displayLockName(),
                        saveButton()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )));
  }

  /// SAVE THE USER DETAILS
  void saveUserDetails() {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref("USERS").push();

    databaseReference.set({"GMAIL": userGmail, "FINGERID": userFingerID});
  }
}
