import 'package:flutter/cupertino.dart';

import 'produkdetail.dart';
import 'package:badges/badges.dart';
import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'ClassProduk.dart';
import 'package:intl/intl.dart';

class Daftarprodukmember extends StatefulWidget {
  final String kategori;

  Daftarprodukmember({Key key, @required this.kategori}) : super(key: key);

  @override
  DaftarprodukmemberState createState() =>
      DaftarprodukmemberState(this.kategori);
}

class DaftarprodukmemberState extends State<Daftarprodukmember> {
  NumberFormat frmt = new NumberFormat(',000');
  String kategori;
  String search = "";
  int jumlah = 0;
  TextEditingController hargaawal = new TextEditingController();
  TextEditingController hargaakhir = new TextEditingController();

  DaftarprodukmemberState(this.kategori);

  List<ClassProduk> arrProduk = new List();

  void initState() {
    super.initState();
    getProduk();
    for (int i = 0; i < session.Cart.length; i++) {
      if (int.parse(session.Cart[i].username) == session.userlogin) {
        jumlah++;
      }
    }
  }

  Future<List<ClassProduk>> getProduk() async {
    List<ClassProduk> tempProduk = new List();
    Map paramData = {'id': kategori};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getProdukKategori"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      var data = json.decode(res.body);
      data = data[0]['produk'];
      for (int i = 0; i < data.length; i++) {
        ClassProduk databaru = ClassProduk(
            data[i]['kodeproduk'].toString(),
            data[i]['nama'].toString(),
            data[i]['namaproduk'].toString(),
            data[i]['kodekategori'].toString(),
            data[i]['kemasan'].toString(),
            data[i]['harga'].toString(),
            data[i]['foto'].toString(),
            data[i]['deskripsi'].toString(),
            data[i]['status'].toString(),
            data[i]['varian'].toString(),
            data[i]['fotokonsultan'].toString(),
            data[i]['konsultan'].toString(),
            data[i]['berat'].toString());
        tempProduk.add(databaru);
      }
      setState(() => this.arrProduk = tempProduk);
      return tempProduk;
    }).catchError((err) {
      print(err);
    });
  }

  Future<List<ClassProduk>> searchProduk(String cari) async {
    List<ClassProduk> tempProduk = new List();
    Map paramData = {'cari': cari, 'id': kategori};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/searchProduk"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      var data = json.decode(res.body);
      data = data[0]['produk'];
      for (int i = 0; i < data.length; i++) {
        ClassProduk databaru = ClassProduk(
            data[i]['kodeproduk'].toString(),
            data[i]['nama'].toString(),
            data[i]['namaproduk'].toString(),
            data[i]['kodekategori'].toString(),
            data[i]['kemasan'].toString(),
            data[i]['harga'].toString(),
            data[i]['foto'].toString(),
            data[i]['deskripsi'].toString(),
            data[i]['status'].toString(),
            data[i]['varian'].toString(),
            data[i]['fotokonsultan'].toString(),
            data[i]['konsultan'].toString(),
            data[i]['berat'].toString());
        tempProduk.add(databaru);
      }
      setState(() => this.arrProduk = tempProduk);
      print("sinisitu");
      return tempProduk;
    }).catchError((err) {
      print(err);
    });
  }

  Future<List<ClassProduk>> searchfilterProduk(String cari) async {
    print(hargaawal.text + "---- " + hargaakhir.text);
    List<ClassProduk> tempProduk = new List();
    Map paramData = {
      'cari': cari,
      'id': kategori,
      'hargaawal': hargaawal.text,
      'hargaakhir': hargaakhir.text
    };
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/searchfilterProduk"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      var data = json.decode(res.body);
      var data1 = data[0]['status'];
      print("status : " + data1);
      data = data[0]['produk'];
      for (int i = 0; i < data.length; i++) {
        ClassProduk databaru = ClassProduk(
            data[i]['kodeproduk'].toString(),
            data[i]['nama'].toString(),
            data[i]['namaproduk'].toString(),
            data[i]['kodekategori'].toString(),
            data[i]['kemasan'].toString(),
            data[i]['harga'].toString(),
            data[i]['foto'].toString(),
            data[i]['deskripsi'].toString(),
            data[i]['status'].toString(),
            data[i]['varian'].toString(),
            data[i]['fotokonsultan'].toString(),
            data[i]['konsultan'].toString(),
            data[i]['berat'].toString());
        tempProduk.add(databaru);
      }
      setState(() => this.arrProduk = tempProduk);
      print("sinisitu");
      return tempProduk;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(children: [
      ShaderMask(
          shaderCallback: (rect) => LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: [Colors.black, Colors.transparent]).createShader(rect),
          blendMode: BlendMode.darken,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/gambarproduk.jpg'),
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.black54, BlendMode.darken))),
          )),
      Scaffold(
        backgroundColor: Colors.white70,
        body: ListView(
          children: [
            Row(
              children: <Widget>[
                Expanded(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 25),
                      child: TextField(
                        onSubmitted: (String str) {
                          setState(() {
                            search = str;
                          });
                          searchProduk(search);
                        },
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey[300]),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey[200]),
                            ),
                            contentPadding: EdgeInsets.all(15),
                            fillColor: Colors.grey[200],
                            filled: true,
                            hintText: 'Search',
                            hintStyle: TextStyle(
                                // fontFamily: "Roboto",
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                fontSize: 18),
                            prefixIcon: Icon(Icons.search,
                                size: 30, color: Colors.black)),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Badge(
                        badgeContent: Text(jumlah.toString()),
                        badgeColor: Colors.red,
                        animationType: BadgeAnimationType.scale,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/halamancart');
                            },
                            icon: Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                              size: 45,
                            ))))
              ],
            ),
            SizedBox(height: 25),
            SizedBox(
              height: size.height * 0.13,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                // decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                      child: Text(
                        "Filter Harga :",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                        height: 30,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: TextField(
                                    controller: hargaawal,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: "Minimum",
                                        prefixIcon: Text("Rp "),
                                        prefixIconConstraints: BoxConstraints(
                                            minWidth: 0, minHeight: 0)),
                                    textInputAction: TextInputAction.done)),
                            // Expanded(flex: 1, child: SizedBox()),
                            SizedBox(width: 50),
                            Expanded(
                                flex: 1,
                                child: TextField(
                                  controller: hargaakhir,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: "Maksimum",
                                      prefixIcon: Text("Rp "),
                                      prefixIconConstraints: BoxConstraints(
                                          minWidth: 0, minHeight: 0)),
                                  textInputAction: TextInputAction.done,
                                )),
                            Expanded(
                              child: Center(
                                  child: SizedBox(
                                child: Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    height: size.height * 0.08,
                                    width: size.width * 0.8,
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            color: session.kBlue),
                                        child: FlatButton(
                                          onPressed: () {
                                            setState(() {
                                              searchfilterProduk(search);
                                            });
                                          },
                                          child: Text(
                                            'Filter',
                                            style: session.kBodyText.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    )),
                              )),
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
            Container(
                child: Wrap(
                    children: List.generate(arrProduk.length, (index) {
              return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProdukDetail(id: arrProduk[index].kodeproduk)));
                  },
                  child: Card(
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Hero(
                            tag: arrProduk[index].kodeproduk,
                            child: Container(
                              width: (size.width - 16) / 2,
                              height: 200,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(session.ipnumber +
                                          "/gambar/produk/" +
                                          arrProduk[index].foto),
                                      fit: BoxFit.cover)),
                            )),
                        SizedBox(height: 15),
                        Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: arrProduk[index].varian != "-"
                                ? Text(
                                    arrProduk[index].namaproduk +
                                        " " +
                                        arrProduk[index].varian,
                                    style: TextStyle(fontSize: 16),
                                  )
                                : Text(arrProduk[index].namaproduk,
                                    style: TextStyle(fontSize: 16))),
                        SizedBox(height: 10),
                        Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text("Rp " +
                                frmt.format(
                                    int.parse(arrProduk[index].harga)))),
                        SizedBox(height: 10),
                      ],
                    ),
                  ));
            })))
          ],
        ),
      )
    ]);
  }
}
