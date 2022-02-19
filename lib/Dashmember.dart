import 'package:dietyukapp/chat.dart';
import 'package:dietyukapp/ListChat.dart';
import 'DaftarTransaksiMember.dart';
import 'HomepageMember.dart';
import 'package:flutter/material.dart';
import 'session.dart' as session;
import 'MyProfile.dart';

class Dashmember extends StatefulWidget {
  @override
  DashmemberState createState() => DashmemberState();
}

class DashmemberState extends State<Dashmember> {
  int index = 0;

  final bottomBar = [
    HomePageMember(),
    ListChat(id: session.userlogin.toString()),
    Myprofile()
  ]; //harusnya homepage, chat, profile

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
          BottomNavigationBarItem(
              icon: Icon(Icons.chat), title: Text("Kotak Masuk")),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_pin_outlined), title: Text("My Profile"))
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: _onTapItem,
      ),
    );
  }
}
