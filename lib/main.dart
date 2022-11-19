import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:geolocator/geolocator.dart';


void main(){
  runApp(new MaterialApp(
    home: new weatherApp(),
  ));
}

class weatherApp extends StatefulWidget {
  @override
  _weatherAppState createState() => _weatherAppState();
}

class _weatherAppState extends State<weatherApp> {

  TextEditingController cityController = new TextEditingController();
  var currentCity;
  var temperature;
  var description;
  var showcityName;
  var humidity;
  var lati;
  var longi;
  var img;


  // @override
  // initState() {
  //   getLocation();
  //
  //   super.initState();
  // }

  // geo(){
  //   setState(() {
  //     showcityName = showcityName = currentCity;
  //   });


  getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print("position = ");
    print(position);
    lati = position.latitude;
    longi = position.longitude;

    final queryparameter = {
      "lat": lati.toString(),
      "lon": longi.toString(),
      "appid": "e895bdd3ad3cd34431f90118626bb7e3"
    };

    Uri uri = Uri.https(
        "api.openweathermap.org", "/data/2.5/weather", queryparameter);
    var jsonData = await get(uri);
    var json = jsonDecode(jsonData.body);

    setState(() {
      currentCity = json["name"];
      temperature = json["main"]["temp"];
      description = json["weather"][0]["description"];
      humidity = json["main"]["humidity"];
      img = json["weather"][0]["icon"];
      //img = "https://openweathermap.org/img/w/${json["weather"][0]["icon"]}.png";
    });
  }

  void method1() async {
    print("Method1");
    String city = cityController.text;
    print(city);

    final queryparameter = {
      "q": city,
      "appid": "e895bdd3ad3cd34431f90118626bb7e3"
    };
    Uri uri = new Uri.https(
        "api.openweathermap.org", "/data/2.5/weather", queryparameter);
    final jsonData = await get(uri);
    final json = jsonDecode(jsonData.body);
    print(json);
    setState(() {
      currentCity = json["name"];
      temperature = json["main"]["temp"];
      description = json["weather"][0]["description"];
      humidity = json["main"]["humidity"];
      img = json["weather"][0]["icon"];
      //isOk = json["cod"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink.shade100,
        appBar: AppBar(
          backgroundColor: Colors.pink.shade900,
          centerTitle: true,
          title: Text("Weather App",),
        ),

        body: Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Image.network(
                      'https://openweathermap.org/img/wn/${img}@2x.png'),
                  Text("Currently in " +
                      (currentCity == null ? "Loading" : currentCity
                          .toString()),
                      style: TextStyle(fontSize: 30,)),
                  Text((temperature == null ? "Loading" : (temperature - 273)
                      .toStringAsFixed(2)) + "\u00B0",
                    style: TextStyle(
                        fontSize: 50, fontWeight: FontWeight.bold),),
                  Text(
                    (description == null ? "Loading" : description.toString()),
                    style: TextStyle(fontSize: 30),),

                  Text("Humidity: " +
                      ( humidity == null ? "Loading" : humidity
                          .toString()),
                      style: TextStyle(fontSize: 30,)),

                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: cityController,
                      textAlign: TextAlign.center,
                      decoration: new InputDecoration(
                        hintText: "Enter City Name",
                        labelStyle: TextStyle(color: Colors.black12),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: method1, child: Text("Search",
                    //style: TextStyle(fontSize: 20),))
                    //buttonColor: Colors.pink.shade900,
                  ),
                  ),
                  Container(
                    height: 5,
                  ),
                  //Text(showcityName == null?"":showcityName.toString()),
                  ElevatedButton(
                      onPressed: getLocation, child: Text("Presently In",)
                  ),
                  // Text("Presently in: ")

                  // isOk == 200 ? Text("City Name : $currentCity",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),) : Text("Check the city name"),
                ]
            ),
          ),
        )
    );
  }
}
