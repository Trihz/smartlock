// ignore_for_file: avoid_unnecessary_containers, avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color mainColor = Colors.blue;

  /// BLE OBJECT
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? connection;

  /// BLUETOOTH VARIABLES
  List<BluetoothDevice> bluetoothDevices = [];
  String addressToConnectTo = "";
  List bleAddresses = [];
  List bleNames = [];
  bool bluetoothON = false;

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
        bleAddresses.add(bluetoothDevices[x].address);
        bleNames.add(bluetoothDevices[x].name);
      });
      print("");
    }
  }

  /// CONNECT
  void bluetoothConnect(String addressToConnectTo) async {
    try {
      connection = await BluetoothConnection.toAddress(addressToConnectTo);
      print('Connected to the device');
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

  /// connection status  boolean
  bool connectionStatus = false;

  /// FINGER ID DISPLAY
  Widget displayFingerID() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 1,
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Finger ID",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {});
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
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)))),
            child: const Text("SAVE"),
          )
        ],
      ),
    );
  }

  /// OPEN LOCK BUTTON
  Widget openLockBLE() {
    return Container(
      child: Center(
        child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)))),
            icon: const Icon(Icons.lock_open),
            label: const Text("OPEN")),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: mainColor,
        child: SafeArea(
            child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [displayFingerID(), openLockBLE()],
          ),
        )));
  }
}
