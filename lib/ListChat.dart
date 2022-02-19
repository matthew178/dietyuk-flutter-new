import 'package:dietyukapp/chat.dart';
import 'package:dietyukapp/ClassChat.dart';
import 'package:dietyukapp/ClassUser.dart';

import 'ClassKategoriProduk.dart';
import 'DaftarProdukMember.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'session.dart' as session;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ListChat extends StatefulWidget {
  final String id;
  ListChat({Key key, @required this.id}) : super(key: key);
  @override
  ListChatState createState() => ListChatState(this.id);
}

class ListChatState extends State<ListChat> {
  String id;
  ListChatState(this.id);
  List<ClassChat> arrListChat = new List();
  void initState() {
    super.initState();
    getListChatUsername();
  }

  Future<List<ClassChat>> getListChatUsername() async {
    List<ClassChat> arrTemp = new List();
    Map paramData = {'username': this.id};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getListChat"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      var data = jsonDecode(res.body);
      data = data[0]['listchat'];
      for (int i = 0; i < data.length; i++) {
        ClassChat databaru = new ClassChat(
            data[i]['id'].toString(),
            data[i]['username2'].toString(),
            data[i]['username'].toString(),
            data[i]['nama'].toString(),
            data[i]['foto'].toString());
        arrTemp.add(databaru);
      }
      setState(() {
        arrListChat = arrTemp;
      });
    }).catchError((err) {
      print(err);
    });
    return arrTemp;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: ListView.builder(
            itemCount: arrListChat.length == 0 ? 1 : arrListChat.length,
            itemBuilder: (context, index) {
              if (arrListChat.length == 0) {
                return Image.asset("assets/images/nodata.png");
              } else {
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Chat(
                                  username1: session.userlogin.toString(),
                                  username2: arrListChat[index].idlawan,
                                  namalawan: arrListChat[index].namalawan)));
                    },
                    child: Card(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // color: Colors.red,
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: SizedBox(
                              height: 100,
                              width: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                    session.ipnumber +
                                        "/gambar/" +
                                        arrListChat[index].foto,
                                    fit: BoxFit.cover),
                              )),
                        ),
                        Container(
                          // color: Colors.green,
                          padding: EdgeInsets.fromLTRB(15, 50, 0, 0),
                          child: Text(
                            arrListChat[index].namalawan,
                            style: TextStyle(fontSize: 17),
                          ),
                        )
                      ],
                    )));
              }
            }));
  }
}
