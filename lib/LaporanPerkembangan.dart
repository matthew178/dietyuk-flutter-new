import 'dart:ui';
import 'dart:math';
import 'package:dietyukapp/ClassLaporanPaket.dart';
import 'package:dietyukapp/ClassPaket.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'session.dart' as session;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:syncfusion_flutter_charts/charts.dart';

class LaporanPerkembangan extends StatefulWidget {
  @override
  LaporanPerkembanganState createState() => LaporanPerkembanganState();
}

class LaporanPerkembanganState extends State<LaporanPerkembangan> {
  List<charts.Series<classLaporanPerkembangan, DateTime>> arrLaporan;
  List<classLaporanPerkembangan> arrTemp = new List();
  String bulan = null, tahun = null;
  List<String> arrTahun = ['2020', '2021', '2022', '2023', '2024', '2025'];
  List<String> arrMonth = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    bulan = arrMonth[now.month - 1];
    tahun = arrTahun[2];
    getChartData();
    // arrTemp.add(new classLaporanPerkembangan(
    //     new DateTime(2022, 3, 25), 85, "keterangan", "1"));
    // arrTemp.add(new classLaporanPerkembangan(
    //     new DateTime(2022, 3, 27), 105, "keterangan", "1"));
    arrLaporan = [
      new charts.Series<classLaporanPerkembangan, DateTime>(
        id: 'Laporan Perkembangan',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (classLaporanPerkembangan sales, _) => sales.tanggal,
        measureFn: (classLaporanPerkembangan sales, _) => sales.berat,
        data: arrTemp,
      )
    ];
    // setState(() {
    //   arrTemp = session.arrLaporan;
    //   print(arrTemp.length.toString() + " data");
    // });
  }

  Future<List<charts.Series<classLaporanPerkembangan, DateTime>>>
      getChartData() async {
    this.arrTemp.clear();
    Map paramData = {'user': session.userlogin};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getHistoryBerat"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      var bb = data[0]['databeratbadan'];
      for (int i = 0; i < bb.length; i++) {
        var split = bb[i]['tanggal'].toString().split('-');
        setState(() {
          arrTemp.add(new classLaporanPerkembangan(
              new DateTime(
                  int.parse(split[0].toString()),
                  int.parse(split[1].toString()),
                  int.parse(split[2].toString())),
              double.parse(bb[i]['berat'].toString()),
              bb[i]['keterangan'].toString(),
              bb[i]['status'].toString()));
        });
      }
      arrTemp.sort((a, b) => a.tanggal.compareTo(b.tanggal));
      print("data : " + arrTemp.length.toString());
      setState(() {});
    }).catchError((err) {
      print(err);
    });
  }

  // Future<List<charts.Series<classLaporanPerkembangan, DateTime>>>
  //     getChartData() async {
  //   this.arrTemp.clear();
  //   Map paramData = {'user': session.userlogin};
  //   var parameter = json.encode(paramData);
  //   http
  //       .post(Uri.parse(session.ipnumber + "/getHistoryBerat"),
  //           headers: {"Content-Type": "application/json"}, body: parameter)
  //       .then((res) {
  //     var data = json.decode(res.body);
  //     var bb = data[0]['databeratbadan'];
  //     for (int i = 0; i < bb.length; i++) {
  //       var split = bb[i]['tanggal'].toString().split('-');
  //       arrTemp.add(new classLaporanPerkembangan(new DateTime(2022, 3, 25),
  //           double.parse(bb[i]['berat'].toString()), "keterangan", "1"));
  //     }
  //     arrTemp.sort((a, b) => a.tanggal.compareTo(b.tanggal));
  //     setState(() => this.arrTemp = arrTemp);
  //   }).catchError((err) {
  //     print(err);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          // Center(
          //   child: Padding(
          //       child: Text("Laporan Perkembangan",
          //           style:
          //               TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          //       padding: EdgeInsets.only(top: 20)),
          // ),
          // SizedBox(height: size.height / 10),
          // SizedBox(
          //   height: size.height / 3,
          //   width: size.width,
          //   child: ListView(scrollDirection: Axis.horizontal, children: [
          //     SizedBox(
          //         height: size.height / 2,
          //         width: size.width,
          //         child: charts.TimeSeriesChart(arrLaporan,
          //             animate: true,
          //             dateTimeFactory: const charts.LocalDateTimeFactory()))
          //   ]),
          // ),
          // SizedBox(height: 25),
          Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(243, 245, 248, 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "History Berat Badan",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                            color: Colors.black),
                      )
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 32),
                ),
                SizedBox(height: 24),
                Container(
                    height: size.height - 125,
                    child: ListView.builder(
                        itemCount: arrTemp.length == 0 ? 1 : arrTemp.length,
                        itemBuilder: (context, index) {
                          if (arrTemp.length == 0) {
                            return Card(
                                child: Text("Tidak Ada Data Berat Badan"));
                          } else {
                            return Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 0, 10, 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      height: size.height - 525,
                                      width: size.width,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 5, 0, 0),
                                            width: MediaQuery.of(this.context)
                                                .size
                                                .width,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(left: 15),
                                                  width: 280,
                                                  height: 20,
                                                  child: Text(
                                                    arrTemp[index]
                                                        .tanggal
                                                        .toString()
                                                        .substring(0, 10),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                        letterSpacing: 1,
                                                        decoration:
                                                            TextDecoration.none,
                                                        color:
                                                            Colors.grey[600]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.grey,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 25, top: 10),
                                            height: 75,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          width: 110,
                                                          child: Text(
                                                              arrTemp[index]
                                                                  .berat
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 50,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                      Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 30),
                                                          width: 50,
                                                          child: Text("kg",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18))),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: arrTemp[index].status ==
                                                          "1"
                                                      ? Container(
                                                          padding: EdgeInsets.only(
                                                              top: 10),
                                                          child: Icon(Icons.arrow_downward,
                                                              color:
                                                                  Colors.green,
                                                              size: 50))
                                                      : arrTemp[index].status ==
                                                              "2"
                                                          ? Container(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                      top: 10),
                                                              child: Icon(
                                                                  Icons
                                                                      .arrow_upward,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 50))
                                                          : Container(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                      top: 10),
                                                              child: Image.asset(
                                                                'assets/images/equals.png',
                                                                height: size
                                                                        .height /
                                                                    (size.height /
                                                                        50),
                                                                width: size
                                                                        .width /
                                                                    (size.width /
                                                                        50),
                                                              )),
                                                )
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.grey,
                                          ),
                                          Row(
                                            children: [
                                              // Container(
                                              //   margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                                              //   child: Text(
                                              //     'Keterangan : ',
                                              //     style: TextStyle(
                                              //       fontSize: 14,
                                              //       fontWeight: FontWeight.bold,
                                              //       color: Colors.black,
                                              //       decoration: TextDecoration.none,
                                              //     ),
                                              //   ),
                                              // ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    20, 5, 0, 0),
                                                child: Text(
                                                  arrTemp[index].keterangan,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            );
                          }
                        }))
              ],
            ),
          ),
          SizedBox(height: 25)
        ],
      ),
    ));
  }
}

class classLaporanPerkembangan {
  final DateTime tanggal;
  final double berat;
  final String keterangan;
  final String status;
  classLaporanPerkembangan(
      this.tanggal, this.berat, this.keterangan, this.status);

  classLaporanPerkembangan.fromJson(Map<String, dynamic> json)
      : tanggal = DateTime.parse(json['tanggal'].toString()),
        berat = double.parse(json['berat'].toString()),
        keterangan = json['keterangan'],
        status = json['status'];

  Map toJson() => {
        'tanggal': tanggal,
        'berat': berat,
        'keterangan': keterangan,
        'status': status
      };
}
