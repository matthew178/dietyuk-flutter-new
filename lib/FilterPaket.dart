import 'package:dietyukapp/ClassJenisPaket.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'ClassKategoriProduk.dart';
import 'DaftarProdukMember.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'session.dart' as session;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class FilterPaket extends StatefulWidget {
  @override
  FilterPaketState createState() => FilterPaketState();
}

class FilterPaketState extends State<FilterPaket> {
  List<ClassJenisPaket> jenispaket = [];
  bool category = false;
  bool duration = false;
  bool estimation = false;
  bool price = false;
  TextEditingController durasi = new TextEditingController();
  TextEditingController estimasi = new TextEditingController();
  TextEditingController hargaawal = new TextEditingController();
  TextEditingController hargaakhir = new TextEditingController();
  List<String> statusjenis = [];
  String qrykategori = "";
  String qrydurasi = "";
  String qryestimasi = "";
  String qryharga = "";
  String qry = "";

  void initState() {
    super.initState();
    getKategori();
  }

  Future<List<ClassJenisPaket>> getKategori() async {
    List<ClassJenisPaket> tempKategori = new List();
    Map paramData = {};
    var parameter = json.encode(paramData);
    ClassJenisPaket databaru =
        new ClassJenisPaket("id", "id_paket", "gambar", "icon");
    http.get(Uri.parse(session.ipnumber + "/getjenispaketmember"),
        headers: {"Content-Type": "application/json"}).then((res) {
      var data = json.decode(res.body);
      data = data[0]['jenis'];
      for (int i = 0; i < data.length; i++) {
        databaru = ClassJenisPaket(
            data[i]['idjenispaket'].toString(),
            data[i]['namajenispaket'].toString(),
            data[i]['deskripsijenis'].toString(),
            data[i]['background'].toString());
        tempKategori.add(databaru);
        setState(() {
          statusjenis.add("0");
        });
      }
      setState(() => this.jenispaket = tempKategori);
      return tempKategori;
    }).catchError((err) {
      print(err);
    });
  }

