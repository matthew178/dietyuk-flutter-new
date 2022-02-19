import 'package:dietyukapp/HomeKonsultan.dart';
import 'package:dietyukapp/ListChat.dart';
import 'PilihOrder.dart';
import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'DaftarPaketKonsultan.dart';
import 'MyProfile.dart';
import 'DaftarProduk.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class Dashkonsultan extends StatefulWidget {
  @override
  DashkonsultanState createState() => DashkonsultanState();
}

class DashkonsultanState extends State<Dashkonsultan> {
  int index = 0;

  final bottomBar = [
    Homekonsultan(),
    ListChat(id: session.userlogin.toString()),
    Myprofile()
  ];

  void _onTapItem(int idx) {
    setState(() {
      index = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bottomBar.elementAt(index),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(icon: Icon(Icons.email), title: Text("Chat")),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_pin_outlined), title: Text("Profile"))
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: _onTapItem,
      ),
    );
  }
}
