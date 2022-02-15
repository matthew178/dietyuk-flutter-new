import 'ClassAlamat.dart';
import 'ClassKategoriProduk.dart';
import 'Daftarprodukmember.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'session.dart' as session;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class PilihAlamat extends StatefulWidget {
  @override
  PilihAlamatState createState() => PilihAlamatState();
}

class PilihAlamatState extends State<PilihAlamat> {
  List<ClassAlamat> arrAlamat = new List();

  Future<List<ClassAlamat>> getAlamatUser() async {
    List<ClassAlamat> tempArr = new List();
    ClassAlamat alamat = new ClassAlamat("id", "username", "provinsi", "kota",
        "detail", "namaprovinsi", "namakota", "", "");
    Map paramData = {'userlogin': session.userlogin};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getDaftarAlamat"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      var data = json.decode(res.body);
      data = data[0]['alamat'];
      for (int i = 0; i < data.length; i++) {
        alamat = ClassAlamat(
            data[i]['id'].toString(),
            data[i]['username'].toString(),
            data[i]['provinsi'].toString(),
            data[i]['kota'].toString(),
            data[i]['alamat_detail'].toString(),
            data[i]['nama_provinsi'].toString(),
            data[i]['nama_kota'].toString(),
            data[i]['penerima'].toString(),
            data[i]['nomortelepon'].toString());
        tempArr.add(alamat);
      }
      setState(() => this.arrAlamat = tempArr);
      print("jumlah alamat : " + arrAlamat.length.toString());
      return tempArr;
    }).catchError((err) {
      print(err);
    });
  }

  void initState() {
    getAlamatUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilih Alamat Pengiriman"),
        backgroundColor: session.warna,
      ),
      body: Column(
        children: [
          Expanded(
              child: SizedBox(
                height: 50,
                child: Container(
                  padding: EdgeInsets.fromLTRB(100, 10, 100, 10),
                  margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/tambahAlamat")
                            .then((value) => getAlamatUser());
                      },
                      child: Text(
                        "(+) Tambah Alamat",
                        style: TextStyle(fontSize: 15),
                      )),
                ),
              ),
              flex: 1),
          Expanded(
              flex: 3,
              child: new ListView.builder(
                  itemCount: arrAlamat.length == 0 ? 1 : arrAlamat.length,
                  itemBuilder: (context, index) {
                    if (arrAlamat.length == 0) {
                      return Image.asset("assets/images/nodata.png");
                    } else {
                      return GestureDetector(
                          onTap: () {
                            session.alamat = arrAlamat[index];
                            Fluttertoast.showToast(
                                msg: "Berhasil pilih alamat");
                            Navigator.pop(context);
                          },
                          child: Card(
                            child: Column(
                              children: [
                                Text(arrAlamat[index].penerima),
                                Text(arrAlamat[index].nomortelepon),
                                Text(arrAlamat[index].detail),
                                Text(arrAlamat[index].namakota +
                                    ", " +
                                    arrAlamat[index].namaprovinsi)
                                // Expanded(child: Text(arrAlamat[index].detail))
                              ],
                            ),
                          ));
                    }
                  }))
        ],
      ),
    );
  }
}
