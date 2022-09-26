import 'package:badges/badges.dart';
import 'chat.dart';
import 'ClassProduk.dart';
import 'WallKonsultan.dart';
import 'shoppingcart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProdukDetail extends StatefulWidget {
  final String id;
  ProdukDetail({Key key, @required this.id}) : super(key: key);
  @override
  ProdukDetailState createState() => ProdukDetailState(this.id);
}

class ProdukDetailState extends State<ProdukDetail> {
  NumberFormat frmt = new NumberFormat(',000');
  String id;
  int jumlah = 1;
  int jumlahCart = 0;
  int flag = 0, index = -1;
  SharedPreferences preferences;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String channel;
  ClassProduk produk = new ClassProduk(
      "kodeproduk",
      "konsultan",
      "namaproduk",
      "kodekategori",
      "kemasan",
      "0",
      "defaultproduct.png",
      "deskripsi",
      "status",
      "varian",
      "pria.jpg",
      "0",
      "");

  ProdukDetailState(this.id);

  void initState() {
    super.initState();
    getProdukDetail();
    // for (int i = 0; i < session.Cart.length; i++) {
    //   if (int.parse(session.Cart[i].username) == session.userlogin) {
    //     jumlahCart++;
    //   }
    // }
  }

  Future<List<ClassProduk>> getProdukCart() async {
    String data = jsonEncode(session.Cart);
    List<ClassProduk> arrTemp = new List();
    Map paramData = {'data': data};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getProdukCart"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var hsl = json.decode(res.body);
      print("ini : " + hsl);
      hsl = hsl[0]['produk'];
      for (int i = 0; i < hsl.length; i++) {
        ClassProduk databaru = new ClassProduk(
            hsl[i]['kodeproduk'].toString(),
            hsl[i]['konsultan'].toString(),
            hsl[i]['namaproduk'].toString(),
            hsl[i]['kodekategori'].toString(),
            hsl[i]['kemasan'].toString(),
            hsl[i]['harga'].toString(),
            hsl[i]['foto'].toString(),
            hsl[i]['deskripsi'].toString(),
            hsl[i]['status'].toString(),
            hsl[i]['varian'].toString(),
            hsl[i]['fotokonsultan'].toString(),
            hsl[i]['konsultan'].toString(),
            hsl[i]['berat'].toString());
        session.Cart[i].produkini = databaru;
      }
    }).catchError((err) {
      print(err);
    });
    return arrTemp;
  }

  void sendmessage() async {
    // var teks = teksChat.text;
    // teksChat.text = "";

    DocumentReference ref = await _firestore.collection(channel).add({
      'user1': session.userlogin.toString(),
      'user2': produk.idkonsultan,
      'teks': "",
      'tanggal': DateTime.now().toString(),
      'foto': produk.foto
    });
  }

  Future<ClassProduk> getProdukDetail() async {
    ClassProduk produkskrg = new ClassProduk(
        "kodeproduk",
        "konsultan",
        "namaproduk",
        "kodekategori",
        "kemasan",
        "0",
        "foto",
        "deskripsi",
        "status",
        "varian",
        "pria.jpg",
        "0",
        "");
    Map paramData = {'kodeproduk': this.id};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getProdukDetail"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      var data = json.decode(res.body);
      data = data[0]['produk'];
      produkskrg = new ClassProduk(
          data['kodeproduk'].toString(),
          data['namakonsultan'].toString(),
          data['namaproduk'].toString(),
          data['kodekategori'].toString(),
          data['kemasan'].toString(),
          data['harga'].toString(),
          data['foto'].toString(),
          data['deskripsi'].toString(),
          data['status'].toString(),
          data['varian'].toString(),
          data['fotokonsultan'].toString(),
          data['konsultan'].toString(),
          data['berat'].toString());
      setState(() => this.produk = produkskrg);
      if (session.userlogin.toString().compareTo(produk.idkonsultan) < 0) {
        channel = session.userlogin.toString() + "_" + produk.idkonsultan;
      } else {
        channel = produk.idkonsultan + "_" + session.userlogin.toString();
      }
      return produkskrg;
    }).catchError((err) {
      print(err);
    });
  }

  void showAlert() {
    AlertDialog dialog = new AlertDialog(
      content: new Container(
        width: 260.0,
        height: 230.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Expanded(
              child: new Container(
                  child: new Text(
                      "Bersihkan keranjang belanja dan tambahkan produk dari konsultan ini ?")),
              flex: 2,
            ),
            new Expanded(
              child: Row(
                children: [
                  SizedBox(width: 30),
                  Container(
                    child: new RaisedButton(
                      onPressed: () {
                        session.Cart.clear();
                        shoppingcart cart = new shoppingcart(
                            produk.kodeproduk,
                            session.userlogin.toString(),
                            jumlah.toString(),
                            produk.idkonsultan.toString(),
                            produk.harga.toString());
                        session.Cart.add(cart);
                        Fluttertoast.showToast(
                            msg: "Berhasil tambah ke Keranjang!");
                        Navigator.of(context, rootNavigator: true).pop(true);
                      },
                      padding: new EdgeInsets.all(16.0),
                      color: Colors.green,
                      child: new Text(
                        'Ya',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: 'helvetica_neue_light',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    child: new RaisedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop(true);
                      },
                      padding: new EdgeInsets.all(16.0),
                      color: Colors.red,
                      child: new Text(
                        'Tidak',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: 'helvetica_neue_light',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("ini masuk halaman cart");
        },
        child: Badge(
            badgeContent: Text(
              jumlahCart.toString(),
              style: TextStyle(color: Colors.white),
            ),
            badgeColor: Colors.red,
            animationType: BadgeAnimationType.scale,
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/halamancart');
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 30,
                ))),
        backgroundColor: session.kBlue,
      ),
      body: ListView(
        children: [
          Hero(
            tag: produk.foto,
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 50),
              height: size.height / 1.7,
              width: size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          session.ipnumber + "/gambar/produk/" + produk.foto),
                      fit: BoxFit.cover)),
              child: Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      fit: FlexFit.loose,
                      child: RawMaterialButton(
                        elevation: 2,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        constraints: BoxConstraints(minWidth: 10, maxWidth: 50),
                        child: Icon(Icons.chevron_left,
                            color: Colors.black, size: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
              transform: Matrix4.translationValues(0, -30, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.white,
              ),
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50.0,
                      height: 6.0,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  SizedBox(
                    height: (size.height / 100) * 3.5,
                  ),
                  produk.varian != "-"
                      ? Text(produk.namaproduk + " " + produk.varian,
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w700))
                      : Text(produk.namaproduk,
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: (size.height / 100) * 2.5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      int.parse(produk.harga) > 1000
                          ? Text(
                              "Rp " + frmt.format(int.parse(produk.harga)),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700),
                            )
                          : Text(
                              "Rp " + produk.harga,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700),
                            ),
                      SizedBox(
                        child: Row(
                          children: [
                            RawMaterialButton(
                              constraints: BoxConstraints(minWidth: 0),
                              onPressed: () {
                                setState(() {
                                  if (jumlah <= 0)
                                    jumlah = 0;
                                  else
                                    jumlah--;
                                });
                              },
                              elevation: 0,
                              child: Icon(
                                Icons.remove,
                                color: Colors.black,
                                size: 20,
                              ),
                              fillColor: Colors.grey[200],
                              padding: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              jumlah.toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            RawMaterialButton(
                              constraints: BoxConstraints(minWidth: 0),
                              elevation: 0,
                              onPressed: () {
                                setState(() {
                                  jumlah++;
                                });
                              },
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 20,
                              ),
                              fillColor: Colors.grey[200],
                              padding: EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  WallKonsultan(id: produk.idkonsultan)));
                      print(produk.konsultan + " " + produk.idkonsultan);
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(session.ipnumber +
                                      "/gambar/" +
                                      produk.fotokonsultan),
                                  fit: BoxFit.cover)),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              produk.konsultan,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Konsultan Diet",
                              style: TextStyle(fontSize: 13),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Deskripsi Produk",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    produk.deskripsi,
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 40),
                  Row(children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: session.kBlue),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            // color: Colors.blue,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Chat(
                                              username1:
                                                  session.userlogin.toString(),
                                              username2: produk.idkonsultan,
                                              namalawan: produk.konsultan)));
                                  sendmessage();
                                },
                                icon: Icon(Icons.chat)))),
                    SizedBox(width: 5),
                    Expanded(
                        flex: 4,
                        child: Center(
                          child: Container(
                            height: size.height * 0.08,
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: session.kBlue),
                            child: FlatButton(
                              onPressed: () {
                                if (jumlah > 0) {
                                  if (session.Cart.length > 0) {
                                    if (session.Cart[0].konsultan ==
                                        produk.idkonsultan) {
                                      flag = 1;
                                      print("sana");
                                      for (int i = 0;
                                          i < session.Cart.length;
                                          i++) {
                                        if (session.Cart[i].kodeproduk ==
                                            produk.kodeproduk) {
                                          setState(() {
                                            flag = 2;
                                            index = i;
                                            print("sinisana");
                                          });
                                        }
                                      }
                                    } else {
                                      print("session " +
                                          session.Cart[0].konsultan +
                                          " produk " +
                                          produk.idkonsultan);
                                      showAlert();
                                      print("sanasini");
                                    }
                                  } else {
                                    setState(() {
                                      flag = 1;
                                      print("sini");
                                    });
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Jumlah produk minimal 1");
                                }
                                if (flag == 1) {
                                  setState(() {
                                    shoppingcart cart = new shoppingcart(
                                        produk.kodeproduk,
                                        session.userlogin.toString(),
                                        jumlah.toString(),
                                        produk.idkonsultan.toString(),
                                        produk.harga.toString());
                                    jumlahCart++;
                                    session.Cart.add(cart);
                                    getProdukCart();
                                  });

                                  Fluttertoast.showToast(
                                      msg: "Berhasil tambah ke Keranjang!");
                                } else if (flag == 2) {
                                  setState(() {
                                    session.Cart[index].jumlah =
                                        (int.parse(session.Cart[index].jumlah) +
                                                jumlah)
                                            .toString();
                                    getProdukCart();
                                  });
                                  Fluttertoast.showToast(
                                      msg: "Berhasil tambah ke Keranjang!");
                                }
                              },
                              child: Text(
                                'Tambahkan Ke Keranjang',
                                style: session.kBodyText
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )),
                  ]),
                  SizedBox(height: 30)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
