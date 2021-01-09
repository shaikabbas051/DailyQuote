import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

import 'package:flutter_svg/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //state start
  var data;

  bool showMessage = false;
  Map _messageData = {};
  int _imageData = 1;
  //state end *******************
  //check if the message and image is already loaded or the app is opened for the first time
  Future<bool> isDataPresent() async {
    final SharedPreferences prefs = await _prefs;
    String messageData = prefs.getString("messageData");
    return messageData != null;
  }

  Future checkDataValidity() async {
    final SharedPreferences prefs = await _prefs;
    int createdAt = prefs.getInt("createdAt");
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(createdAt);
    int timestamp = date.add(Duration(minutes: 1)).millisecondsSinceEpoch;
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    return currentTimestamp <= timestamp;
  }

  Future getNewQuote() async {
    final SharedPreferences prefs = await _prefs;
    String jsonstring = await DefaultAssetBundle.of(context)
        .loadString("lib/Fixtures/MessageData.json");
    List raw = jsonDecode(jsonstring);
    Random random = new Random();
    //random number for message
    int randomNumber_message = random.nextInt(364) + 1;
    //random number for image
    int randomNumber_image = random.nextInt(4) + 1;
    //timestamp
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    Map messageData = raw[randomNumber_message];
    await prefs.setString("messageData", jsonEncode(messageData));
    await prefs.setInt("imageData", randomNumber_image);
    await prefs.setInt("createdAt", timestamp);
    setState(() {
      _imageData = randomNumber_image;
      showMessage = true;
      _messageData = messageData;
    });
  }

  Future loadQuote() async {
    bool isData = await isDataPresent();
    print(isData);
    if (isData) {
      bool isValid = await checkDataValidity();
      print(isValid);
      if (isValid) {
        final SharedPreferences prefs = await _prefs;
        String messageData = prefs.getString("messageData");
        int imageData = prefs.getInt("imageData");
        setState(() {
          _imageData = imageData;
          showMessage = true;
          _messageData = jsonDecode(messageData);
        });
        return;
      } else {
        return getNewQuote();
      }
    } else {
      return getNewQuote();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Widget renderElement() {
    if (!showMessage) {
      return renderEnvelope();
    }
    return renderMessage();
  }

  Widget renderEnvelope() {
    return GestureDetector(
      child: SvgPicture.asset(
        "lib/Assets/email.svg",
        width: 250,
        height: 200,
      ),
      onTap: () {
        loadQuote();
      },
    );
  }

  Widget renderMessage() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("lib/Assets/image" + _imageData.toString() + ".jpg"),
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.6), BlendMode.dstATop),
          ),
        ),
        child: Center(
            child: Text(
          _messageData["message"],
          style: TextStyle(fontSize: 20, color: Colors.black),
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),
        actions: [
          FlatButton(
            child: Text("reset"),
            onPressed: () {
              setState(() {
                showMessage = false;
              });
            },
          )
        ],
      ),
      body: Center(
        child: renderElement(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
