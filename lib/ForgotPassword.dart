import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ForgotPassword extends StatefulWidget {
  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController otp = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  TextEditingController konfir = new TextEditingController();
  TextEditingController email = new TextEditingController();
  int mode = 0;

  void kirimEmail() async {
    Map paramData = {'email': email.text};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/kirim-email-verifikasi"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      Fluttertoast.showToast(
          msg: "Kode Verifikasi telah dikirimkan ke email anda");
    }).catchError((err) {
      print(err);
    });
  }

  void konfirOTP() async {
    Map paramData = {
      'otp': otp.text,
      'pass': pass.text,
      'confirm': konfir.text,
      'email': email.text
    };
    var parameter = json.encode(paramData);
    if (otp.text == "" ||
        pass.text == "" ||
        konfir.text == "" ||
        email.text == "") {
      Fluttertoast.showToast(msg: "Inputan tidak boleh kosong");
    } else {
      if (pass.text == konfir.text) {
        http
            .post(Uri.parse(session.ipnumber + '/resetPassword'),
                headers: {'Content-Type': "application/json"}, body: parameter)
            .then((res) {
          var data = json.decode(res.body);
          data = data[0]['pesan'];
          if (data == "gagal") {
            Fluttertoast.showToast(msg: "Kode Verifikasi tidak valid");
          } else {
            Fluttertoast.showToast(msg: "Berhasil atur ulang kata sandi");
            Navigator.pushNamed(context, "/");
          }
        }).catchError((err) {
          print(err);
        });
      } else {
        Fluttertoast.showToast(
            msg: "Password & Konfirmasi Password tidak sama");
      }
    }
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
                      image: AssetImage('assets/images/forgotpassword.jpg'),
                      fit: BoxFit.cover,
                      colorFilter:
                          ColorFilter.mode(Colors.black54, BlendMode.darken))),
            )),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(
            children: [
              SizedBox(height: 25),
              Center(
                  child: Center(
                      child: Text(
                'Lupa Password',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ))),
              SizedBox(height: 5),
              mode == 0
                  ? Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            size.width * 0.1, 50, size.width * 0.1, 0),
                        child: Container(
                            height: size.height * 0.3,
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16)),
                            child: Center(
                                child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(size.width * 0.1,
                                      30, size.width * 0.1, 0),
                                  child: Container(
                                      height: size.height * 0.08,
                                      width: size.width * 0.8,
                                      decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Center(
                                        child: TextField(
                                          controller: email,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.0),
                                              ),
                                              hintText: "Email",
                                              hintStyle: session.kBodyText),
                                          style: session.kBodyText,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.done,
                                        ),
                                      )),
                                ),
                                SizedBox(height: 15),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      size.width * 0.1, 0, size.width * 0.1, 0),
                                  child: Container(
                                      height: size.height * 0.08,
                                      width: size.width * 0.8,
                                      child: Center(
                                        child: Container(
                                          height: size.height * 0.08,
                                          width: size.width * 0.8,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: session.kBlue),
                                          child: FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                mode = 1;
                                                kirimEmail();
                                              });
                                            },
                                            child: Text(
                                              'Kirim Email',
                                              style: session.kBodyText.copyWith(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      )),
                                )
                              ],
                            ))),
                      ),
                    )
                  : Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            size.width * 0.1, 50, size.width * 0.1, 0),
                        child: Container(
                            height: size.height * 0.5,
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16)),
                            child: Center(
                                child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(size.width * 0.1,
                                      30, size.width * 0.1, 0),
                                  child: Container(
                                      height: size.height * 0.08,
                                      width: size.width * 0.8,
                                      decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Center(
                                        child: TextField(
                                          controller: otp,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.0),
                                              ),
                                              hintText: "Kode Verifikasi",
                                              hintStyle: session.kBodyText),
                                          style: session.kBodyText,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.done,
                                        ),
                                      )),
                                ),
                                SizedBox(height: 15),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(size.width * 0.1,
                                      30, size.width * 0.1, 0),
                                  child: Container(
                                      height: size.height * 0.08,
                                      width: size.width * 0.8,
                                      decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Center(
                                        child: TextField(
                                          obscureText: true,
                                          autofocus: false,
                                          controller: pass,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.0),
                                              ),
                                              hintText: "Password Baru",
                                              hintStyle: session.kBodyText),
                                          style: session.kBodyText,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.done,
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(size.width * 0.1,
                                      10, size.width * 0.1, 0),
                                  child: Container(
                                      height: size.height * 0.08,
                                      width: size.width * 0.8,
                                      decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Center(
                                        child: TextField(
                                          obscureText: true,
                                          autofocus: false,
                                          controller: konfir,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.0),
                                              ),
                                              hintText: "Konfirmasi Password",
                                              hintStyle: session.kBodyText),
                                          style: session.kBodyText,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.done,
                                        ),
                                      )),
                                ),
                                SizedBox(height: 15),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      size.width * 0.1, 0, size.width * 0.1, 0),
                                  child: Container(
                                      height: size.height * 0.08,
                                      width: size.width * 0.8,
                                      child: Center(
                                        child: Container(
                                          height: size.height * 0.08,
                                          width: size.width * 0.8,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: session.kBlue),
                                          child: FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                konfirOTP();
                                              });
                                            },
                                            child: Text(
                                              'Reset Password',
                                              style: session.kBodyText.copyWith(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      )),
                                )
                              ],
                            ))),
                      ),
                    )
            ],
          ),
        )
      ],
    );
  }
}
