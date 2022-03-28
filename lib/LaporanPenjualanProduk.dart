import 'dart:ui';
import 'dart:math';
import 'package:dietyukapp/ClassLaporanPaket.dart';
import 'package:dietyukapp/ClassLaporanProduk.dart';
import 'package:dietyukapp/ClassPaket.dart';
import 'package:dietyukapp/ClassProduk.dart';
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

class LaporanPenjualanProduk extends StatefulWidget {
  @override
  LaporanPenjualanProdukState createState() => LaporanPenjualanProdukState();
}

class LaporanPenjualanProdukState extends State<LaporanPenjualanProduk> {
  List<ClassLaporanProduk> arrLaporan = new List();
  List<ClassLaporanProduk> arrDetail = new List();
  List<ClassLaporanProduk> arrPaketFav = new List();
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
    _seriesPieData = List<charts.Series<ClassLaporanProduk, String>>();
    arrLaporan.add(new ClassLaporanProduk("produk 1", 1.0, Colors.green));
    _seriesPieData.add(charts.Series(
      data: arrLaporan,
      domainFn: (ClassLaporanProduk task, _) => task.nama_produk,
      measureFn: (ClassLaporanProduk task, _) => task.jumlahlaporan,
      colorFn: (ClassLaporanProduk task, _) =>
          charts.ColorUtil.fromDartColor(task.warna),
      id: 'Produk',
      labelAccessorFn: (ClassLaporanProduk row, _) => '${row.jumlahlaporan}',
    ));
    getProduk();
  }

  List<charts.Series<ClassLaporanProduk, String>> _seriesPieData;

  Future<List<ClassLaporanProduk>> getProduk() async {
    this.arrLaporan.clear();
    Map paramData = {'konsultan': session.userlogin};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getLaporanProduk"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      var data1 = data[0]['datalaporan'];
      var data3 = data[0]['fav'];
      data = data[0]['laporan'];
      final _random = Random();
      if (data1 == "tidak ada data") {
        for (int i = 0; i < data.length; i++) {
          Color warna = Color.fromARGB(255, _random.nextInt(256),
              _random.nextInt(256), _random.nextInt(256));
          ClassLaporanProduk laporpaket = new ClassLaporanProduk(
              data[i]['namaproduk'].toString(), 0, warna);
          arrLaporan.add(laporpaket);
        }
      } else {
        ada = 1;
        for (int i = 0; i < data.length; i++) {
          var ketemu = 0;
          Color warna = Color.fromARGB(255, _random.nextInt(256),
              _random.nextInt(256), _random.nextInt(256));
          for (int j = 0; j < data1.length; j++) {
            if (data[i]['kodeproduk'].toString() ==
                data1[j]['kodeproduk'].toString()) {
              ketemu++;
              if (data[i]['varian'] != "-") {
                ClassLaporanProduk laporpaket = new ClassLaporanProduk(
                    data[i]['namaproduk'].toString() +
                        " " +
                        data[i]['varian'].toString(),
                    double.parse(data1[j]['jumlah'].toString()),
                    warna);
                setState(() {
                  arrLaporan.add(laporpaket);
                  arrDetail.add(laporpaket);
                });
              } else {
                ClassLaporanProduk laporpaket = new ClassLaporanProduk(
                    data[i]['namaproduk'].toString(),
                    double.parse(data1[j]['jumlah'].toString()),
                    warna);
                setState(() {
                  arrLaporan.add(laporpaket);
                  arrDetail.add(laporpaket);
                });
              }
            }
          }
          if (ketemu == 0) {
            if (data[i]['varian'] != "-") {
              ClassLaporanProduk laporpaket = new ClassLaporanProduk(
                  data[i]['namaproduk'].toString() +
                      " " +
                      data[i]['varian'].toString(),
                  0,
                  warna);
              setState(() {
                arrLaporan.add(laporpaket);
                arrDetail.add(laporpaket);
              });
            } else {
              ClassLaporanProduk laporpaket = new ClassLaporanProduk(
                  data[i]['namaproduk'].toString(), 0, warna);
              setState(() {
                arrLaporan.add(laporpaket);
                arrDetail.add(laporpaket);
              });
            }
          }
        }
      }
      if (data3.length > 0) {
        if (data3.length <= 5) {
          for (int j = 0; j < data3.length; j++) {
            for (int i = 0; i < data.length; i++) {
              if (data[i]['kodeproduk'].toString() ==
                  data3[j]['kodeproduk'].toString()) {
                if (data[i]['varian'].toString() != "-") {
                  setState(() {
                    arrPaketFav.add(new ClassLaporanProduk(
                        data[i]['namaproduk'].toString() +
                            " " +
                            data[i]['varian'].toString(),
                        double.parse(data3[j]['jumlah'].toString()),
                        Colors.green));
                  });
                } else {
                  setState(() {
                    arrPaketFav.add(new ClassLaporanProduk(
                        data[i]['namaproduk'].toString(),
                        double.parse(data3[j]['jumlah'].toString()),
                        Colors.green));
                  });
                }
              }
            }
          }
        } else {
          for (int j = 0; j < 5; j++) {
            for (int i = 0; i < data.length; i++) {
              if (data[i]['kodeproduk'].toString() ==
                  data3[j]['kodeproduk'].toString()) {
                setState(() {
                  arrPaketFav.add(new ClassLaporanProduk(
                      data[i]['namaproduk'].toString(),
                      double.parse(data3[j]['jumlah'].toString()),
                      Colors.green));
                });
              }
            }
          }
        }
      }
      getDetailLaporan();
      return arrLaporan;
    }).catchError((err) {
      print(err);
    });
  }

  Future<List<ClassLaporanProduk>> getDetailLaporan() async {
    this.arrDetail.clear();
    List<ClassPaket> arrPaket = new List();
    Map paramData = {
      'konsultan': session.userlogin,
      "bulan": bulan,
      "tahun": tahun
    };
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getDetailLaporanProduk"),
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
          if (data[i]['kodeproduk'].toString() ==
              data1[j]['kodeproduk'].toString()) {
            if (data[i]['varian'].toString() != "-") {
              ClassLaporanProduk laporpaket = new ClassLaporanProduk(
                  data[i]['namaproduk'].toString() +
                      " " +
                      data[i]['varian'].toString(),
                  double.parse(data1[j]['jumlah'].toString()),
                  warna);
              setState(() {
                arrDetail.add(laporpaket);
              });
            } else {
              ClassLaporanProduk laporpaket = new ClassLaporanProduk(
                  data[i]['namaproduk'].toString(),
                  double.parse(data1[j]['jumlah'].toString()),
                  warna);
              setState(() {
                arrDetail.add(laporpaket);
              });
            }
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
                title: Text("Laporan Produk"),
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
                          Text("Laporan Penjualan Produk",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          ada > 0
                              ? Container(
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
                                DataColumn(label: Text("Nama Produk")),
                                DataColumn(label: Text('Jumlah Penjualan'))
                              ],
                              rows: List<DataRow>.generate(
                                  arrLaporan.length,
                                  (index) => DataRow(cells: <DataCell>[
                                        DataCell(
                                            Text((index + 1).toString() + ".")),
                                        DataCell(Container(
                                            child: Text(
                                                arrLaporan[index].nama_produk),
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
                                      DataColumn(label: Text("Nama Produk")),
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
                                                    .nama_produk),
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
                          Text("Produk Terfavorite",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(height: size.height * 0.01),
                          arrPaketFav.length > 0
                              ? DataTable(
                                  columns: [
                                      DataColumn(label: Text("No.")),
                                      DataColumn(label: Text("Nama Produk")),
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
                                                    .nama_produk),
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
                ])
              ]),
            )));
  }
}
