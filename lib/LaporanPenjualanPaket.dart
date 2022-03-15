import 'dart:ui';
import 'dart:math';
import 'package:dietyukapp/ClassLaporanPaket.dart';
import 'package:dietyukapp/ClassPaket.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  void initState() {
    super.initState();
    _seriesPieData = List<charts.Series<ClassLaporanPaket, String>>();
    arrLaporan.add(new ClassLaporanPaket("paket 1", 0, Colors.green));
    getPaket();
  }

  List<charts.Series<ClassLaporanPaket, String>> _seriesPieData;
  List<String> arr = ['Kerja', 'Makan', 'Minum', 'Main', 'Tidur'];
  List<Task> data = [];

  Future<List<ClassPaket>> getPaket() async {
    this.arrLaporan.clear();
    List<ClassPaket> arrPaket = new List();
    Map paramData = {'konsultan': 4};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getLaporanPaket"),
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
            });
            arrPaket.add(databaru);
          } else {
            ClassLaporanPaket laporpaket = new ClassLaporanPaket(
                data[i]['nama_paket'].toString(), 0, warna);
            arrLaporan.add(laporpaket);
          }
        }
      }
      print(arrLaporan.length.toString() + " data");
      setState(() => this.arrPaket = arrPaket);
      _seriesPieData.add(charts.Series(
        data: arrLaporan,
        domainFn: (ClassLaporanPaket task, _) => task.nama_paket,
        measureFn: (ClassLaporanPaket task, _) => task.jumlahlaporan,
        colorFn: (ClassLaporanPaket task, _) =>
            charts.ColorUtil.fromDartColor(task.warna),
        id: 'Daily Task',
        labelAccessorFn: (ClassLaporanPaket row, _) => '${row.jumlahlaporan}',
      ));
      return arrPaket;
    }).catchError((err) {
      print(err);
    });
  }

  // genData() {
  //   final _random = Random();
  //   for (int i = 0; i < arr.length; i++) {
  //     Color warna = Color.fromARGB(255, _random.nextInt(256),
  //         _random.nextInt(256), _random.nextInt(256));
  //     data.add(new Task(arr[i], double.parse((i + 1).toString()), warna));
  //   }
  //   _seriesPieData.add(charts.Series(
  //     data: data,
  //     domainFn: (Task task, _) => task.task,
  //     measureFn: (Task task, _) => task.taskValue,
  //     colorFn: (Task task, _) => charts.ColorUtil.fromDartColor(task.warna),
  //     id: 'Daily Task',
  //     labelAccessorFn: (Task row, _) => '${row.taskValue}',
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
        home: DefaultTabController(
            length: 1,
            child: Scaffold(
                appBar: AppBar(
                  title: Text("Laporan Penjualan Paket"),
                  backgroundColor: session.kBlue,
                ),
                body: TabBarView(children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      child: Center(
                        child: Column(children: [
                          Text("Laporan Penjualan Paket",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          // Expanded(
                          //     child: charts.PieChart(_seriesPieData,
                          //         animate: true,
                          //         animationDuration: Duration(seconds: 2),
                          //         behaviors: [
                          //           new charts.DatumLegend(
                          //             outsideJustification: charts
                          //                 .OutsideJustification.endDrawArea,
                          //             horizontalFirst: false,
                          //             desiredMaxRows: 2,
                          //             cellPadding: new EdgeInsets.only(
                          //                 right: 4.0, bottom: 4.0),
                          //             entryTextStyle: charts.TextStyleSpec(
                          //                 fontFamily: 'Georgia', fontSize: 11),
                          //           )
                          //         ],
                          //         defaultRenderer: new charts.ArcRendererConfig(
                          //             arcWidth: 100,
                          //             arcRendererDecorators: [
                          //               new charts.ArcLabelDecorator(
                          //                   labelPosition:
                          //                       charts.ArcLabelPosition.inside)
                          //             ]))),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Expanded(
                            child: DataTable(
                              columns: [
                                DataColumn(label: Text("Nama Paket")),
                                DataColumn(label: Text('Jumlah Penjualan'))
                              ],
                              rows: [
                                DataRow(cells: [
                                  DataCell(Text('Slimming Marathon')),
                                  DataCell(Text("3"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Text('Paket Diet 30 Hari Herbalife')),
                                  DataCell(Text("4"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Text('Paket Diet 10 Hari Herbalife')),
                                  DataCell(Text("5"))
                                ])
                              ],
                            ),
                          )
                        ]),
                      ),
                    ),
                  )
                ]))));
  }
}

class Task {
  String task;
  double taskValue;
  Color warna;
  Task(this.task, this.taskValue, this.warna);
}
