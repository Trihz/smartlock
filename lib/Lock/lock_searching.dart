// ignore_for_file: avoid_print, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LockSearching extends StatefulWidget {
  const LockSearching({super.key});

  @override
  State<LockSearching> createState() => _LockSearchingState();
}

class _LockSearchingState extends State<LockSearching> {
  Color mainColor = Color.fromARGB(255, 32, 61, 222);

  /// LOCK
  List<String> locksNames = ["Select Lock"];
  String selectedLock = "Select Lock";

  /// BLE OBJECT
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? connection;

  /// BLUETOOTH VARIABLES
  List<BluetoothDevice> bluetoothDevices = [];
  String addressToConnectTo = "";
  List bleAddresses = [];
  List bleNames = [];
  bool bluetoothON = false;

  bool isScanningDevices = false;
  bool isDeviceFound = false;

  /// SCAN
  Future<void> scanDevices() async {
    setState(() {
      isScanningDevices = true;
    });
    await Future.delayed(Duration(seconds: 3));
    try {
      bluetoothDevices = await bluetooth.getBondedDevices();
      setState(() {
        isScanningDevices = false;
        isDeviceFound = true;
      });
    } on PlatformException {
      print("Error");
      setState(() {
        isScanningDevices = false;
      });
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

  /// ENABLE
  void enableBluetooth() {
    bluetooth.requestEnable();
  }

  @override
  void initState() {
    enableBluetooth();
    super.initState();
  }

  /// SEARCH BAR
  Widget displaySearchBar() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(60),
                  )),
              child: Center(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 80,
                  child: CircleAvatar(
                      backgroundColor: mainColor,
                      radius: 55,
                      child: isScanningDevices
                          ? SizedBox()
                          : GestureDetector(
                              onTap: () {
                                scanDevices();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                      child: Icon(
                                    Icons.bluetooth_outlined,
                                    size: 40,
                                    color: Colors.white,
                                    weight: 0.4,
                                  )),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "SCAN",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            )),
                ),
              ),
            ),
            Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Visibility(
                  visible: isScanningDevices,
                  child: Center(
                      child: SpinKitFadingCube(color: Colors.white, size: 50)),
                ))
          ],
        ),
      ],
    );
  }

  /// DISPLAY THE LOCK NAMES DROPDOWN
  Widget lockNames() {
    return Positioned(
        bottom: 5,
        left: MediaQuery.of(context).size.width * 0.15,
        right: MediaQuery.of(context).size.width * 0.15,
        child: DropdownButtonHideUnderline(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.7,
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
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: DropdownButton<String>(
              value: selectedLock,
              iconEnabledColor: Colors.black,
              iconSize: 60,
              dropdownColor: Color.fromRGBO(255, 255, 255, 1),
              items: locksNames.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedLock = newValue!;
                  print(selectedLock);
                });
              },
            ),
          ),
        ));
  }

  /// OPEN DOOR CONTAINER
  Widget openDoorContainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      width: MediaQuery.of(context).size.height * 1,
      decoration: BoxDecoration(color: Colors.white),
      child: Stack(
        children: [displaySearchBar(), lockNames()],
      ),
    );
  }

  /// ADD LOCK
  Widget addLock() {
    return Container(
      child: CircleAvatar(
        radius: 30,
        backgroundColor: mainColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mainColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: MediaQuery.of(context).size.height * 1,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Stack(
                    children: [displaySearchBar(), lockNames()],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.height * 1,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [],
                  ),
                ),
                addLock()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
