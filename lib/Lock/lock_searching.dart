// ignore_for_file: avoid_print, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, sized_box_for_whitespace

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smartlock/Register/home.dart';

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
  List bluetoothAddresses = [];
  List bluetoothNames = [];
  bool bluetoothON = false;

  bool isScanningDevices = false;
  bool isDeviceFound = false;

  /// GET CONNNECTED DEVICES
  String getConnectedDevice() {
    String connectedDevice = "";
    for (var device in bluetoothDevices) {
      bool connected = device.isConnected;
      if (connected == true) {
        connectedDevice = device.name!;
        break;
      }
    }
    return connectedDevice;
  }

  /// SCAN
  Future<void> scanDevices() async {
    locksNames.clear();
    bluetoothNames.clear();
    bluetoothAddresses.clear();
    locksNames.add("Select Lock");
    setState(() {
      isScanningDevices = true;
    });
    await Future.delayed(Duration(milliseconds: 1500));
    try {
      bluetoothDevices = await bluetooth.getBondedDevices();
      setState(() {
        isScanningDevices = false;
        isDeviceFound = true;
      });
    } on PlatformException {
      print("Error in scanning the devices");
      setState(() {
        isScanningDevices = false;
        isDeviceFound = false;
      });
    }

    for (int x = 0; x < bluetoothDevices.length; x++) {
      print(bluetoothDevices[x].address);
      print(bluetoothDevices[x].name);
      setState(() {
        bluetoothAddresses.add(bluetoothDevices[x].address);
        bluetoothNames.add(bluetoothDevices[x].name);
      });
    }
    for (var name in bluetoothNames) {
      locksNames.add(name);
    }
    print(bluetoothNames);
    print(bluetoothAddresses);
    print(locksNames);
  }

  /// ENABLE
  void enableBluetooth() {
    bluetooth.requestEnable();
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
  void openLock() async {
    connection?.output.add(ascii.encode('OPEN'));
    print("1");
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
              height: MediaQuery.of(context).size.height * 0.32,
              width: MediaQuery.of(context).size.width * 1,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.05,
              ),
              decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 60,
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
                                  ],
                                ),
                              )),
                  ),
                ],
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
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.35,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "SCAN",
                          style: TextStyle(
                              color: mainColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                        Icon(
                          Icons.cast_connected,
                          color: mainColor,
                        ),
                      ],
                    )),
              ),
              GestureDetector(
                onTap: () {
                  showBluetoothDevices(context);
                },
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.35,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "CONNECT",
                          style: TextStyle(
                              color: mainColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                        Icon(
                          Icons.cast_connected,
                          color: mainColor,
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

  /// CONNECTED DEVICE
  Widget displayConnectedDevice() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }

  /// ADD LOCK
  Widget addLock() {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => const HomeScreen())));
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 0.7,
          padding: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "NEW LOCK",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 17),
              ),
              Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// OPEN LOCK
  Widget displayOpenButton() {
    return GestureDetector(
      onTap: () {
        print("Open");
        openLock();
      },
      child: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width * 0.45,
              child: Image.asset("assets/open.jpg")),
          Text(
            "OPEN",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
          )
        ],
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
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.height * 1,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Stack(
                    children: [displaySearchBar(), connectScanDisplay()],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                displayConnectedDevice(),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                offset: const Offset(0, 1),
                                blurRadius: 3,
                                spreadRadius: 1,
                              ),
                            ],
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: displayOpenButton(),
                      )
                    ],
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
