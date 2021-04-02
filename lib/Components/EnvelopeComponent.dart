import 'package:envelope/Components/QuoteComponent.dart';
import 'package:envelope/Components/SideTriangle.dart';
import 'package:envelope/Components/Triangle.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class Envelope extends StatefulWidget {
  @override
  _EnvelopeState createState() => _EnvelopeState();
}

class _EnvelopeState extends State<Envelope> with TickerProviderStateMixin {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //state start
  var data;

  bool showMessage = false;
  Map _messageData = {};
  int _imageData = 1;
  var fraction = 0.0174533;
  bool envelopOpened = false;
  double containerWidth = 250;
  double containerHeight = 150;
  double triangleRadius = 12;
  int envelopeAnimationTime = 2;
  int cardAnimationTime = 2;
  //state end *******************
  //check if the message and image is already loaded or the app is opened for the first time
  Future<bool> isDataPresent() async {
    final SharedPreferences prefs = await _prefs;
    String messageData = prefs.getString("messageData");
    return messageData != null;
  }

  //checking the quote validity; temporarily adding it to 1 min for testing
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
          _messageData = jsonDecode(messageData);
        });
        print(_messageData);
        return;
      } else {
        return getNewQuote();
      }
    } else {
      return getNewQuote();
    }
  }

  AnimationController envelopeController;
  Animation<double> envelopeAnimation;
  AnimationController cardController;
  Animation<double> cardAnimation;
  @override
  void initState() {
    super.initState();

    envelopeController = new AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this)
      ..addListener(() => setState(() {}));
    envelopeAnimation =
        Tween(begin: 0.0, end: 180.0).animate(envelopeController);
    //card
    cardController = new AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this)
      ..addListener(() => setState(() {}));
    cardAnimation = Tween(begin: 0.0, end: -125.0).animate(cardController);
    loadQuote();
  }

  void animateEnvelope() {
    envelopeController.forward();
    new Timer(const Duration(milliseconds: 2100), () {
      setState(() {
        envelopOpened = true;
      });
      animateCard();
    });
  }

  void animateCard() {
    cardController.forward();
    new Timer(const Duration(milliseconds: 1600), () {
      // loadQuote();
      navigateToQuotePage();
    });
  }

  navigateToQuotePage() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Quote(
          imageData: _imageData,
          messageData: _messageData,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      ),
    );
  }

  Widget card() {
    return Container(
      height: containerHeight - 20,
      width: containerWidth - 20,
      margin: new EdgeInsets.fromLTRB(10, 10, 10, 0),
      transform: new Matrix4.translationValues(0, cardAnimation.value, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image:
              AssetImage("lib/Assets/image" + _imageData.toString() + ".jpg"),
          fit: BoxFit.cover,
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.9), BlendMode.dstATop),
        ),
      ),
      child: Hero(
          tag: "myImage",
          child: Center(
            child: Text(
              _messageData.containsKey('message')
                  ? _messageData["message"]
                  : "",
              // "boom",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          )),
    );
  }

  Widget envelopeTop() {
    return new Container(
      height: containerHeight,
      width: containerWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(triangleRadius),
        child: CustomPaint(
          painter: TrianglePainter(color: Color(0xffffd140)),
        ),
      ),
      // padding: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      transform: new Matrix4.rotationX(
          0.0174533 * envelopeAnimation.value), // rotate -10 deg
    );
  }

  Widget renderCustomEnvelope() {
    return GestureDetector(
      onTap: () => {animateEnvelope()},
      behavior: HitTestBehavior.translucent,
      child: new Stack(
        children: [
          Container(
            height: containerHeight,
            width: containerWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(triangleRadius),
              color: Color(0xffffd140),
            ),
          ),
          envelopOpened ? envelopeTop() : card(),
          envelopOpened ? card() : SizedBox(),
          // envelopOpened ? card() : envelopeTop(),
          //right
          Transform.rotate(
            child: Container(
              height: containerHeight,
              width: containerWidth,
              // color: Colors.red,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(triangleRadius),
                child: CustomPaint(
                  painter: SideTrianglePainter(color: Color(0xfffebd0b)),
                ),
              ),
            ),
            angle: fraction * 0,
          ),
          Transform.rotate(
            child: Container(
              height: containerHeight,
              width: containerWidth,
              // color: Colors.red,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(triangleRadius),
                child: CustomPaint(
                    painter: SideTrianglePainter(color: Color(0xfffebd0b))),
              ),
            ),
            angle: fraction * 180,
          ),
          //bottom
          Transform.rotate(
            child: Container(
              height: containerHeight,
              width: containerWidth,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(triangleRadius),
                child: CustomPaint(
                  painter: TrianglePainter(
                    color: Color(0xffff9700),
                  ),
                ),
              ),
            ),
            angle: fraction * 180,
          ),
          envelopOpened ? SizedBox() : envelopeTop(),
          Container(
            width: containerWidth,
            child: Text(
              "Message for the day",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            transform: new Matrix4.translationValues(0, 170, 0),
          )
        ],
      ),
    );
  }

  Widget renderElement() {
    // if (!showMessage) {
    return renderCustomEnvelope();
    // }
    // return renderMessage();
  }

  // Widget renderMessage() {
  //   return Container(
  //     height: MediaQuery.of(context).size.height,
  //     width: MediaQuery.of(context).size.width,
  //     decoration: BoxDecoration(
  //       image: DecorationImage(
  //         image:
  //             AssetImage("lib/Assets/image" + _imageData.toString() + ".jpg"),
  //         fit: BoxFit.cover,
  //         colorFilter: new ColorFilter.mode(
  //             Colors.black.withOpacity(0.6), BlendMode.dstATop),
  //       ),
  //     ),
  //     child: Center(
  //       child: Text(
  //         _messageData["message"],
  //         style: TextStyle(fontSize: 20, color: Colors.black),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Envelope"),
        actions: [
          // FlatButton(
          //   child: Text("reset"),
          //   onPressed: () {
          //     setState(() {
          //       showMessage = false;
          //     });
          //   },
          // )
        ],
      ),
      body: Center(
        child: renderElement(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
//side #febd0b
//bottom ff9700
//top ffd140
