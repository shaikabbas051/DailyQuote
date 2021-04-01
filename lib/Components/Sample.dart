import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller =
        new AnimationController(duration: Duration(seconds: 2), vsync: this)
          ..addListener(() => setState(() {}));
    animation = Tween(begin: 100.0, end: 200.0).animate(controller);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    // print(animation.value);
    return Scaffold(
        body: Transform.translate(
      child: Container(
          height: 300, width: 300, color: Colors.red, child: Text("Abbas")),
      offset: Offset(animation.value, 0.0),
    ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
