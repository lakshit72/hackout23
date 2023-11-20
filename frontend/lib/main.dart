import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "./InfoContainer.dart";

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

class _MyHomePageState extends State<MyHomePage> {
  double scale = 0.005;
  bool infoContainerVisibility = false;
  Map infoContainerData = {};
  List<Polygon> polygons = [];
  Widget _infoContainerWidget = Visibility(visible: false, child: Container());

  Future<http.Response> requestParentBlock(coords) {
    return http.post(Uri.parse("http://172.17.200.210:3000/find"),
        headers: <String, String>{
          "Content-Type": "application/json",
        },
        body: jsonEncode(<String, dynamic>{
          "latitude": coords["latitude"],
          "longitude": coords["longitude"]
        }));
  }

  Widget _infoContainerBuilder(data) {
    return Positioned(bottom: 0, child: InfoContainer(data: data));
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
        body: Stack(children: <Widget>[
          FlutterMap(
            mapController: controller,
            options: MapOptions(
              onTap: (tapPosition, point) {
                // print(tapPosition);
                // print(point);
                // print(polygons);
                requestParentBlock({
                  "longitude": point.longitude,
                  "latitude": point.latitude
                }).then((res) {
                  Map parentBlock = jsonDecode(res.body);
                  List<int> colorUpperBound = [104, 255, 0, 0];
                  List<int> colorLowerBound = [104, 64, 255, 0];
                  List<int> colorControllers = [
                    255,
                    255,
                    255,
                    255
                  ]; //R G B changes
                  int safetyIndexRange = 10;

                  colorControllers[0] = 104;
                  colorControllers[2] = (colorUpperBound[2] -
                          (parentBlock["safetyIndex"] *
                              ((colorUpperBound[2] - colorLowerBound[2]) /
                                  safetyIndexRange)))
                      .toInt();
                  colorControllers[1] =
                      (parentBlock["safetyIndex"] > 5) ? 0 : 255;
                  colorControllers[3] = 0;
                  // Changing the state variables
                  setState(() {
                    polygons = [
                      //...polygons,
                      Polygon(
                          points: [
                            LatLng(
                                double.parse(parentBlock["coordinates"]["y1"]),
                                double.parse(parentBlock["coordinates"]["x1"])),
                            LatLng(
                                double.parse(parentBlock["coordinates"]["y1"]),
                                double.parse(parentBlock["coordinates"]["x2"])),
                            LatLng(
                                double.parse(parentBlock["coordinates"]["y2"]),
                                double.parse(parentBlock["coordinates"]["x2"])),
                            LatLng(
                                double.parse(parentBlock["coordinates"]["y2"]),
                                double.parse(parentBlock["coordinates"]["x1"])),
                          ],
                          color: Color.fromARGB(
                              colorControllers[0],
                              colorControllers[1],
                              colorControllers[2],
                              colorControllers[3]),
                          isFilled: true)
                    ];
                    parentBlock["colorControllers"] = colorControllers;
                    parentBlock["method"] = () => setState(() =>
                        _infoContainerWidget = Visibility(
                            visible: false,
                            maintainSize: false,
                            child: Container()));
                    _infoContainerWidget = _infoContainerBuilder(parentBlock);
                  });
                });
              },
              initialCenter: const LatLng(12.972442, 77.580643),
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              PolygonLayer(polygons: polygons)
            ],
          ),
          _infoContainerWidget,
        ]));
  }
}
