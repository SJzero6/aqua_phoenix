import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool is_Switched = false;
  bool is_Switch = false;

  ///URL//
  static const url = 'a3e31cxfvy2q3v-ats.iot.ap-northeast-1.amazonaws.com';

  static const port = 8883;

  /// client id (AWS)///
  static const clientid = 'm_esp';

  final client = MqttServerClient.withPort(url, clientid, port);

  @override
  void initState() {
    _connectMQTT();
    // TODO: implement initState
  }

  _connectMQTT() async {
    await newAWSConnect();
  }

  @override
  Widget build(BuildContext context) {
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
                          title: 'Temperature(ATM)',
                          asset: 'assets/1090683.png',
                          // onTap: () {
                          //   print('heart rate');
                        ),
                        _cardmenu(
                            title: 'Humidity',
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
                            title: 'PH level',
                            asset: 'assets/ph-icon-26.jpg',
                            color: Colors.indigoAccent,
                            fontcolor: Colors.white),
                        _cardmenu(
                            title: 'Water level',
                            asset: 'assets/water-level.png'),
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _cardmenu(
                            title: 'Turbidity',
                            asset: 'assets/PngItem_67486.png',
                            color: Colors.indigoAccent,
                            fontcolor: Colors.white),
                        _cardmenu(
                            title: 'Water temperature',
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
                            'pump',
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
                                  value: is_Switch,
                                  onChanged: (value) {
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
                ]))
              ],
            )));
  }

  Future<int> newAWSConnect() async {
    client.secure = true;

    client.keepAlivePeriod = 20;

    client.setProtocolV311();

    client.logging(on: true);

    final context = SecurityContext.defaultContext;

    /// add certificate from AWS///

    ByteData crctdata = await rootBundle.load(
        'assets/cert/96875593b8ea8a3168fa567626142e9b9a91101e589c127a93abd2d0fd8e7006-certificate.pem.crt');
    context.useCertificateChainBytes(crctdata.buffer.asUint8List());

    ByteData authorities =
        await rootBundle.load('assets/cert/AmazonRootCA1 Aqua.pem');
    context.setClientAuthoritiesBytes(authorities.buffer.asUint8List());

    ByteData keybyte = await rootBundle.load('assets/cert/prvtkeyaqua.key');
    context.usePrivateKeyBytes(keybyte.buffer.asUint8List());
    client.securityContext = context;

    ///add certificate///

    final mess =
        MqttConnectMessage().withClientIdentifier('j_esp').startClean();
    client.connectionMessage = mess;

    try {
      print('MQTT client is connecting to AWS');
      await client.connect();
    } on Exception catch (e) {
      print('MQTT client exception - $e');
      client.disconnect();
    }
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('AWS iot connection succesfully done');

      ///Topic///

      const topic = 'ESPaqua';
      final maker = MqttClientPayloadBuilder();
      maker.addString('hELLO');

      client.publishMessage(topic, MqttQos.atLeastOnce, maker.payload!);

      client.subscribe(topic, MqttQos.atLeastOnce);

      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final rcvmsg = c[0].payload as MqttPublishMessage;
        final pt =
            MqttPublishPayload.bytesToStringAsString(rcvmsg.payload.message);
        print(
            'Example::Change notification:: topic is<${c[0].topic}>, payload is <--$pt-->');
      });

      print(
          'ERROR MQTT client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
      client.disconnect();
    }
    // print('died');
    // await MqttUtilities.asyncSleep(10);
    // print('Diconnectiong....');
    // client.disconnect();

    return 0;
  }

  void pumpOn() {
    const topic = 'Aquaponics';
    final make = MqttClientPayloadBuilder();
    make.addString('motor ON');
    client.publishMessage(topic, MqttQos.atLeastOnce, make.payload!);
  }
}

Widget _cardmenu(
    {required String title,
    required asset,
    Color color = Colors.white,
    Color fontcolor = Colors.grey}) {
  return GestureDetector(
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 36),
      width: 156,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(24), color: color),
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
