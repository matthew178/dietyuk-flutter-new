import 'ClassProduk.dart';
import 'session.dart';
import 'shoppingcart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'session.dart' as session;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'chat.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  FirebaseFirestore _firestore;
  FirebaseMessaging _firebaseMessaging;
  String tokenKu;

  TextEditingController myUsername = new TextEditingController();
  TextEditingController myPassword = new TextEditingController();
  SharedPreferences preference;
  String user = "0", role = "", berat = "0", status = "0";

  takeFirebase() async {
    await Firebase.initializeApp();
    _firestore = FirebaseFirestore.instance;
    _firebaseMessaging = FirebaseMessaging.instance;
    firebaseCloudMessaging_Listeners();
    loadUser();
  }

  @override
  void initState() {
    super.initState();
    takeFirebase();
  }

  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.getToken().then((token) {
      print("token di home dart = " + token);
      tokenKu = token;
      FirebaseFirestore.instance
          .collection("chatting")
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((f) {});
      });
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('on message $message');
    });
  }

  void loadUser() async {
    selesaikanTransaksi();
    preference = await SharedPreferences.getInstance();
    user = preference.getString("user") ?? "0";
    role = preference.getString("role") ?? "";
    berat = preference.getString("berat") ?? "0";
    status = preference.getString("status") ?? "Tidak Aktif";
    session.userlogin = int.parse(user);
    session.role = role;
    session.berat = int.parse(berat);
    if (role != "") {
      if (role == "member") {
        var temp = jsonDecode(
            preference.getString('cart' + session.userlogin.toString()) ??
                "[]");
        for (var i = 0; i < temp.length; i++) {
          session.Cart.add(new shoppingcart(
              temp[i]["kodeproduk"].toString(),
              temp[i]["username"].toString(),
              temp[i]["jumlah"].toString(),
              temp[i]["konsultan"].toString(),
              temp[i]["harga"].toString()));
        }
        print("jumlah cart : " + session.Cart.length.toString());
        getProdukCart();
        Navigator.of(this.context).pushNamedAndRemoveUntil(
            '/member', (Route<dynamic> route) => false);
      } else if (role == "konsultan") {
        Navigator.of(this.context).pushNamedAndRemoveUntil(
            '/konsultan', (Route<dynamic> route) => false);
      }
    }
  }

  void selesaikanTransaksi() async {
    Map paramData = {};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/selesaikanTransaksi"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {})
        .catchError((err) {
      print(err);
    });
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

  Future<String> evtLogin() async {
    selesaikanTransaksi();
    preference = await SharedPreferences.getInstance();
    Map paramData = {
      'username': myUsername.text,
      'password': myPassword.text,
      'token': tokenKu
    };
    var parameter = json.encode(paramData);
    if (myUsername.text == "" || myPassword.text == "") {
      Fluttertoast.showToast(msg: "Inputan tidak boleh kosong");
    } else {
      http
          .post(Uri.parse(session.ipnumber + "/login"),
              headers: {"Content-Type": "application/json"}, body: parameter)
          .then((res) {
        if (res.body.contains("sukses")) {
          var data = json.decode(res.body);
          session.userlogin = data[0]['id'];
          session.role = data[0]['role'];
          session.status = data[0]['status'];
          preference.setString("user", data[0]['id'].toString());
          preference.setString("role", data[0]['role']);
          preference.setString("berat", data[0]['berat']);
          preference.setString("status", data[0]['status']);

          if (data[0]['status'] == "Aktif") {
            // kalau berhasil login maka updateTokenFirebase ke mysql

            if (data[0]['role'] == "member") {
              var temp = jsonDecode(
                  preference.getString('cart' + session.userlogin.toString()) ??
                      "[]");
              for (var i = 0; i < temp.length; i++) {
                session.Cart.add(new shoppingcart(
                    temp[i]["kodeproduk"].toString(),
                    temp[i]["username"].toString(),
                    temp[i]["jumlah"].toString(),
                    temp[i]["konsultan"].toString(),
                    temp[i]["harga"].toString()));
              }
              print("jumlah cart : " + session.Cart.length.toString());
              getProdukCart();
              Fluttertoast.showToast(msg: "Berhasil Login");
              Navigator.pushNamed(this.context, "/member");
            } else if (data[0]['role'] == "konsultan") {
              Navigator.pushNamed(this.context, "/konsultan");
            }
          } else if (data[0]['status'] == "Tidak Aktif" &&
              data[0]['role'] == "konsultan") {
            // Fluttertoast.showToast(
            //     msg: "Akun anda di blok. Silahkan hubungi admin");
            Navigator.pushNamed(this.context, "/konsultan");
          } else if (data[0]['status'] == "Tidak Aktif" &&
              data[0]['role'] == "member") {
            Fluttertoast.showToast(
                msg: "Akun anda di blok. Silahkan hubungi admin");
          } else {
            Fluttertoast.showToast(msg: "Akun anda belum aktif");
          }
        } else {
          Fluttertoast.showToast(msg: "Gagal Login");
        }
      }).catchError((err) {
        print(err);
      });
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        ShaderMask(
            shaderCallback: (rect) => LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [Colors.black, Colors.transparent]).createShader(rect),
            blendMode: BlendMode.darken,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/loginpage.png'),
                      fit: BoxFit.cover,
                      colorFilter:
                          ColorFilter.mode(Colors.black54, BlendMode.darken))),
            )),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Flexible(
                  child: Center(
                      child: Text(
                'Dietyuk!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold),
              ))),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                    height: size.height * 0.08,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.grey[500].withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(
                      child: TextField(
                        autofocus: false,
                        controller: myUsername,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Icon(
                                Icons.person,
                                size: 28,
                                color: kWhite,
                              ),
                            ),
                            hintText: "Username/email",
                            hintStyle: kBodyText),
                        style: kBodyText,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                    height: size.height * 0.08,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.grey[500].withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(
                      child: TextField(
                        controller: myPassword,
                        obscureText: true,
                        autofocus: false,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Icon(
                                Icons.lock,
                                size: 28,
                                color: kWhite,
                              ),
                            ),
                            hintText: "Kata Sandi",
                            hintStyle: kBodyText),
                        style: kBodyText,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                      ),
                    )),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/lupapassword'),
                child: Container(
                  child: Text(
                    'Lupa Password ?',
                    style: kecil,
                  ),
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(width: 1, color: kWhite))),
                ),
              ),
              SizedBox(height: size.height / 28),
              Container(
                height: size.height * 0.08,
                width: size.width * 0.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16), color: kBlue),
                child: FlatButton(
                  onPressed: () {
                    evtLogin();
                  },
                  child: Text(
                    'Masuk',
                    style: kBodyText.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: size.height / 28),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/register'),
                child: Container(
                  child: Text(
                    'Buat Akun Baru',
                    style: kBodyText,
                  ),
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(width: 1, color: kWhite))),
                ),
              ),
              SizedBox(height: size.height / 28)
            ],
          ),
        )
      ],
    );
  }
}
