import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notifyapp/notficatinservices.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Notificationservices noti=Notificationservices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noti.requestnotificationpermission();
    noti.firebaseinit();
    noti.getDeviceToken().then((value){
      print(value);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () => throw Exception(),
          child: const Text("Throw Test Exception"),
        ),
      ),
    );
  }
}
