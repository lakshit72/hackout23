import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Album{
  final double x1;
  final double x2;
  final double y1;
  final double y2;

  const Album({
    required this.x1,
    required this.x2,
    required this.y1,
    required this.y2
  });

}


class _MyHomePageState extends State<MyHomePage> {
  double lt = 12.972442;
  double br = 77.580643;

  Future<http.Response> createAlbum(String title) {
  return  http.get(Uri.parse("http://localhost:3000/getCoord"),headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },) ;
}

  
  @override
  Widget build(BuildContext context) {

    MapController controller = MapController();

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: FlutterMap(
        mapController: controller,
    options: MapOptions(
      onTap:(tapPosition, point) => {

        setState(() => {

        },)
      },
      initialCenter: const LatLng(12.972442, 77.580643),
      initialZoom: 15,
    ),
    children: [
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.example.app',
      ),
      PolygonLayer(polygons: [
        Polygon(points:[
          LatLng(lt, br),
          LatLng(lt+0.005, br),
          LatLng(lt+0.005, br+0.005),
          LatLng(lt, br+0.005),
        ],color: Color.fromARGB(100, 255, 0, 0),isFilled: true)
      ])
    ],
  ));
  }
}