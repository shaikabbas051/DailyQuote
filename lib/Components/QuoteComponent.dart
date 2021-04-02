import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Quote extends StatelessWidget {
  const Quote({key, this.imageData, this.messageData}) : super(key: key);
  final int imageData;
  final Map messageData;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "myImage",
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("lib/Assets/image" + imageData.toString() + ".jpg"),
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.6), BlendMode.dstATop),
          ),
        ),
        child: Center(
          child: Text(
            messageData["message"],
            // "Good Morning",
            //
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
