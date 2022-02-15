import 'ClassKategoriProduk.dart';
import 'ClassPaket.dart';
import 'ClassProduk.dart';
import 'ClassUser.dart';
import 'Daftarprodukmember.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'session.dart' as session;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'ProdukDetail.dart';
import 'DetailPaket.dart';

class WallKonsultan extends StatefulWidget {
  final String id;
  WallKonsultan({Key key, @required this.id}) : super(key: key);
  @override
  WallKonsultanState createState() => WallKonsultanState(this.id);
}

class WallKonsultanState extends State<WallKonsultan> {
  String foto = session.ipnumber + "/gambar/wanita.png";
  List<ClassProduk> arrProduk = new List();
  List<ClassPaket> arrPaket = new List();

  ClassUser konsul = new ClassUser(
      "id",
      "username",
      "email",
      "password",
      "nama",
      "jeniskelamin",
      "nomorhp",
      "tanggallahir",
      "berat",
      "tinggi",
      "role",
      "saldo",
      "rating",
      "status",
      "foto",
      "provinsi",
      "kota");
  String idkonsultan;
  NumberFormat frmt = new NumberFormat(',000');

  WallKonsultanState(this.idkonsultan);

  Future<ClassUser> getProfile() async {
    ClassUser userlog = new ClassUser(
        "", "", "", "", "", "", "", "", "", "", "", "", "0", "", "", "", "");
    Map paramData = {'id': idkonsultan};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getprofile"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      var data = json.decode(res.body);
      data = data[0]['profile'];
      userlog = ClassUser(
          data[0]["id"].toString(),
          data[0]["username"].toString(),
          data[0]["email"].toString(),
          data[0]["password"].toString(),
          data[0]["nama"].toString(),
          data[0]["jeniskelamin"].toString(),
          data[0]["nomorhp"].toString(),
          data[0]["tanggallahir"].toString(),
          data[0]["berat"].toString(),
          data[0]["tinggi"].toString(),
          data[0]["role"].toString(),
          data[0]["saldo"].toString(),
          data[0]["rating"].toString(),
          data[0]["status"].toString(),
          data[0]["foto"].toString(),
          data[0]["provinsi"].toString(),
          data[0]["kota"].toString());
      setState(() => this.konsul = userlog);
      if (konsul.jeniskelamin == "pria" && konsul.foto == "pria.png")
        foto = session.ipnumber + "/gambar/pria.jpg";
      else if (konsul.jeniskelamin == "wanita" && konsul.foto == "wanita.png")
        foto = session.ipnumber + "/gambar/wanita.png";
      else
        foto = session.ipnumber + "/gambar/" + konsul.foto;
      return userlog;
    }).catchError((err) {
      print(err);
    });
  }

  Future<List<ClassProduk>> getProduk() async {
    List<ClassProduk> tempProduk = new List();
    Map paramData = {'id': idkonsultan};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getprodukbykonsultan"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['produk'];
      for (int i = 0; i < data.length; i++) {
        ClassProduk databaru = ClassProduk(
            data[i]['kodeproduk'].toString(),
            data[i]['konsultan'].toString(),
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

  Future<List<ClassPaket>> getPaket() async {
    List<ClassPaket> arrPaket = new List();
    Map paramData = {'id': idkonsultan};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getpaketkonsultan"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['paket'];
      for (int i = 0; i < data.length; i++) {
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
            data[i]['background'].toString());
        arrPaket.add(databaru);
      }
      setState(() => this.arrPaket = arrPaket);
      setState(() => session.paketSemua = this.arrPaket);
      print(arrPaket.length.toString() + " paket");
      return arrPaket;
    }).catchError((err) {
      print(err);
    });
  }

  void initState() {
    super.initState();
    getProfile();
    getProduk();
    getPaket();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Konsultan"),
        backgroundColor: session.warna,
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            children: <Widget>[
              SizedBox(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    height: 64,
                    margin: EdgeInsets.only(bottom: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 32,
                          backgroundImage: NetworkImage(this.foto),
                        ),
                        SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              konsul.nama,
                              style: TextStyle(
                                  // color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset("assets/images/bfull.png"),
                                ),
                                SizedBox(width: 5),
                                Text(konsul.rating)
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: AppBar(
                  backgroundColor: session.warna,
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        text: "Paket Diet",
                      ),
                      Tab(
                        text: "Produk",
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // first tab bar view widget
                    Container(
                      child: ListView(
                        children: [
                          Container(
                              child: Wrap(
                                  children: List.generate(
                                      session.paketSemua.length, (index) {
                            return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailPaket(
                                              id: arrPaket[index].id,
                                              konsultan: session
                                                  .paketSemua[index]
                                                  .konsultan)));
                                },
                                child: Card(
                                    child: Column(
                                  children: [
                                    Stack(children: <Widget>[
                                      new Image.network(session.ipnumber +
                                          "/" +
                                          session.paketSemua[index].gambar),
                                      Positioned.fill(
                                          top: 35,
                                          right: 10,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              session.paketSemua[index].nama,
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily: "PoiretOne"),
                                            ),
                                          )),
                                      Positioned.fill(
                                          top: 65,
                                          right: 10,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              "By : " +
                                                  session.paketSemua[index]
                                                      .konsultan,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                      Positioned.fill(
                                          top: 95,
                                          right: 10,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              session.paketSemua[index].durasi +
                                                  " hari",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                      Positioned.fill(
                                          top: 125,
                                          right: 10,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              "Rp " +
                                                  frmt.format(int.parse(session
                                                      .paketSemua[index]
                                                      .harga)),
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily: 'Biryani'),
                                            ),
                                          )),
                                    ]),
                                  ],
                                )));
                          })))
                        ],
                      ),
                    ),

                    // second tab bar viiew widget
                    Container(
                      child: ListView(
                        children: [
                          Wrap(
                              children:
                                  List.generate(arrProduk.length, (index) {
                            return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProdukDetail(
                                              id: arrProduk[index]
                                                  .kodeproduk)));
                                },
                                child: Card(
                                  elevation: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Hero(
                                          tag: arrProduk[index].kodeproduk,
                                          child: Container(
                                            width: (size.width - 16) / 2,
                                            height: 200,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(session
                                                            .ipnumber +
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
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                )
                                              : Text(
                                                  arrProduk[index].namaproduk,
                                                  style:
                                                      TextStyle(fontSize: 16))),
                                      SizedBox(height: 10),
                                      Padding(
                                          padding: EdgeInsets.only(left: 15),
                                          child: Text("Rp " +
                                              frmt.format(int.parse(
                                                  arrProduk[index].harga)))),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ));
                          }))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
