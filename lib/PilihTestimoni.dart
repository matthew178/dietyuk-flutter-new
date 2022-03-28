import 'package:dietyukapp/ClassTestimoni.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'ClassJenisPaket.dart';

class PilihTestimoni extends StatefulWidget {
  final String id;

  PilihTestimoni({Key key, @required this.id}) : super(key: key);

  @override
  PilihTestimoniState createState() => PilihTestimoniState(this.id);
}

class PilihTestimoniState extends State<PilihTestimoni> {
  String id;
  List<classTestimoni> arrTesti = new List();
  PilihTestimoniState(this.id);

  @override
  void initState() {
    super.initState();
    getTesti();
  }

  Widget cetakbintang(x, y) {
    if (x <= y) {
      return Image.asset("assets/images/bfull.png",
          width: 15, height: 15, fit: BoxFit.cover);
    } else if (x > y && x < y + 1) {
      return Image.asset("assets/images/bstengah.png",
          width: 15, height: 15, fit: BoxFit.cover);
    } else {
      return Image.asset("assets/images/bkosong.png",
          width: 15, height: 15, fit: BoxFit.cover);
    }
  }

  Future<List<classTestimoni>> getTesti() async {
    List<classTestimoni> arrTemp = new List();
    Map paramData = {'id': this.id};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getreviewpaket"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      var data = json.decode(res.body);
      data = data[0]['review'];

      for (int i = 0; i < data.length; i++) {
        classTestimoni review = new classTestimoni(
            data[i]['id'].toString(),
            data[i]['username'].toString(),
            data[i]['review_paket'].toString(),
            double.parse(data[i]['ratingpaket'].toString()),
            data[i]['testimoni'].toString());
        arrTemp.add(review);
      }
      setState(() {
        arrTesti = arrTemp;
      });
      print(arrTesti.length.toString() + " data");
    }).catchError((err) {
      print(err);
    });
  }

  void ubahStatus(String id, String status) {
    Map paramData = {'id': id, 'status': status};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/ubahStatusTestimoni"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {})
        .catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: session.warna,
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              "Pilih Testimoni Paket",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white),
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: SizedBox(
                    height: size.height - 125,
                    width: size.width,
                    child: new ListView.builder(
                        itemCount: arrTesti.length == 0 ? 1 : arrTesti.length,
                        itemBuilder: (context, index) {
                          if (arrTesti.length == 0) {
                            return Container(
                                padding: EdgeInsets.fromLTRB(
                                    size.width / 4, size.height / 3, 0, 0),
                                child: Text(
                                  "Belum Ada Review Paket",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ));
                          } else {
                            return Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 10, 10, 0),
                                      child: Text(arrTesti[index].username)),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        cetakbintang(1, arrTesti[index].rating),
                                        cetakbintang(2, arrTesti[index].rating),
                                        cetakbintang(3, arrTesti[index].rating),
                                        cetakbintang(4, arrTesti[index].rating),
                                        cetakbintang(5, arrTesti[index].rating)
                                      ],
                                    ),
                                  ),
                                  CheckboxListTile(
                                      value: arrTesti[index].getStatus(),
                                      activeColor: Colors.blue[600],
                                      title: Text(
                                        arrTesti[index].review,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      onChanged: (bool value) {
                                        if (arrTesti[index].status == "1") {
                                          setState(() =>
                                              arrTesti[index].status = "0");
                                          ubahStatus(
                                              arrTesti[index].id.toString(),
                                              "0");
                                        } else {
                                          setState(() =>
                                              arrTesti[index].status = "1");
                                          ubahStatus(
                                              arrTesti[index].id.toString(),
                                              "1");
                                        }
                                      }),
                                  Divider(
                                    color: Colors.black,
                                    height: 10,
                                  )
                                ],
                              ),
                            );
                          }
                        }),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
