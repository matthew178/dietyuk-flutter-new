import 'Topup2.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'ClassUser.dart';
import 'ClassBank.dart';
import 'package:intl/intl.dart';

class Withdrawsaldo extends StatefulWidget {
  @override
  WithdrawsaldoState createState() => WithdrawsaldoState();
}

class WithdrawsaldoState extends State<Withdrawsaldo> {
  TextEditingController saldo = new TextEditingController();
  List<ClassBank> arrBank = new List();
  ClassBank bankyangdipilih = null;
  NumberFormat fmrt = new NumberFormat(",000");
  TextEditingController nominaltopup = new TextEditingController();
  TextEditingController atasnama = new TextEditingController();
  TextEditingController norek = new TextEditingController();

  ClassUser userprofile = new ClassUser(
      "", "", "", "", "", "", "", "", "", "", "", "", "0", "", "", "", "");

  void initState() {
    super.initState();
    getProfile();
    arrBank.add(new ClassBank("", "", "", ""));
    arrBank.add(new ClassBank("BNI", "8712998210", "assets/images/bni.jpg",
        "Matthew Hendry Sudarto"));
    arrBank.add(new ClassBank(
        "BCA", "731287821", "assets/images/bca.png", "Matthew Hendry Sudarto"));
    arrBank.add(new ClassBank("Mandiri", "31312231",
        "assets/images/mandiri.png", "Matthew Hendry Sudarto"));
  }

  void kirimRequestPenarikan() async {
    Map paramData = {
      'bank': bankyangdipilih.nama,
      'nominal': nominaltopup.text,
      'atasnama': atasnama.text,
      'norek': norek.text,
      'username': session.userlogin
    };
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/kirimReqPenarikan"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {})
        .catchError((err) {
      print(err);
    });
  }

  Future<ClassUser> getProfile() async {
    ClassUser userlog = new ClassUser(
        "", "", "", "", "", "", "", "", "", "", "", "", "0", "", "", "", "");
    Map paramData = {'id': session.userlogin};
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
          "",
          "");
      setState(() => this.userprofile = userlog);
      return userlog;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("PENARIKAN SALDO"),
        backgroundColor: session.warna,
      ),
      body: Center(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(15)),
                child: SizedBox(
                  height: 50,
                  width: 200,
                  child: DropdownButton<ClassBank>(
                    // style: Theme.of(context).textTheme.title,
                    hint: Text("Pilih Bank"),
                    value: bankyangdipilih,
                    onChanged: (ClassBank Value) {
                      setState(() {
                        bankyangdipilih = Value;
                      });
                    },
                    items: arrBank.map((ClassBank bank) {
                      return DropdownMenuItem<ClassBank>(
                        value: bank,
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 5,
                            ),
                            bank.foto != ""
                                ? SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Image.asset(
                                      bank.foto,
                                      fit: BoxFit.contain,
                                    ))
                                : SizedBox(
                                    height: 50,
                                    width: 50,
                                  ),
                            SizedBox(
                              width: 10,
                            ),
                            new Text(bank.nama)
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  height: 50,
                  // width: 200,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: nominaltopup,
                    decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintText: "Nominal Penarikan",
                        hintStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                  ),
                )),
            Container(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  height: 50,
                  // width: 200,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: norek,
                    decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintText: "Nomor Rekening",
                        hintStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                  ),
                )),
            Container(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  height: 50,
                  // width: 200,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: atasnama,
                    decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintText: "Atas Nama",
                        hintStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                )),
            SizedBox(height: 30),
            Container(
                child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.08,
                // width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: session.kBlue),
                child: FlatButton(
                  onPressed: () {
                    if (nominaltopup.text != "" &&
                        bankyangdipilih.nama != "" &&
                        atasnama.text != "" &&
                        norek.text != "") {
                      if (int.parse(nominaltopup.text) >= 20000) {
                        if (int.parse(userprofile.saldo) >
                            int.parse(nominaltopup.text)) {
                          kirimRequestPenarikan();
                          Fluttertoast.showToast(
                              msg: "Permintaan penarikan akan diproses admin");
                          if (session.role == "member") {
                            Navigator.pushNamed(this.context, "/member");
                          } else if (session.role == "konsultan") {
                            Navigator.pushNamed(this.context, "/konsultan");
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  "Saldo anda tidak cukup untuk melakukan penarikan");
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                "Mohon maaf, anda tidak bisa melakukan penarikan dibawah Rp. 20.000");
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              "Mohon pilih bank dan mengisi nominal penarikan, nomor rekening beserta nama pemilik rekening");
                    }
                  },
                  child: Text(
                    'Submit',
                    style:
                        session.kBodyText.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
