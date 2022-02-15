import 'dart:io';
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
import 'ShowHtmlPage.dart';

class Topup extends StatefulWidget {
  @override
  TopupState createState() => TopupState();
}

class TopupState extends State<Topup> {
  TextEditingController saldo = new TextEditingController();
  List<ClassBank> arrBank = new List();
  ClassBank bankyangdipilih = null;
  NumberFormat fmrt = new NumberFormat(",000");
  TextEditingController nominaltopup = new TextEditingController();

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

  Future<String> evtTopup() async {
    if (bankyangdipilih == null || nominaltopup.text == "") {
      Map paramData = {
        'saldo': nominaltopup.text,
        'id_user': session.userlogin.toString(),
        'bank': bankyangdipilih.nama
      };
      var parameter = json.encode(paramData);
      http
          .post(Uri.parse(session.ipnumber + "/topup"),
              headers: {"Content-Type": "application/json"}, body: parameter)
          .then((res) {
        print(res.body);
      }).catchError((err) {
        print(err);
      });
    }
    return "";
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

  Future openXendit(double amount) async {
    print("masuk open xendit");
    var uname =
        'xnd_development_tU93YGYMu0kc4YrPAipFA0OcAsR2TIvWhprXbRQWduq7Sj6QsvEJq28IMnYCO9x';
    var pword = '';
    var authn = 'Basic ' + base64Encode(utf8.encode('$uname:'));
    print(uname);
    print("-----------------------------------------------------------------");
    print(authn);
    var data = {
      'external_id': "testing",
      'payer_email': "testing@gmail.com",
      'description': 'Top Up Rp. ' + amount.toString(),
      'amount': amount.toString(),
    };
    var res = await http.post(Uri.parse("https://api.xendit.co/v2/invoices"),
        headers: {'Authorization': authn}, body: data);
    if (res.statusCode != 200)
      throw Exception('post error: statusCode= ${res.statusCode}');
    var resData = jsonDecode(res.body);
    print(resData);
    print("invoice url = " + resData["invoice_url"]);
    /*
    databaseReference.child("TopUp/${_userProfile.key}/${resData["id"]}").update({
      'amount': amount,
      'status': "PENDING",
      'url': resData["invoice_url"],
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });
    */
    //launchWebViewExample(resData["invoice_url"].toString());
    //updatesaldo();
    String url = resData["invoice_url"].toString();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowHtmlPage(url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TOP UP SALDO"),
        backgroundColor: session.warna,
      ),
      body: Center(
        child: ListView(
          children: [
            SizedBox(height: 30),
            Container(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Icon(
                        AntDesign.wallet,
                        color: Colors.blue[900],
                        size: 50,
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        "Disarankan untuk menghindari top up antara pukul 21.00 s/d 03.00 dikarenakan adanya cut off mutasi internet banking sehingga proses validasi pembayaran memerlukan waktu yang lama.",
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.justify,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            // Container(
            //   padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            //   child: Container(
            //     padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            //     width: MediaQuery.of(context).size.width,
            //     decoration: BoxDecoration(
            //         border: Border.all(color: Colors.grey, width: 1),
            //         borderRadius: BorderRadius.circular(15)),
            //     child: SizedBox(
            //       height: 50,
            //       width: 200,
            //       child: DropdownButton<ClassBank>(
            //         // style: Theme.of(context).textTheme.title,
            //         hint: Text("Pilih Bank"),
            //         value: bankyangdipilih,
            //         onChanged: (ClassBank Value) {
            //           setState(() {
            //             bankyangdipilih = Value;
            //           });
            //         },
            //         items: arrBank.map((ClassBank bank) {
            //           return DropdownMenuItem<ClassBank>(
            //             value: bank,
            //             child: Row(
            //               children: <Widget>[
            //                 SizedBox(
            //                   width: 5,
            //                 ),
            //                 bank.foto != ""
            //                     ? SizedBox(
            //                         height: 50,
            //                         width: 50,
            //                         child: Image.asset(
            //                           bank.foto,
            //                           fit: BoxFit.contain,
            //                         ))
            //                     : SizedBox(
            //                         height: 50,
            //                         width: 50,
            //                       ),
            //                 SizedBox(
            //                   width: 10,
            //                 ),
            //                 new Text(bank.nama)
            //               ],
            //             ),
            //           );
            //         }).toList(),
            //       ),
            //     ),
            //   ),
            // ),

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
                    // onChanged: (content) {
                    //   if (int.parse(nominaltopup.text) > 999) {
                    //     nominaltopup.text =
                    //         fmrt.format(int.parse(nominaltopup.text));
                    //   }
                    // },
                    controller: nominaltopup,
                    decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintText: "Nominal",
                        hintStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                    keyboardType: TextInputType.number,
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
                    // if (nominaltopup.text != "" && bankyangdipilih.nama != "") {
                    if (nominaltopup.text != "") {
                      if (int.parse(nominaltopup.text) >= 20000) {
                        // evtTopup();
                        openXendit(double.parse(nominaltopup.text.toString()));
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Topup2(
                        //             bank: bankyangdipilih,
                        //             nominal: nominaltopup.text.toString())));
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                "Mohon maaf, anda tidak bisa melakukan TopUp dibawah nominal Rp. 20.000");
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              "Mohon pilih bank dan isi saldo yang akan diTopUp");
                    }
                  },
                  child: Text(
                    'Top Up Saldo',
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
