import 'ClassKategoriProduk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'session.dart' as session;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<ClassKategoriProduk> arrKategori = new List();

  void initState() {
    super.initState();
    getKategori();
  }

  Future<List<ClassKategoriProduk>> getKategori() async {
    List<ClassKategoriProduk> tempKategori = new List();
    Map paramData = {};
    var parameter = json.encode(paramData);
    ClassKategoriProduk databaru =
        new ClassKategoriProduk("id", "id_paket", "gambar", "icon");
    http
        .post(Uri.parse(session.ipnumber + "/getkategori"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      var data = json.decode(res.body);
      data = data[0]['kategori'];
      for (int i = 0; i < data.length; i++) {
        databaru = ClassKategoriProduk(
            data[i]['kodekategori'].toString(),
            data[i]['namakategori'].toString(),
            data[i]['gambar'].toString(),
            data[i]['icon'].toString());
        tempKategori.add(databaru);
      }
      setState(() => this.arrKategori = tempKategori);
      print("selesai");
      return tempKategori;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: Drawer(),
        appBar: AppBar(),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  "Pilih salah satu",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: arrKategori.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return Container(
                    margin: EdgeInsets.all(20),
                    height: 200,
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            session.ipnumber +
                                "/gambar/" +
                                arrKategori[index].gambar,
                            fit: BoxFit.cover,
                          ),
                        )),
                        Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 170,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.7),
                                        Colors.transparent
                                      ])),
                            )),
                        Positioned(
                          bottom: 0,
                          child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(children: [
                                ClipOval(
                                  child: Container(
                                    child: Image.network(
                                      session.ipnumber +
                                          "/gambar/" +
                                          arrKategori[index].icon,
                                      height: 75,
                                      width: 75,
                                    ),
                                    padding: EdgeInsets.all(10),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  arrKategori[index].namakategori,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                )
                              ])),
                        )
                      ],
                    ),
                  );
                },
              ))
            ],
          ),
        ));
  }
}
