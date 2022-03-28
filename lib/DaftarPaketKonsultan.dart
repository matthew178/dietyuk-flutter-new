import 'package:dietyukapp/PilihTestimoni.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'ClassPaket.dart';
import 'DetailPaket.dart';
import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'ClassPaket.dart';
import 'DetailPaketKonsultan.dart';
import 'EditJadwalPaket.dart';

class Daftarpaketkonsultan extends StatefulWidget {
  @override
  DaftarpaketkonsultanState createState() => DaftarpaketkonsultanState();
}

class DaftarpaketkonsultanState extends State<Daftarpaketkonsultan> {
  NumberFormat frmt = new NumberFormat(",000");
  List<ClassPaket> arrPaket = new List();
  String search = "";
  @override
  void initState() {
    super.initState();
    getPaket();
  }

  Future<List<ClassPaket>> getPaket() async {
    List<ClassPaket> arrPaket = new List();
    Map paramData = {'id': session.userlogin};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getpaketkonsultan"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      print(data);
      data = data[0]['paket'];
      for (int i = 0; i < data.length; i++) {
        ClassPaket databaru = ClassPaket(
            data[i]['id_paket'].toString(),
            data[i]['estimasiturun'].toString(),
            data[i]['harga'].toString(),
            data[i]['durasi'].toString(),
            data[i]['status'].toString(),
            data[i]['rating'].toString(),
            data[i]['nama'].toString(),
            data[i]['nama_paket'].toString(),
            data[i]['deskripsi'].toString(),
            data[i]['gambar'].toString());
        arrPaket.add(databaru);
      }
      setState(() => this.arrPaket = arrPaket);
      print(arrPaket.length);
      return arrPaket;
    }).catchError((err) {
      print(err);
    });
  }

  Future<List<ClassPaket>> onOffPaket(String id) async {
    print(id + " ini id paket");
    List<ClassPaket> arrPaket = new List();
    Map paramData = {'paket': id, 'id': session.userlogin};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/onOffPaket"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print("sampe sini aja ya");
      var data = json.decode(res.body);
      print(data);
      data = data[0]['paket'];
      for (int i = 0; i < data.length; i++) {
        ClassPaket databaru = ClassPaket(
            data[i]['id_paket'].toString(),
            data[i]['estimasiturun'].toString(),
            data[i]['harga'].toString(),
            data[i]['durasi'].toString(),
            data[i]['status'].toString(),
            data[i]['rating'].toString(),
            data[i]['nama'].toString(),
            data[i]['nama_paket'].toString(),
            data[i]['deskripsi'].toString(),
            data[i]['gambar'].toString());
        arrPaket.add(databaru);
      }
      setState(() => this.arrPaket = arrPaket);
      print(arrPaket.length);
      return arrPaket;
    }).catchError((err) {
      print(err);
    });
  }

  Future<List<ClassPaket>> searchPaket(String cari) async {
    List<ClassPaket> arrPaket = new List();
    Map paramData = {'cari': cari, 'konsultan': session.userlogin};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/searchPaketKonsultan"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      print(data);
      data = data[0]['paket'];
      for (int i = 0; i < data.length; i++) {
        ClassPaket databaru = ClassPaket(
            data[i]['id_paket'].toString(),
            data[i]['estimasiturun'].toString(),
            data[i]['harga'].toString(),
            data[i]['durasi'].toString(),
            data[i]['status'].toString(),
            data[i]['rating'].toString(),
            data[i]['nama'].toString(),
            data[i]['nama_paket'].toString(),
            data[i]['deskripsi'].toString(),
            data[i]['gambar'].toString());
        arrPaket.add(databaru);
      }
      setState(() => this.arrPaket = arrPaket);
      print(arrPaket.length);
      return arrPaket;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: session.warna,
      // appBar: AppBar(
      //   title: Text("Daftar Paket Page"),
      // ),
      body: Column(
        children: [
          SizedBox(
              height: 100,
              child: Padding(
                padding: EdgeInsets.only(left: 25, right: 25, top: 50),
                child: TextField(
                  onSubmitted: (String str) {
                    setState(() {
                      search = str;
                    });
                    searchPaket(search);
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[300]),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[200]),
                      ),
                      contentPadding: EdgeInsets.all(15),
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintText: 'Cari Paket',
                      hintStyle: TextStyle(
                          // fontFamily: "Roboto",
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                          fontSize: 18),
                      prefixIcon:
                          Icon(Icons.search, size: 30, color: Colors.black)),
                ),
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height - 100,
            child: new ListView.builder(
                itemCount: arrPaket.length == 0 ? 1 : arrPaket.length,
                itemBuilder: (context, index) {
                  if (arrPaket.length == 0) {
                    return Card(
                      child: Text("Data empty"),
                    );
                  } else {
                    return GestureDetector(
                        onTap: () {},
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.amber[50],
                            elevation: 4,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    top: 20.0, left: 20.0, right: 20.0),
                                child: Column(
                                  children: [
                                    Row(children: [
                                      Image.asset(
                                        "assets/images/logo.png",
                                        height: size.height / 6.84,
                                        width: size.width / 4.12,
                                      ),
                                      SizedBox(width: 20.0),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              child: Text(
                                                arrPaket[index].nama,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Container(
                                              child: Text(
                                                  arrPaket[index].durasi +
                                                      " hari",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red))),
                                          Container(
                                              child: Text(
                                                  "Rp. " +
                                                      frmt.format(int.parse(
                                                          arrPaket[index]
                                                              .harga
                                                              .toString())),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                          Container(
                                            child: arrPaket[index].status ==
                                                    0.toString()
                                                ? Text("Status : Tidak Aktif",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey))
                                                : arrPaket[index].status ==
                                                        1.toString()
                                                    ? Text("Status : Aktif",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.green))
                                                    : arrPaket[index].status ==
                                                            2.toString()
                                                        ? Text("Status : Diblokir Admin",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.red))
                                                        : Text(
                                                            "Status : Belum Siap",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                                color: Colors.grey[700])),
                                          ),
                                          Container(
                                              child: arrPaket[index].status ==
                                                          2.toString() ||
                                                      arrPaket[index].status ==
                                                          0.toString()
                                                  ? Container(
                                                      child: RaisedButton(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2),
                                                        ),
                                                        onPressed: () {
                                                          arrPaket[index]
                                                                      .status ==
                                                                  2.toString()
                                                              ? Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "Paket Diet Di Blokir Admin")
                                                              : onOffPaket(
                                                                  arrPaket[
                                                                          index]
                                                                      .id);
                                                        },
                                                        color: Colors
                                                            .lightBlueAccent,
                                                        child: Text(
                                                          'AKTIFKAN PAKET',
                                                          style: TextStyle(
                                                              fontSize: 15.0,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    )
                                                  : arrPaket[index].status ==
                                                          1.toString()
                                                      ? Container(
                                                          child: RaisedButton(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2),
                                                            ),
                                                            onPressed: () {
                                                              onOffPaket(
                                                                  arrPaket[
                                                                          index]
                                                                      .id);
                                                            },
                                                            color: Colors
                                                                .lightBlueAccent,
                                                            child: Text(
                                                              'OFF',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      15.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        )
                                                      : SizedBox())
                                        ],
                                      )
                                    ]),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetailPaketKonsultan(
                                                                  id: arrPaket[
                                                                          index]
                                                                      .id)));
                                                },
                                                color: Colors.lightBlueAccent,
                                                child: Text(
                                                  'Edit Info Paket',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              child: RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditJadwalPaket(
                                                                  id: arrPaket[
                                                                          index]
                                                                      .id))).then(
                                                      (value) => getPaket());
                                                },
                                                color: Colors.lightBlueAccent,
                                                child: Text(
                                                  'Edit Jadwal Paket',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                        child: Container(
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PilihTestimoni(
                                                          id: arrPaket[index]
                                                              .id)));
                                        },
                                        color: Colors.lightBlueAccent,
                                        child: Text(
                                          'Pilih Testimoni',
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ))
                                  ],
                                ))));
                  }
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/tambahpaket");
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue.shade200,
      ),
    );
  }
}
