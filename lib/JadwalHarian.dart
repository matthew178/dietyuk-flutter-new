import 'package:fluttertoast/fluttertoast.dart';

import 'ClassJadwalHarian.dart';
import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class JadwalHarian extends StatefulWidget {
  final String week;
  final String idbeli;
  final String hari;
  final int tipe;

  JadwalHarian(
      {Key key,
      @required this.week,
      @required this.idbeli,
      @required this.hari,
      @required this.tipe})
      : super(key: key);

  @override
  JadwalHarianState createState() =>
      JadwalHarianState(this.week, this.idbeli, this.hari, this.tipe);
}

class JadwalHarianState extends State<JadwalHarian> {
  String week, idbeli, hari;
  int tipe;
  DateTime tglnow = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  List<ClassJadwalHarian> pagi = new List();
  List<ClassJadwalHarian> siang = new List();
  List<ClassJadwalHarian> malam = new List();
  List<ClassJadwalHarian> olahraga = new List();
  List<ClassJadwalHarian> jadwal = new List();
  bool centang = true;
  JadwalHarianState(this.week, this.idbeli, this.hari, this.tipe);

  @override
  void initState() {
    super.initState();
    getJadwalHarian();
    print(tipe.toString() + " tipe" + hari.toString() + " hari");
  }

