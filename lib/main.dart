import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Xem thời tiết hôm nay'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double nhietdo = 0;
  double doam = 0;
  double sucgio = 0;
  String des  = "";
  String city = "Chon thanh pho";
  
  void _changeCity() async {
    String url_api = "";
    switch (city) {
      case 'Ha Noi': 
        url_api = 'https://api.openweathermap.org/data/2.5/weather?q=hanoi&appid=024b890760f06546f2697f39cb56a895';
        break;
      case 'Ha Nam': 
        url_api = 'https://api.openweathermap.org/data/2.5/weather?q=hanam&appid=024b890760f06546f2697f39cb56a895';
        break;
      case 'Hai Phong': 
        url_api = 'https://api.openweathermap.org/data/2.5/weather?q=haiphong&appid=024b890760f06546f2697f39cb56a895';
        break;
      case 'Da Nang': 
        url_api = 'https://api.openweathermap.org/data/2.5/weather?q=danang&appid=024b890760f06546f2697f39cb56a895';
        break;
      case 'Thua Thien Hue': 
        url_api = 'https://api.openweathermap.org/data/2.5/weather?q=hue&appid=024b890760f06546f2697f39cb56a895';
        break;
      default:
        return;
    }
    var client = http.Client();
    var res = await client.get(
      Uri.parse(url_api),
      headers: { 'Content-Type': 'application/json'},
    );
    Map<String, dynamic> json = jsonDecode(res.body.toString());
    
    print(json);

    setState(() {
      nhietdo = json["main"]["temp"] - 273.15;
      doam = json["main"]["humidity"].toDouble();
      sucgio = json["wind"]["speed"].toDouble();
      des = json["weather"][0]["description"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            DropdownButton<String>(
              value: city,
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              underline: Container(
                height: 0,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  city = newValue!;
                });
                _changeCity();
              },
              items: <String>[
                'Chon thanh pho',
                'Ha Noi',
                'Ha Nam',
                'Hai Phong',
                'Da Nang',
                'Thua Thien Hue'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            Text(
              'Thời tiết: ' + des.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Nhiệt độ: ' + nhietdo.ceil().toString() + ' độ C',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Độ ẩm: ' + doam.toString() + '%',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Sức gió: ' + sucgio.toString() + ' m/s',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
