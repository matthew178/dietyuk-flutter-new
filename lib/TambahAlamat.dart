import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'session.dart' as session;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'Provinsi.dart';
import 'Kota.dart';

class TambahAlamat extends StatefulWidget {
  @override
  TambahAlamatState createState() => TambahAlamatState();
}

class TambahAlamatState extends State<TambahAlamat> {
  TextEditingController detail = new TextEditingController();
  TextEditingController penerima = new TextEditingController();
  TextEditingController nomortelepon = new TextEditingController();
  List<Provinsi> arrProvinsi = new List();
  List<Kota> arrKota = new List();
  Provinsi prov = null;
  Kota city = null;

  void initState() {
    super.initState();
    getProvinsi();
  }

  Future<String> tambahAlamatPenerima() async {
    Map paramData = {
      'username': session.userlogin,
      'provinsi': prov.id,
      'kota': city.id,
      'detail': detail.text,
      'penerima': penerima.text,
      'nohp': nomortelepon.text
    };
    var parameter = json.encode(paramData);
    if (detail.text == "" ||
        penerima.text == "" ||
        nomortelepon.text == "" ||
        city.id == "" ||
        prov.id == "") {
      Fluttertoast.showToast(msg: "Inputan tidak boleh kosong");
    } else {
      http
          .post(Uri.parse(session.ipnumber + "/tambahAlamat"),
              headers: {"Content-Type": "application/json"}, body: parameter)
          .then((res) {
        var data = json.decode(res.body);
        data = data[0]['status'];
        Fluttertoast.showToast(msg: data);
        Navigator.pop(context);
        return data;
      }).catchError((err) {
        print(err);
      });
    }
  }

  Future<List<Provinsi>> getProvinsi() async {
    List<Provinsi> tempProvinsi = new List();
    Provinsi prv = new Provinsi("1", "");
    http.get(Uri.parse(session.ipnumber + "/getProvinsi"), headers: {}).then(
        (res) {
      var data = json.decode(res.body);
      data = data[0]['provinsi'];
      for (int i = 0; i < data.length; i++) {
        prv = new Provinsi(data[i]['id_provinsi'].toString(),
            data[i]['nama_provinsi'].toString());
        tempProvinsi.add(prv);
      }
      setState(() {
        this.arrProvinsi = tempProvinsi;
      });
    }).catchError((err) {
      print(err);
    });
    return tempProvinsi;
  }

  Future<List<Kota>> getKota(int provinsi) async {
    city = null;
    List<Kota> tempKota = new List();
    Kota kot = new Kota(
        "id", "provinsi", "namaprovinsi", "tipe", "namakota", "kodepos");
    Map paramData = {'prov': provinsi};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getKotaByProvinsi"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['kota'];
      for (int i = 0; i < data.length; i++) {
        kot = Kota(
            data[i]['id_kota'].toString(),
            data[i]['id_provinsi'].toString(),
            data[i]['provinsi'].toString(),
            data[i]['tipe'].toString(),
            data[i]['nama_kota'].toString(),
            data[i]['kodepos'].toString());
        tempKota.add(kot);
      }
      setState(() => this.arrKota = tempKota);
      return arrKota;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: CustomShapeClipper(),
                child: Container(
                  height: 400,
                  color: Colors.blue[200],
                ),
              ),
              SafeArea(
                  child: Column(
                children: [
                  SizedBox(height: 20),
                  Center(
                      child: Center(
                          child: Text(
                    'Tambah Alamat',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ))),
                  SizedBox(height: 25),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                        height: size.height * 0.6,
                        width: size.width * 0.95,
                        decoration: BoxDecoration(
                            color: Colors.grey[500].withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16)),
                        child: Center(
                            child: Column(
                          children: [
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                              margin: EdgeInsets.fromLTRB(20, 10, 7, 0),
                              child: Container(
                                  height: size.height * 0.08,
                                  decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Center(
                                    child: TextField(
                                      controller: penerima,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                          ),
                                          hintText: "Nama Penerima"),
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.done,
                                    ),
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                              margin: EdgeInsets.fromLTRB(20, 10, 7, 0),
                              child: Container(
                                  height: size.height * 0.08,
                                  decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Center(
                                    child: TextField(
                                      controller: nomortelepon,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                        ),
                                        hintText: "No.HP Penerima",
                                      ),
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                    ),
                                  )),
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                                margin: EdgeInsets.fromLTRB(20, 10, 7, 0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.blue[50]),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: DropdownButton<Provinsi>(
                                      // style: Theme.of(context).textTheme.title,
                                      hint: Text("Provinsi"),
                                      value: prov,
                                      onChanged: (Provinsi value) {
                                        setState(() => {
                                              this.prov = value,
                                              city = null,
                                              getKota(int.parse(value.id))
                                            });
                                      },
                                      items: arrProvinsi.map((Provinsi prov) {
                                        return DropdownMenuItem<Provinsi>(
                                          value: prov,
                                          child: Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                prov.nama,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    )),
                                  ],
                                )),
                            Container(
                                padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                                margin: EdgeInsets.fromLTRB(20, 10, 7, 0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.blue[50]),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: DropdownButton<Kota>(
                                      // style: Theme.of(context).textTheme.title,
                                      hint: Text("Kota"),
                                      value: city,
                                      onChanged: (Kota value) {
                                        setState(() => {this.city = value});
                                      },
                                      items: arrKota.map((Kota tempKot) {
                                        return DropdownMenuItem<Kota>(
                                          value: tempKot,
                                          child: Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                tempKot.tipe +
                                                    " " +
                                                    tempKot.namakota,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    )),
                                  ],
                                )),
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                              margin: EdgeInsets.fromLTRB(20, 10, 7, 0),
                              child: Container(
                                  height: size.height * 0.08,
                                  decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Center(
                                    child: TextField(
                                      controller: detail,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                          ),
                                          hintText: "Detail Alamat"),
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.done,
                                    ),
                                  )),
                            ),
                          ],
                        ))),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
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
                                tambahAlamatPenerima();
                              },
                              child: Text(
                                'Tambah',
                                style: session.kBodyText
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )),
                  ),
                ],
              ))
            ],
          ),
        ],
      ),
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height);

    var firstEndPoint = Offset(size.width * .5, size.height - 30.0);
    var firstControlpoint = Offset(size.width * 0.25, size.height - 50.0);
    path.quadraticBezierTo(firstControlpoint.dx, firstControlpoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 80.0);
    var secondControlPoint = Offset(size.width * .75, size.height - 10);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
