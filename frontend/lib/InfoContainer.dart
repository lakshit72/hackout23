import "package:flutter/material.dart";
import "dart:math";

class InfoContainer extends StatefulWidget {
  final Map data;
  const InfoContainer({super.key, required this.data});
  @override
  State<InfoContainer> createState() => _InfoContainerState();
}

class _InfoContainerState extends State<InfoContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 320,
        width: MediaQuery.of(context).size.width * 1,
        decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10))),
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.84),
                child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => widget.data["method"]()))
          ]),
          Row(children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 20),
                child: Column(children: <Widget>[
                  Row(children: <Widget>[
                    Text(widget.data["safetyIndex"].toStringAsFixed(5),
                        style: TextStyle(
                            color: Color.fromARGB(
                                widget.data["colorControllers"][0],
                                widget.data["colorControllers"][1],
                                widget.data["colorControllers"][2],
                                widget.data["colorControllers"][3]),
                            fontSize: 52,
                            fontWeight: FontWeight.bold))
                  ]),
                  Row(children: <Widget>[
                    Text(
                        "Rated by ${widget.data['consensusPopulationCount']} users",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 78, 78, 78),
                            fontSize: 20,
                            fontWeight: FontWeight.bold))
                  ])
                ]))
          ]),
        ]));
  }
}
