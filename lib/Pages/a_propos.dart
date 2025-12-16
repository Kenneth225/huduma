import 'package:flutter/material.dart';

class Propos extends StatelessWidget {
  const Propos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Container(
        margin: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('images/icon.png'))),
                                  child: Column(
                                    children: [
                                      Container(
                  height: 400,),
                                      Text("Version: 1.0.1", style: TextStyle(fontSize: 16.0,color: Colors.white),)
                                    ],
                                  ),
                        ) ,
    );
  }
}