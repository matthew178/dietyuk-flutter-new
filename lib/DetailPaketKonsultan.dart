import 'package:fluttertoast/fluttertoast.dart';

import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'ClassPaket.dart';

class DetailPaketKonsultan extends StatefulWidget {
  final String id;

  DetailPaketKonsultan({Key key, @required this.id}) : super(key: key);

  @override
  DetailPaketKonsultanState createState() => DetailPaketKonsultanState(this.id);
}

class DetailPaketKonsultanState extends State<DetailPaketKonsultan> {
  TextEditingController nama = new TextEditingController();
  TextEditingController deskripsi = new TextEditingController();
  TextEditingController estimasi = new TextEditingController();
  TextEditingController harga = new TextEditingController();
  TextEditingController durasi = new TextEditingController();
  ClassPaket paketsaatini =
      new ClassPaket("", "", "", "", "", "", "", "", "", "");

  String id;
  List<ClassPaket> arrPaket = new List();

  DetailPaketKonsultanState(this.id);

  void initState() {
    super.initState();
    getPaket();
  }

  Future<List<ClassPaket>> getPaket() async {
    ClassPaket paket = new ClassPaket("", "", "", "", "", "", "", "", "", "");
    Map paramData = {'id': id};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getpaketbyid"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['paket'];
      for (int i = 0; i < data.length; i++) {
        paket = ClassPaket(
            data[i]['id_paket'].toString(),
            data[i]['estimasiturun'].toString(),
            data[i]['harga'].toString(),
            data[i]['durasi'].toString(),
            data[i]['status'].toString(),
            data[i]['rating'].toString(),
            data[i]['konsultan'].toString(),
            data[i]['nama_paket'].toString(),
            data[i]['deskripsi'].toString(),
            data[i]['gambar'].toString());
      }
      setState(() => this.paketsaatini = paket);
      nama.text = paket.nama;
      deskripsi.text = paket.deskripsi;
      estimasi.text = paket.estimasi;
      harga.text = paket.harga;
      durasi.text = paket.durasi;
      return paket;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> simpanUpdate() async {
    Map paramData = {
      'nama': nama.text,
      'desc': deskripsi.text,
      'estimasi': estimasi.text,
      'harga': harga.text,
      'durasi': durasi.text,
      'id': id
    };
    var parameter = json.encode(paramData);
    if (nama.text == "" ||
        deskripsi.text == "" ||
        estimasi.text == "" ||
        harga.text == "" ||
        durasi.text == "" ||
        id == "") {
      Fluttertoast.showToast(msg: "Inputan tidak boleh kosong");
    } else {
      http
          .post(Uri.parse(session.ipnumber + "/updatepaket"),
              headers: {"Content-Type": "application/json"}, body: parameter)
          .then((res) {
        print(res.body);
        Fluttertoast.showToast(msg: "Berhasil Update Paket");
        Navigator.pushNamed(context, "/konsultan");
      }).catchError((err) {
        print(err);
      });
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Paket  " + id),
        backgroundColor: session.warna,
      ),
      body: Center(
        child: ListView(children: <Widget>[
          SizedBox(height: 1),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
            child: Center(
              child: TextFormField(
                controller: nama,
                keyboardType: TextInputType.text,
                autofocus: true,
                decoration:
                    InputDecoration(labelText: "Nama Paket", hintText: ""),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
            child: Center(
              child: TextFormField(
                controller: deskripsi,
                keyboardType: TextInputType.multiline,
                autofocus: true,
                maxLines: null,
                decoration:
                    InputDecoration(labelText: "Deskripsi Paket", hintText: ""),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
            child: Center(
              child: TextFormField(
                controller: estimasi,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "Estimasi Turun(Kg)", hintText: ""),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
            child: Center(
              child: TextFormField(
                controller: harga,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration:
                    InputDecoration(labelText: "Harga(Rp)", hintText: ""),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
            child: Center(
              child: TextFormField(
                controller: durasi,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration:
                    InputDecoration(labelText: "Durasi(Hari)", hintText: ""),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 30, 10, 0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                onPressed: () {
                  simpanUpdate();
                },
                color: Colors.lightBlueAccent,
                child: Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
