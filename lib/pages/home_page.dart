import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController = TextEditingController();
  var temp;
  var description;
  var current;
  var humidity;
  var windspeed;
  var locationName;

  Future getWeather(String location) async {
    http.Response response = await http.get(
        'http://api.openweathermap.org/data/2.5/weather?q=$location&appid=<TOKEN>');
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.current = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windspeed = results['wind']['speed'];
      this.locationName = results["name"];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getWeather("Coimbatore");
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              color: Colors.blueAccent,
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 300,
                    child: TextField(
                      cursorColor: Colors.white,
                      controller: myController,
                      style: TextStyle(color: Colors.white, fontSize: 25.0),
                      decoration: InputDecoration(
                          hoverColor: Colors.white,
                          focusColor: Colors.white,
                          hintText: 'Search',
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            onPressed: () => getWeather(myController.text),
                          ),
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                  Text(
                    myController.text != null ? locationName : "Coimbatore",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    temp != null
                        ? (temp - 273).toStringAsFixed(2) + " °C"
                        : "Loading..",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    current != null ? current.toString() : "Loading..",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 5),
                child: ListView(
                  children: [
                    ListTile(
                      title: Text("Temperature"),
                      trailing: Text(temp != null
                          ? (temp - 273).toStringAsFixed(2) + " °"
                          : "Loading"),
                      leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                    ),
                    ListTile(
                      title: Text("Weather"),
                      trailing: Text(description != null
                          ? description.toString()
                          : "Loading"),
                      leading: FaIcon(FontAwesomeIcons.cloud),
                    ),
                    ListTile(
                      title: Text("Temperature Humidity"),
                      trailing: Text(
                          humidity != null ? humidity.toString() : "Loading"),
                      leading: FaIcon(FontAwesomeIcons.sun),
                    ),
                    ListTile(
                      title: Text("Wind Speed"),
                      trailing: Text(
                          windspeed != null ? windspeed.toString() : "Loading"),
                      leading: FaIcon(FontAwesomeIcons.wind),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
