import 'dart:ui';

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

class tdeecalculator extends StatefulWidget {
  @override
  tdeecalculatorState createState() => tdeecalculatorState();
}

class tdeecalculatorState extends State<tdeecalculator> {
  String jk = "pria";
  int act = 0;
  TextEditingController tinggi = new TextEditingController();
  TextEditingController berat = new TextEditingController();
  TextEditingController umur = new TextEditingController();
  List<String> arrKet = [];
  double kalori = 0;

  void initState() {
    super.initState();
    setState(() {
      this.jk = "pria";
      this.act = 0;
      arrKet.add("Hampir Tidak Pernah Berolahraga (1x Seminggu)");
      arrKet.add("Jarang Berolahraga (2-3x Seminggu");
      arrKet.add("Sering Berolahraga ( Lebih Dari 3x Seminggu)");
    });
  }

  void handleradiogroup(String value) {
    setState(() => this.jk = value);
  }

  void handleradiogroupact(int value) {
    setState(() => this.act = value);
  }

  void hitung() {
    double bmr = 0;
    if (jk == "pria") {
      bmr = 66.5 +
          (13.7 * double.parse(berat.text)) +
          (5 * double.parse(tinggi.text)) -
          (6.8 * double.parse(umur.text));
    } else {
      bmr = 655 +
          (9.6 * double.parse(berat.text)) +
          (1.8 * double.parse(tinggi.text)) -
          (4.7 * double.parse(umur.text));
    }
    setState(() {
      if (act == 0) {
        kalori = bmr * 1.2;
      } else if (act == 1) {
        kalori = bmr * 1.3;
      } else {
        kalori = bmr * 1.4;
      }
      kalori = double.parse(kalori.floor().toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          children: [
            Expanded(
                child: Text("TDEE Kalkulator",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
            Expanded(
                flex: 4,
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Image.asset(
                          "assets/images/activity.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )),
                    SizedBox(width: 10),
                    Expanded(
                        child: Text(
                          "LIFESTYLE",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        flex: 2),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        child: Center(
                                          child: Radio(
                                            activeColor: Colors.green,
                                            value: 0,
                                            groupValue: act,
                                            onChanged: handleradiogroupact,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Center(
                                            child: Image.asset(
                                                "assets/images/lazy.png",
                                                height: 50,
                                                width: 50)),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        child: Center(
                                          child: Radio(
                                            activeColor: Colors.green,
                                            value: 1,
                                            groupValue: act,
                                            onChanged: handleradiogroupact,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Center(
                                            child: Image.asset(
                                                "assets/images/santai.png",
                                                height: 50,
                                                width: 50)),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        child: Center(
                                          child: Radio(
                                            activeColor: Colors.green,
                                            value: 2,
                                            groupValue: act,
                                            onChanged: handleradiogroupact,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Center(
                                            child: Image.asset(
                                                "assets/images/lari.png",
                                                height: 50,
                                                width: 50)),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                          Expanded(
                              child: Text(
                                arrKet[act].toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              flex: 2)
                        ],
                      ),
                      flex: 5,
                    ),
                  ],
                )),
            Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Image.asset(
                          "assets/images/height.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )),
                    SizedBox(width: 10),
                    Expanded(
                        child: Text(
                          "TINGGI BADAN",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        flex: 2),
                    Expanded(
                      child: TextField(
                        controller: tinggi,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                      ),
                      flex: 3,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        child: Text(
                          "CM",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        flex: 2)
                  ],
                )),
            Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Image.asset(
                          "assets/images/weight.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )),
                    SizedBox(width: 10),
                    Expanded(
                        child: Text(
                          "BERAT BADAN",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        flex: 2),
                    Expanded(
                      child: TextField(
                        controller: berat,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                      ),
                      flex: 3,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        child: Text(
                          "KG",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        flex: 2)
                  ],
                )),
            Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Image.asset(
                          "assets/images/age.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )),
                    SizedBox(width: 10),
                    Expanded(
                        child: Text(
                          "USIA",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        flex: 2),
                    Expanded(
                      child: TextField(
                        controller: umur,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                      ),
                      flex: 3,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        child: Text(
                          "TAHUN",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        flex: 2)
                  ],
                )),
            Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Image.asset(
                          "assets/images/gender.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "JENIS KELAMIN",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Center(
                              child: Radio(
                                activeColor: Colors.green,
                                value: "pria",
                                groupValue: jk,
                                onChanged: handleradiogroup,
                              ),
                            ),
                          ),
                          Container(
                            child: Center(
                                child: Image.asset("assets/images/male.png",
                                    height: 50, width: 50)),
                          ),
                          Container(
                            child: Center(
                              child: Radio(
                                activeColor: Colors.green,
                                value: "wanita",
                                groupValue: jk,
                                onChanged: handleradiogroup,
                              ),
                            ),
                          ),
                          Container(
                            child: Center(
                                child: Image.asset("assets/images/female.png",
                                    height: 50, width: 50)),
                          ),
                        ],
                      ),
                      flex: 5,
                    )
                  ],
                )),
            SizedBox(height: 25),
            Expanded(
              flex: 1,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                onPressed: () {
                  hitung();
                },
                color: Colors.lightBlueAccent,
                child: Text(
                  'Hitung',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              flex: 2,
              child: Text(
                "Hasil : " + kalori.toString() + " Kalori",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            )
          ],
        ),
      ),
    );
  }
}
