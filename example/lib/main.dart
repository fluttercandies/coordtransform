import 'package:coordtransform/coordtransform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoordTransformExample',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'Coord Transform Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController lonTextEditingController, latTextEditingController;
  late RegExp lonRegExp, latRegExp;
  double longitude = 116.404, latitude = 39.915;
  String? lonError, latError;

  @override
  void initState() {
    lonTextEditingController = TextEditingController(text: '$longitude');
    latTextEditingController = TextEditingController(text: '$latitude');
    lonRegExp = RegExp(
        r'^[\-\+]?(0(.\d{1,10})?|([1-9](\d)?)(.\d{1,10})?|1[0-7]\d{1}(.\d{1,10})?|180.0{1,10})$');
    latRegExp =
        RegExp(r'^[\-\+]?((0|([1-8]\d?))(\.\d{1,10})?|90(\.0{1,10})?)$');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          children: <Widget>[
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(24),
                      child: TextField(
                        controller: lonTextEditingController,
                        decoration: InputDecoration(
                            helperText: "Please input longitude",
                            errorText: lonError),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(24),
                      child: TextField(
                        controller: latTextEditingController,
                        decoration: InputDecoration(
                            helperText: "Please input latitude",
                            errorText: latError),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(24),
                    child: TextButton(
                      onPressed: _transform,
                      child: Text("Transform"),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Builder(builder: (ctx) {
                    CoordResult result = CoordTransform.transformBD09toGCJ02(
                        longitude, latitude);
                    return Text("BD09toGCJ02: ${result.lon}, ${result.lat}");
                  }),
                  Divider(height: 4),
                  Builder(builder: (ctx) {
                    CoordResult result = CoordTransform.transformGCJ02toBD09(
                        longitude, latitude);
                    return Text("GCJ02toBD09: ${result.lon}, ${result.lat}");
                  }),
                  Divider(height: 4),
                  Builder(builder: (ctx) {
                    CoordResult result = CoordTransform.transformWGS84toGCJ02(
                        longitude, latitude);
                    return Text("WGS84toGCJ02: ${result.lon}, ${result.lat}");
                  }),
                  Divider(height: 4),
                  Builder(builder: (ctx) {
                    CoordResult result = CoordTransform.transformGCJ02toWGS84(
                        longitude, latitude);
                    return Text("GCJ02toWGS84: ${result.lon}, ${result.lat}");
                  }),
                  Divider(height: 4),
                  Builder(builder: (ctx) {
                    CoordResult result = CoordTransform.transformBD09toWGS84(
                        longitude, latitude);
                    return Text("BD09toWGS84: ${result.lon}, ${result.lat}");
                  }),
                  Divider(height: 4),
                  Builder(builder: (ctx) {
                    CoordResult result = CoordTransform.transformWGS84toBD09(
                        longitude, latitude);
                    return Text("WGS84toBD09: ${result.lon}, ${result.lat}");
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _transform() {
    lonError = lonRegExp.hasMatch(lonTextEditingController.text)
        ? null
        : 'Longitude input error';
    latError = latRegExp.hasMatch(latTextEditingController.text)
        ? null
        : 'Latitude input error';
    if (lonError == null && latError == null) {
      longitude = double.parse(lonTextEditingController.text);
      latitude = double.parse(latTextEditingController.text);
    }
    setState(() {});
  }
}
