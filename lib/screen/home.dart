import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';
import 'package:aqua_phoenix/provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool is_Switched = false;
  bool is_Switch = false;
  bool is_Switching = false;

  ///URL//

//check up values//
  double hume = 0.0;
  double atm = 0.0;
  double ph = 0.0;
  var level = 0;
  var turb = 0;
  double temp = 0.0;

//check up values//

  @override
  void initState() {
    Mqttprovider mqttProvider =
        Provider.of<Mqttprovider>(context, listen: false);
    mqttProvider.newAWSConnect();
    super.initState();

    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    Mqttprovider mqttProvider = Provider.of<Mqttprovider>(context);

    Map<String, dynamic> log = json.decode(mqttProvider.rawLogData);

    hume = log["humidity"] ?? 0;
    atm = log["A_temperature"] ?? 0;
    ph = log["PH"] ?? 0;
    level = log[""] ?? 0;
    turb = log["turbidity"] ?? 0;
    temp = log["W_temperature"] ?? 0;

    return Scaffold(
        backgroundColor: Colors.blue[100],
        body: Container(
            margin: EdgeInsets.only(left: 10, top: 19, bottom: 5, right: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'HI..! Welcome',
                      style: GoogleFonts.aclonica(
                          fontSize: 20, color: Colors.indigo),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      child: Icon(Icons.settings),
                    ),
                  ],
                ),
                Expanded(
                    child:
                        ListView(physics: BouncingScrollPhysics(), children: [
                  Center(
                      child: Container(
                          margin: EdgeInsets.only(left: 5),
                          height: 300,
                          width: 300,
                          child: Image.asset('assets/aqwu.png'))),
                  Center(
                    child: Text('SMART AQUAPONICS',
                        style: GoogleFonts.aclonica(
                            fontSize: 20, color: Colors.indigo)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CHECK-UP\'S',
                          style: GoogleFonts.abel(
                              textStyle: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        RotatedBox(
                            quarterTurns: 135,
                            child: Icon(
                              Icons.bar_chart_rounded,
                              size: 28,
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _cardmenu(
                          title: 'Temperature(ATM)\n$atm',
                          asset: 'assets/1090683.png',
                          // onTap: () {
                          //   print('heart rate');
                        ),
                        _cardmenu(
                            title: 'Humidity\n$hume',
                            asset: 'assets/1779817.png',
                            color: Colors.indigoAccent,
                            fontcolor: Colors.white),
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _cardmenu(
                            title: 'PH level\n$ph',
                            asset: 'assets/ph-icon-26.jpg',
                            color: Colors.indigoAccent,
                            fontcolor: Colors.white),
                        _cardmenu(
                            title: 'Water level\n$level',
                            asset: 'assets/water-level.png'),
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _cardmenu(
                            title: 'Turbidity\n$turb',
                            asset: 'assets/PngItem_67486.png',
                            color: Colors.indigoAccent,
                            fontcolor: Colors.white),
                        _cardmenu(
                            title: 'Water temperature\n$temp',
                            asset: 'assets/water temp.png'),
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 80,
                    width: 40,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Automatic',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("OFF"),
                                Switch(
                                  value: is_Switched,
                                  onChanged: (value) {
                                    if (value) {
                                      mqttProvider.switches('5');
                                    } else {
                                      mqttProvider.switches('6');
                                    }
                                    setState(() {
                                      is_Switched = value;
                                    });
                                  },
                                  activeTrackColor: Colors.indigo[200],
                                  activeColor: Colors.indigoAccent,
                                ),
                                Text("ON"),
                              ],
                            ),
                          ),
                          // SizedBox(height: 1),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                    width: 40,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Pump',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("OFF"),
                                Switch(
                                  value: is_Switch,
                                  onChanged: (value) {
                                    if (value) {
                                      mqttProvider.switches('1');
                                    } else {
                                      mqttProvider.switches('2');
                                    }
                                    setState(() {
                                      is_Switch = value;
                                      print(is_Switch);
                                    });
                                  },
                                  activeTrackColor: Colors.indigo[200],
                                  activeColor: Colors.indigoAccent,
                                ),
                                Text("ON"),
                              ],
                            ),
                          ),

                          // SizedBox(height: 1),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                    width: 40,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Feeding',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("OFF"),
                                Switch(
                                  value: is_Switching,
                                  onChanged: (value) {
                                    if (value) {
                                      mqttProvider.switches('3');
                                    } else {
                                      mqttProvider.switches('4');
                                    }
                                    setState(() {
                                      is_Switching = value;
                                      print(is_Switching);
                                    });
                                  },
                                  activeTrackColor: Colors.indigo[200],
                                  activeColor: Colors.indigoAccent,
                                ),
                                Text("ON"),
                              ],
                            ),
                          ),

                          // SizedBox(height: 1),
                        ],
                      ),
                    ),
                  ),
                ]))
              ],
            )));
  }

//

  Widget _cardmenu(
      {required String title,
      required asset,
      Color color = Colors.white,
      Color fontcolor = Colors.grey}) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 36),
        width: 156,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24), color: color),
        child: Column(children: [
          Container(
            height: 60,
            width: 60,
            child: Image.asset(
              asset,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: fontcolor,
            ),
          )
        ]),
      ),
    );
  }
}
