import 'package:fluttertoast/fluttertoast.dart';

import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'ClassJenisPaket.dart';

class Tambahpaket extends StatefulWidget {
  @override
  TambahpaketState createState() => TambahpaketState();
}

class TambahpaketState extends State<Tambahpaket> {
  TextEditingController namaPaket = new TextEditingController();
  TextEditingController descPaket = new TextEditingController();
  TextEditingController estimasi = new TextEditingController();
  TextEditingController harga = new TextEditingController();
  TextEditingController durasi = new TextEditingController();
  ClassJenisPaket jp = null;
  List<ClassJenisPaket> jenispaket = new List();

  Future<String> tambahPaket() async {
    if (namaPaket.text == "" ||
        jp == null ||
        descPaket.text == "" ||
        estimasi.text == "" ||
        harga.text == "" ||
        durasi.text == "") {
      Fluttertoast.showToast(msg: "Inputan tidak boleh kosong");
    } else {
      Map paramData = {
        'nama': namaPaket.text,
        'jenis': jp.id,
        'desc': descPaket.text,
        'estimasi': estimasi.text,
        'harga': harga.text,
        'durasi': durasi.text,
        'konsultan': session.userlogin
      };
      var parameter = json.encode(paramData);
      http
          .post(Uri.parse(session.ipnumber + "/tambahpaket"),
              headers: {"Content-Type": "application/json"}, body: parameter)
          .then((res) {
        print(res.body);
        Navigator.pushNamed(context, "/konsultan");
      }).catchError((err) {
        print(err);
      });
    }
    return "";
  }

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
      }
      setState(() => this.jenispaket = tempKategori);
      return tempKategori;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Paket Diet"),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
            child: Center(
              child: TextFormField(
                controller: namaPaket,
                keyboardType: TextInputType.text,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "Nama Paket", hintText: "ex. Diet Karbo"),
                validator: (value) =>
                    value.isEmpty ? "Nama Paket tidak boleh kosong" : null,
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
              child: DropdownButton<ClassJenisPaket>(
                // style: Theme.of(context).textTheme.title,
                hint: Text("Jenis Paket"),
                value: jp,
                onChanged: (ClassJenisPaket value) {
                  setState(() => {this.jp = value});
                },
                items: jenispaket.map((ClassJenisPaket jenis) {
                  return DropdownMenuItem<ClassJenisPaket>(
                    value: jenis,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          jenis.nama,
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              )),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
            child: Center(
              child: TextField(
                controller: descPaket,
                keyboardType: TextInputType.multiline,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "Deskripsi Paket",
                    hintText: "ex. Diet Karbo adalah diet yang tidak  "),
                maxLines: null,
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
                    labelText: "Estimasi Turun (Kg)", hintText: ""),
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
                decoration: InputDecoration(labelText: "Harga (Rp)"),
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
                decoration: InputDecoration(labelText: "Durasi (Hari)"),
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
                  tambahPaket();
                },
                color: Colors.lightBlueAccent,
                child: Text(
                  'Tambah',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
        // child: Column(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     children: <Widget>[

        //     ]),
      ),
    );
  }
}