  void buatquery() {
    qry = "";
    for (int i = 0; i < statusjenis.length; i++) {
      if (statusjenis[i] == "1") {
        if (qry == "") {
          qry = " jenispaket = '" + jenispaket[i].id + "' AND STATUS = 1";
          if (qrydurasi != "") {
            qry = qry + " AND " + qrydurasi;
          }
          if (qryestimasi != "") {
            qry = qry + " AND " + qryestimasi;
          }
          if (qryharga != "") {
            qry = qry + " AND " + qryharga;
          }
        } else {
          qry = qry +
              " OR jenispaket = '" +
              jenispaket[i].id +
              "' AND STATUS = 1";
          if (qrydurasi != "") {
            qry = qry + " AND " + qrydurasi;
          }
          if (qryestimasi != "") {
            qry = qry + " AND " + qryestimasi;
          }
          if (qryharga != "") {
            qry = qry + " AND " + qryharga;
          }
        }
      }
    }
    print(qry);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("Filter Paket"),
          backgroundColor: session.kBlue,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          category = !category;
                        });
                      },
                      child: Row(
                        children: [
                          Expanded(
                              child: Text("Jenis Paket",
                                  style: TextStyle(
                                      color: session.kBlue,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold))),
                          SizedBox(width: 25),
                          Expanded(
                              child: Container(
                                  width: 10,
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      category == false
                                          ? Icon(Icons.keyboard_arrow_down,
                                              color: Colors.grey)
                                          : Icon(Icons.keyboard_arrow_up,
                                              color: Colors.grey)
                                    ],
                                  )))
                        ],
                      )),
                  SizedBox(
                      width: double.infinity,
                      height: category == true ? 300 : 0,
                      child: Visibility(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: jenispaket.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(jenispaket[index].nama,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        child: Checkbox(
                                          value: statusjenis[index] == "0"
                                              ? false
                                              : true,
                                          onChanged: (bool newValue) {
                                            setState(() {
                                              if (statusjenis[index] == "0") {
                                                statusjenis[index] = "1";
                                              } else {
                                                statusjenis[index] = "0";
                                              }
                                              buatquery();
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                          visible: category)),
                  SizedBox(height: 10),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          duration = !duration;
                        });
                      },
                      child: Row(
                        children: [
                          Expanded(
                              child: Text("Durasi Paket",
                                  style: TextStyle(
                                      color: session.kBlue,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold))),
                          SizedBox(width: 25),
                          Expanded(
                              child: Container(
                                  width: 10,
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      duration == false
                                          ? Icon(Icons.keyboard_arrow_down,
                                              color: Colors.grey)
                                          : Icon(Icons.keyboard_arrow_up,
                                              color: Colors.grey)
                                    ],
                                  )))
                        ],
                      )),
                  SizedBox(
                      width: double.infinity,
                      height: duration == true ? 50 : 0,
                      child: Visibility(
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: TextField(
                                    controller: durasi,
                                    keyboardType: TextInputType.number,
                                    decoration:
                                        InputDecoration(hintText: "Durasi"),
                                    textInputAction: TextInputAction.done,
                                    onChanged: (text) {
                                      if (durasi.text != "") {
                                        qrydurasi = " durasi <= " + durasi.text;
                                      } else {
                                        qrydurasi = "";
                                      }
                                      buatquery();
                                    },
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    " Hari",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  )),
                              Expanded(flex: 2, child: SizedBox()),
                            ],
                          ),
                          visible: duration)),
                  SizedBox(height: 10),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          estimation = !estimation;
                        });
                      },
                      child: Row(
                        children: [
                          Expanded(
                              child: Text("Estimasi Turun",
                                  style: TextStyle(
                                      color: session.kBlue,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold))),
                          SizedBox(width: 25),
                          Expanded(
                              child: Container(
                                  width: 10,
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      estimation == false
                                          ? Icon(Icons.keyboard_arrow_down,
                                              color: Colors.grey)
                                          : Icon(Icons.keyboard_arrow_up,
                                              color: Colors.grey)
                                    ],
                                  )))
                        ],
                      )),
                  SizedBox(
                      width: double.infinity,
                      height: estimation == true ? 50 : 0,
                      child: Visibility(
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: TextField(
                                    controller: estimasi,
                                    keyboardType: TextInputType.number,
                                    decoration:
                                        InputDecoration(hintText: "Estimasi"),
                                    textInputAction: TextInputAction.done,
                                    onChanged: (text) {
                                      if (estimasi.text != "") {
                                        qryestimasi = " estimasiturun >= " +
                                            estimasi.text;
                                      } else {
                                        qryestimasi = "";
                                      }
                                      buatquery();
                                    },
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    " Kg",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  )),
                              Expanded(flex: 2, child: SizedBox()),
                            ],
                          ),
                          visible: estimation)),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          price = !price;
                        });
                      },
                      child: Row(
                        children: [
                          Expanded(
                              child: Text("Harga Paket",
                                  style: TextStyle(
                                      color: session.kBlue,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold))),
                          SizedBox(width: 25),
                          Expanded(
                              child: Container(
                                  width: 10,
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      price == false
                                          ? Icon(Icons.keyboard_arrow_down,
                                              color: Colors.grey)
                                          : Icon(Icons.keyboard_arrow_up,
                                              color: Colors.grey)
                                    ],
                                  )))
                        ],
                      )),
                  SizedBox(
                      width: double.infinity,
                      height: price == true ? 50 : 0,
                      child: Visibility(
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: hargaawal,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: "Harga Minimum",
                                        prefixIcon: Text("Rp "),
                                        prefixIconConstraints: BoxConstraints(
                                            minWidth: 0, minHeight: 0)),
                                    textInputAction: TextInputAction.done,
                                    onChanged: (text) {
                                      if (hargaawal.text != "" &&
                                          hargaakhir.text != "") {
                                        qryharga = " harga >= " +
                                            hargaawal.text +
                                            " AND harga <= " +
                                            hargaakhir.text;
                                      } else if (hargaawal.text != "" &&
                                          hargaakhir.text == "") {
                                        qryharga =
                                            " harga >= " + hargaawal.text;
                                      } else {
                                        qryharga =
                                            " harga <= " + hargaakhir.text;
                                      }
                                      buatquery();
                                    },
                                  )),
                              Expanded(flex: 1, child: SizedBox()),
                              Expanded(
                                  flex: 2,
                                  child: TextField(
                                      controller: hargaakhir,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          hintText: "Harga Maksimum",
                                          prefixIcon: Text("Rp "),
                                          prefixIconConstraints: BoxConstraints(
                                              minWidth: 0, minHeight: 0)),
                                      textInputAction: TextInputAction.done,
                                      onChanged: (text) {
                                        if (hargaawal.text != "" &&
                                            hargaakhir.text != "") {
                                          qryharga = " harga >= " +
                                              hargaawal.text +
                                              " AND harga <= " +
                                              hargaakhir.text;
                                        } else if (hargaawal.text != "" &&
                                            hargaakhir.text == "") {
                                          qryharga =
                                              " harga >= " + hargaawal.text;
                                        } else {
                                          qryharga =
                                              " harga <= " + hargaakhir.text;
                                        }
                                        buatquery();
                                      })),
                            ],
                          ),
                          visible: price)),
                  SizedBox(height: 10),
                  Center(
                      child: SizedBox(
                    child: Container(
                        height: size.height * 0.08,
                        width: size.width * 0.8,
                        child: Center(
                          child: Container(
                            height: size.height * 0.08,
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: session.kBlue),
                            child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  session.qry = qry;
                                  Navigator.pop(context);
                                  print(session.qry);
                                });
                              },
                              child: Text(
                                'Filter',
                                style: session.kBodyText
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )),
                  ))
                ],
              ),
            )
          ],
        ));
  }
}
