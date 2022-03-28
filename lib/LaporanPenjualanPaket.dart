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

class LaporanPaket extends StatefulWidget {
  @override
  LaporanPaketState createState() => LaporanPaketState();
}

class LaporanPaketState extends State<LaporanPaket> {
  List<ClassPaket> arrPaket = new List();
  List<ClassLaporanPaket> arrLaporan = new List();
  List<ClassLaporanPaket> arrDetail = new List();
  List<ClassLaporanPaket> arrPaketFav = new List();
  List<ClassLaporanPaket> arrPaketBest = new List();
  int ada = 0;
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
    _seriesPieData = List<charts.Series<ClassLaporanPaket, String>>();
    arrLaporan.add(new ClassLaporanPaket("paket 1", 0, Colors.green));
    _seriesPieData.add(charts.Series(
      data: arrLaporan,
      domainFn: (ClassLaporanPaket task, _) => task.nama_paket,
      measureFn: (ClassLaporanPaket task, _) => task.jumlahlaporan,
      colorFn: (ClassLaporanPaket task, _) =>
          charts.ColorUtil.fromDartColor(task.warna),
      id: 'Daily Task',
      labelAccessorFn: (ClassLaporanPaket row, _) => '${row.jumlahlaporan}',
    ));
    getPaket();
  }

  List<charts.Series<ClassLaporanPaket, String>> _seriesPieData;

  Future<List<ClassPaket>> getPaket() async {
    this.arrLaporan.clear();
    List<ClassPaket> arrPaket = new List();
    Map paramData = {'konsultan': session.userlogin};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getLaporanPaket"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      var data1 = data[0]['datalaporan'];
      var data2 = data[0]['rating'];
      var data3 = data[0]['fav'];
      data = data[0]['laporan'];
      final _random = Random();
      if (data1 == "tidak ada data") {
        for (int i = 0; i < data.length; i++) {
          Color warna = Color.fromARGB(255, _random.nextInt(256),
              _random.nextInt(256), _random.nextInt(256));
          ClassLaporanPaket laporpaket =
              new ClassLaporanPaket(data[i]['nama_paket'].toString(), 0, warna);
          arrLaporan.add(laporpaket);
        }
      } else {
        ada = 1;
        for (int i = 0; i < data.length; i++) {
          Color warna = Color.fromARGB(255, _random.nextInt(256),
              _random.nextInt(256), _random.nextInt(256));
          var ketemu = 0;
          for (int j = 0; j < data1.length; j++) {
            if (data[i]['id_paket'].toString() ==
                data1[j]['id_paket'].toString()) {
              ketemu++;
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

              ClassLaporanPaket laporpaket = new ClassLaporanPaket(
                  data[i]['nama_paket'].toString(),
                  double.parse(data1[j]['jumlah'].toString()),
                  warna);
              setState(() {
                arrLaporan.add(laporpaket);
                arrDetail.add(laporpaket);
              });
              arrPaket.add(databaru);
            }
          }
          if (ketemu == 0) {
            ClassLaporanPaket laporpaket = new ClassLaporanPaket(
                data[i]['nama_paket'].toString(), 0, warna);
            arrLaporan.add(laporpaket);
            arrDetail.add(laporpaket);
          }
        }
      }
      if (data2.length > 0) {
        if (data2.length <= 5) {
          for (int j = 0; j < data2.length; j++) {
            for (int i = 0; i < data.length; i++) {
              if (data[i]['id_paket'].toString() ==
                  data2[j]['id_paket'].toString()) {
                setState(() {
                  arrPaketBest.add(new ClassLaporanPaket(
                      data[i]['nama_paket'].toString(),
                      double.parse(data2[j]['rating'].toString()),
                      Colors.green));
                });
              }
            }
          }
        } else {
          for (int j = 0; j < 5; j++) {
            for (int i = 0; i < data.length; i++) {
              if (data[i]['id_paket'].toString() ==
                  data2[j]['id_paket'].toString()) {
                setState(() {
                  arrPaketBest.add(new ClassLaporanPaket(
                      data[i]['nama_paket'].toString(),
                      double.parse(data2[j]['rating'].toString()),
                      Colors.green));
                });
              }
            }
          }
        }
      }
      if (data3.length > 0) {
        if (data3.length <= 5) {
          for (int j = 0; j < data3.length; j++) {
            for (int i = 0; i < data.length; i++) {
              if (data[i]['id_paket'].toString() ==
                  data3[j]['id_paket'].toString()) {
                setState(() {
                  arrPaketFav.add(new ClassLaporanPaket(
                      data[i]['nama_paket'].toString(),
                      double.parse(data3[j]['jumlah'].toString()),
                      Colors.green));
                });
              }
            }
          }
        } else {
          for (int j = 0; j < 5; j++) {
            for (int i = 0; i < data.length; i++) {
              if (data[i]['id_paket'].toString() ==
                  data3[j]['id_paket'].toString()) {
                setState(() {
                  arrPaketFav.add(new ClassLaporanPaket(
                      data[i]['nama_paket'].toString(),
                      double.parse(data3[j]['jumlah'].toString()),
                      Colors.green));
                });
              }
            }
          }
        }
      }
      setState(() => this.arrPaket = arrPaket);
      getDetailLaporan();

      return arrPaket;
    }).catchError((err) {
      print(err);
    });
  }

  Future<List<ClassPaket>> getDetailLaporan() async {
    this.arrDetail.clear();
    List<ClassPaket> arrPaket = new List();
    Map paramData = {
      'konsultan': session.userlogin,
      "bulan": bulan,
      "tahun": tahun
    };
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getDetailLaporan"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      var data1 = data[0]['datalaporan'];
      data = data[0]['laporan'];
      final _random = Random();
      for (int i = 0; i < data.length; i++) {
        for (int j = 0; j < data1.length; j++) {
          Color warna = Color.fromARGB(255, _random.nextInt(256),
              _random.nextInt(256), _random.nextInt(256));
          if (data[i]['id_paket'].toString() ==
              data1[j]['id_paket'].toString()) {
            ClassLaporanPaket laporpaket = new ClassLaporanPaket(
                data[i]['nama_paket'].toString(),
                double.parse(data1[j]['jumlah'].toString()),
                warna);
            setState(() {
              arrDetail.add(laporpaket);
            });
          }
        }
      }
      return arrPaket;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text("Laporan Paket"),
                bottom: TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.list)),
                    Tab(icon: Icon(Icons.favorite))
                  ],
                ),
              ),
              body: TabBarView(children: [
                ListView(children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      child: Center(
                        child: Column(children: [
                          Text("Laporan Penjualan Paket",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          ada > 0
                              ? SizedBox(
                                  height: size.height / 3,
                                  child: charts.PieChart(_seriesPieData,
                                      animate: true,
                                      animationDuration: Duration(seconds: 2),
                                      behaviors: [
                                        new charts.DatumLegend(
                                          outsideJustification: charts
                                              .OutsideJustification.endDrawArea,
                                          horizontalFirst: false,
                                          desiredMaxRows: 2,
                                          cellPadding: new EdgeInsets.only(
                                              right: 4.0, bottom: 4.0),
                                          entryTextStyle: charts.TextStyleSpec(
                                              fontFamily: 'Georgia',
                                              fontSize: 11),
                                        )
                                      ],
                                      defaultRenderer:
                                          new charts.ArcRendererConfig(
                                              arcWidth: 100,
                                              arcRendererDecorators: [
                                            new charts.ArcLabelDecorator(
                                                labelPosition: charts
                                                    .ArcLabelPosition.inside)
                                          ])))
                              : SizedBox(
                                  height: size.height / 3,
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0, size.height / 6, 0, 0),
                                      child: Text(
                                        "Belum Ada Data Penjualan",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ))),
                          SizedBox(height: size.height * 0.01),
                          DataTable(
                              columns: [
                                DataColumn(label: Text("No.")),
                                DataColumn(label: Text("Nama Paket")),
                                DataColumn(label: Text('Jumlah Penjualan'))
                              ],
                              rows: List<DataRow>.generate(
                                  arrLaporan.length,
                                  (index) => DataRow(cells: <DataCell>[
                                        DataCell(
                                            Text((index + 1).toString() + ".")),
                                        DataCell(Container(
                                            child: Text(
                                                arrLaporan[index].nama_paket),
                                            width: size.width / 4.5)),
                                        DataCell(Text(arrLaporan[index]
                                            .jumlahlaporan
                                            .toString()))
                                      ]))),
                          SizedBox(height: size.height * 0.05),
                          SizedBox(
                              child: Text("Detail Penjualan",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18))),
                          SizedBox(height: size.height * 0.01),
                          Container(
                              height: size.height * 0.1,
                              margin:
                                  EdgeInsets.fromLTRB(size.width / 5, 0, 0, 0),
                              child: Row(
                                children: [
                                  DropdownButton<String>(
                                    hint: Text("--Pilih Bulan--"),
                                    value: bulan,
                                    onChanged: (String value) {
                                      setState(() {
                                        bulan = value;
                                        getDetailLaporan();
                                      });
                                    },
                                    items: arrMonth.map((String bulan) {
                                      return DropdownMenuItem<String>(
                                        value: bulan,
                                        child: Row(
                                          children: <Widget>[Text(bulan)],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(width: 10),
                                  DropdownButton<String>(
                                    hint: Text("--Pilih Tahun--"),
                                    value: tahun,
                                    onChanged: (String value) {
                                      setState(() {
                                        tahun = value;
                                        getDetailLaporan();
                                      });
                                    },
                                    items: arrTahun.map((String tahun) {
                                      return DropdownMenuItem<String>(
                                        value: tahun,
                                        child: Row(
                                          children: <Widget>[Text(tahun)],
                                        ),
                                      );
                                    }).toList(),
                                  )
                                ],
                              )),
                          SizedBox(height: 1),
                          arrDetail.length > 0
                              ? DataTable(
                                  columns: [
                                      DataColumn(label: Text("No.")),
                                      DataColumn(label: Text("Nama Paket")),
                                      DataColumn(
                                          label: Text('Jumlah Penjualan'))
                                    ],
                                  rows: List<DataRow>.generate(
                                      arrDetail.length,
                                      (index) => DataRow(cells: <DataCell>[
                                            DataCell(Text(
                                                (index + 1).toString() + ".")),
                                            DataCell(Container(
                                                child: Text(arrDetail[index]
                                                    .nama_paket),
                                                width: size.width / 4.5)),
                                            DataCell(Text(arrDetail[index]
                                                .jumlahlaporan
                                                .toString()))
                                          ])))
                              : SizedBox(
                                  height: size.height / 3,
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0, size.height / 6, 0, 0),
                                      child: Text("Belum Ada Data Penjualan",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)))),
                          SizedBox(height: 100),
                          Text("")
                        ]),
                      ),
                    ),
                  ),
                ]),
                ListView(children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      child: Center(
                        child: Column(children: [
                          SizedBox(height: size.height * 0.05),
                          Text("Paket Terfavorite",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(height: size.height * 0.01),
                          arrPaketFav.length > 0
                              ? DataTable(
                                  columns: [
                                      DataColumn(label: Text("No.")),
                                      DataColumn(label: Text("Nama Paket")),
                                      DataColumn(
                                          label: Text('Jumlah Penjualan'))
                                    ],
                                  rows: List<DataRow>.generate(
                                      arrPaketFav.length,
                                      (index) => DataRow(cells: <DataCell>[
                                            DataCell(Text(
                                                (index + 1).toString() + ".")),
                                            DataCell(Container(
                                                child: Text(arrPaketFav[index]
                                                    .nama_paket),
                                                width: size.width / 4.5)),
                                            DataCell(Row(
                                              children: [
                                                Text(arrPaketFav[index]
                                                    .jumlahlaporan
                                                    .toString())
                                              ],
                                            ))
                                          ])))
                              : Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text("Belum Ada Data",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15))),
                          SizedBox(height: size.height * 0.05),
                          Text("")
                        ]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      child: Center(
                        child: Column(children: [
                          Text("Best Rating Paket",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(height: size.height * 0.01),
                          arrPaketBest.length > 0
                              ? DataTable(
                                  columns: [
                                      DataColumn(label: Text("No.")),
                                      DataColumn(label: Text("Nama Paket")),
                                      DataColumn(label: Text('Rating Paket'))
                                    ],
                                  rows: List<DataRow>.generate(
                                      arrPaketBest.length,
                                      (index) => DataRow(cells: <DataCell>[
                                            DataCell(Text(
                                                (index + 1).toString() + ".")),
                                            DataCell(Container(
                                                child: Text(arrPaketBest[index]
                                                    .nama_paket),
                                                width: size.width / 4.5)),
                                            DataCell(Row(
                                              children: [
                                                Text(arrPaketBest[index]
                                                    .jumlahlaporan
                                                    .toString()),
                                                SizedBox(width: 5),
                                                Icon(Icons.star,
                                                    color: Colors.yellow[700])
                                              ],
                                            ))
                                          ])))
                              : Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text("Belum Ada Data",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                ),
                          SizedBox(height: size.height * 0.05),
                          Text("")
                        ]),
                      ),
                    ),
                  ),
                ])
              ]),
            )));
  }
}