  void ubahStatus(String id, String status) {
    Map paramData = {'id': id, 'status': status};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/ubahStatusJadwal"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      // print("sini status = " + status + " id = " + id);
      // getJadwalHarian();
    }).catchError((err) {
      print(err);
    });
  }

  Future<List<ClassJadwalHarian>> getJadwalHarian() async {
    List<ClassJadwalHarian> tempData = new List();
    ClassJadwalHarian databaru = new ClassJadwalHarian("id", "idbeli",
        "tanggal", "hari", "waktu", "keterangan", "takaran", "status");
    Map paramData = {'id': idbeli, 'hari': hari};
    var parameter = json.encode(paramData);
    int week = 0;
    http
        .post(Uri.parse(session.ipnumber + "/getJadwalHarian"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['jadwal'];
      for (int i = 0; i < data.length; i++) {
        databaru = ClassJadwalHarian(
            data[i]['id'].toString(),
            data[i]['idbeli'].toString(),
            data[i]['tanggal'].toString(),
            data[i]['hari'].toString(),
            data[i]['waktu'].toString(),
            data[i]['keterangan'].toString(),
            data[i]['takaran'].toString(),
            data[i]['status'].toString());
        if (data[i]['waktu'] == "pagi") {
          pagi.add(databaru);
        } else if (data[i]['waktu'] == "siang") {
          siang.add(databaru);
        } else if (data[i]['waktu'] == "malam") {
          malam.add(databaru);
        } else {
          olahraga.add(databaru);
        }
        tempData.add(databaru);
      }
      setState(() => this.jadwal = tempData);
      return tempData;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Minggu " + week + " - Hari " + hari),
        backgroundColor: session.warna,
      ),
      body: ListView(
        children: [
          Container(
              child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(40, 15, 20, 5),
                // height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.yellow[200],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/breakfast.png",
                            width: 50,
                          ),
                          // Icon(Icons.wb_sunny, color: Colors.red),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          ),
                          Text(
                            'Makan Pagi',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              foreground: Paint()
                                ..color = Colors.black
                                ..strokeWidth = 1.3
                                ..style = PaintingStyle.stroke,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.black),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: SizedBox(
                                height: 150,
                                child: new ListView.builder(
                                    itemCount:
                                        pagi.length == 0 ? 1 : pagi.length,
                                    itemBuilder: (context, index) {
                                      if (pagi.length == 0) {
                                        return Card(
                                          child: Text("Data empty"),
                                        );
                                      } else {
                                        return tipe == 1
                                            ? new CheckboxListTile(
                                                value: pagi[index].getStatus(),
                                                activeColor: Colors.blue[600],
                                                title: Text(
                                                  pagi[index].takaran +
                                                      " " +
                                                      pagi[index].keterangan,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                onChanged: (bool value) {
                                                  if (DateTime.parse(pagi[index]
                                                              .tanggal)
                                                          .compareTo(tglnow) >
                                                      0) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Program belum dimulai");
                                                  } else {
                                                    if (pagi[index].status ==
                                                        "1") {
                                                      setState(() => pagi[index]
                                                          .status = "0");
                                                      ubahStatus(
                                                          pagi[index]
                                                              .id
                                                              .toString(),
                                                          "0");
                                                    } else {
                                                      setState(() => pagi[index]
                                                          .status = "1");
                                                      ubahStatus(
                                                          pagi[index]
                                                              .id
                                                              .toString(),
                                                          "1");
                                                    }
                                                  }
                                                })
                                            : new CheckboxListTile(
                                                value: pagi[index].getStatus(),
                                                activeColor: Colors.blue[600],
                                                title: Text(
                                                  pagi[index].takaran +
                                                      " " +
                                                      pagi[index].keterangan,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                onChanged: (bool value) {});
                                      }
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
          Container(
              child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(40, 15, 20, 5),
                // height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.yellow[200],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/lunch.png",
                            width: 50,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          ),
                          Text(
                            'Makan Siang',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              foreground: Paint()
                                ..color = Colors.black
                                ..strokeWidth = 1.3
                                ..style = PaintingStyle.stroke,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.black),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: SizedBox(
                                height: 150,
                                child: new ListView.builder(
                                    itemCount:
                                        siang.length == 0 ? 1 : siang.length,
                                    itemBuilder: (context, index) {
                                      if (siang.length == 0) {
                                        return Card(
                                          child: Text("Data empty"),
                                        );
                                      } else {
                                        return tipe == 1
                                            ? new CheckboxListTile(
                                                value: siang[index].getStatus(),
                                                activeColor: Colors.blue[600],
                                                title: Text(
                                                  siang[index].takaran +
                                                      " " +
                                                      siang[index].keterangan,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                onChanged: (bool value) {
                                                  if (DateTime.parse(
                                                              siang[index]
                                                                  .tanggal)
                                                          .compareTo(tglnow) >
                                                      0) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Program belum dimulai");
                                                  } else {
                                                    if (siang[index].status ==
                                                        "1") {
                                                      setState(() =>
                                                          siang[index].status =
                                                              "0");
                                                      ubahStatus(
                                                          siang[index]
                                                              .id
                                                              .toString(),
                                                          "0");
                                                    } else {
                                                      setState(() =>
                                                          siang[index].status =
                                                              "1");
                                                      ubahStatus(
                                                          siang[index]
                                                              .id
                                                              .toString(),
                                                          "1");
                                                    }
                                                  }
                                                })
                                            : new CheckboxListTile(
                                                value: siang[index].getStatus(),
                                                activeColor: Colors.blue[600],
                                                title: Text(
                                                  siang[index].takaran +
                                                      " " +
                                                      siang[index].keterangan,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                onChanged: (bool value) {});
                                      }
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
          Container(
              child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(40, 15, 20, 5),
                // height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.yellow[200],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/dinner.png",
                            width: 50,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          ),
                          Text(
                            'Makan Malam',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              foreground: Paint()
                                ..color = Colors.black
                                ..strokeWidth = 1.3
                                ..style = PaintingStyle.stroke,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.black),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: SizedBox(
                                height: 150,
                                child: new ListView.builder(
                                    itemCount:
                                        malam.length == 0 ? 1 : malam.length,
                                    itemBuilder: (context, index) {
                                      if (malam.length == 0) {
                                        return Card(
                                          child: Text("Data empty"),
                                        );
                                      } else {
                                        return tipe == 1
                                            ? new CheckboxListTile(
                                                value: malam[index].getStatus(),
                                                activeColor: Colors.blue[600],
                                                title: Text(
                                                  malam[index].takaran +
                                                      " " +
                                                      malam[index].keterangan,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                onChanged: (bool value) {
                                                  if (DateTime.parse(
                                                              malam[index]
                                                                  .tanggal)
                                                          .compareTo(tglnow) >
                                                      0) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Program belum dimulai");
                                                  } else {
                                                    if (malam[index].status ==
                                                        "1") {
                                                      setState(() =>
                                                          malam[index].status =
                                                              "0");
                                                      ubahStatus(
                                                          malam[index]
                                                              .id
                                                              .toString(),
                                                          "0");
                                                    } else {
                                                      setState(() =>
                                                          malam[index].status =
                                                              "1");
                                                      ubahStatus(
                                                          malam[index]
                                                              .id
                                                              .toString(),
                                                          "1");
                                                    }
                                                  }
                                                })
                                            : new CheckboxListTile(
                                                value: malam[index].getStatus(),
                                                activeColor: Colors.blue[600],
                                                title: Text(
                                                  malam[index].takaran +
                                                      " " +
                                                      malam[index].keterangan,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                onChanged: (bool value) {});
                                      }
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
          Container(
              child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(40, 15, 20, 5),
                // height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.yellow[200],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/gym.png",
                            width: 50,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          ),
                          Text(
                            'Olahraga',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              foreground: Paint()
                                ..color = Colors.black
                                ..strokeWidth = 1.3
                                ..style = PaintingStyle.stroke,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.black),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: SizedBox(
                                height: 150,
                                child: new ListView.builder(
                                    itemCount: olahraga.length == 0
                                        ? 1
                                        : olahraga.length,
                                    itemBuilder: (context, index) {
                                      if (olahraga.length == 0) {
                                        return Card(
                                          child: Text("Data empty"),
                                        );
                                      } else {
                                        return tipe == 1
                                            ? new CheckboxListTile(
                                                value:
                                                    olahraga[index].getStatus(),
                                                activeColor: Colors.blue[600],
                                                title: Text(
                                                  olahraga[index].takaran +
                                                      " " +
                                                      olahraga[index]
                                                          .keterangan,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                onChanged: (bool value) {
                                                  if (DateTime.parse(
                                                              olahraga[index]
                                                                  .tanggal)
                                                          .compareTo(tglnow) >
                                                      0) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Program belum dimulai");
                                                  } else {
                                                    if (olahraga[index]
                                                            .status ==
                                                        "1") {
                                                      setState(() =>
                                                          olahraga[index]
                                                              .status = "0");
                                                      ubahStatus(
                                                          olahraga[index]
                                                              .id
                                                              .toString(),
                                                          "0");
                                                    } else {
                                                      setState(() =>
                                                          olahraga[index]
                                                              .status = "1");
                                                      ubahStatus(
                                                          olahraga[index]
                                                              .id
                                                              .toString(),
                                                          "1");
                                                    }
                                                  }
                                                })
                                            : new CheckboxListTile(
                                                value:
                                                    olahraga[index].getStatus(),
                                                activeColor: Colors.blue[600],
                                                title: Text(
                                                  olahraga[index].takaran +
                                                      " " +
                                                      olahraga[index]
                                                          .keterangan,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                onChanged: (bool value) {});
                                      }
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
