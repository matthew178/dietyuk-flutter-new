import 'dart:ui';
import 'dart:math';
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
  void initState() {
    super.initState();
    _seriesPieData = List<charts.Series<Task, String>>();
    genData();
  }

  List<charts.Series<Task, String>> _seriesPieData;
  List<String> arr = ['Kerja', 'Makan', 'Minum', 'Main', 'Tidur'];
  List<Task> data = [];
  genData() {
    final _random = Random();
    for (int i = 0; i < arr.length; i++) {
      Color warna = Color.fromARGB(255, _random.nextInt(256),
          _random.nextInt(256), _random.nextInt(256));
      data.add(new Task(arr[i], double.parse((i + 1).toString()), warna));
    }
    // var data = [
    //   new Task('Kerja', 5, Colors.green),
    //   new Task('Makan', 10, Colors.red),
    //   new Task('Minum', 7, Colors.yellow),
    //   new Task('Main', 8, Colors.blue),
    //   new Task('Tidur', 4, Colors.teal)
    // ];
    _seriesPieData.add(charts.Series(
      data: data,
      domainFn: (Task task, _) => task.task,
      measureFn: (Task task, _) => task.taskValue,
      colorFn: (Task task, _) => charts.ColorUtil.fromDartColor(task.warna),
      id: 'Daily Task',
      labelAccessorFn: (Task row, _) => '${row.taskValue}',
    ));
  }

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
                          Expanded(
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
                                          fontFamily: 'Georgia', fontSize: 11),
                                    )
                                  ],
                                  defaultRenderer: new charts.ArcRendererConfig(
                                      arcWidth: 100,
                                      arcRendererDecorators: [
                                        new charts.ArcLabelDecorator(
                                            labelPosition:
                                                charts.ArcLabelPosition.inside)
                                      ]))),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Expanded(
                            child: DataTable(
                              columns: [
                                DataColumn(label: Text("Nama Paket")),
                                DataColumn(label: Text('Jumlah Transaksi'))
                              ],
                              rows: [
                                DataRow(cells: [
                                  DataCell(Text('Satu')),
                                  DataCell(Text("Dua"))
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
