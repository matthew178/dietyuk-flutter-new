import 'ClassAlamat.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'ClassUser.dart';
import 'package:imagebutton/imagebutton.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

class Myprofile extends StatefulWidget {
  @override
  MyprofileState createState() => MyprofileState();
}

class MyprofileState extends State<Myprofile> {
  String foto = session.ipnumber + "/gambar/wanita.png";
  ClassUser userprofile = new ClassUser(
      "", "", "", "", "", "", "", "", "", "", "", "", "0", "", "", "", "");
  TextEditingController tanggalawal = new TextEditingController();
  TextEditingController tanggalakhir = new TextEditingController();
  DateTime tglawal = new DateTime.now();
  DateTime tglakhir = new DateTime.now();
  bool _like = false, like2 = false;

  void initState() {
    super.initState();
    getProfile();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: tglawal,
        firstDate: DateTime.now(),
        lastDate: DateTime(2050, 12));
    //lastDate: DateTime( .year, date.month - 1, date.day));
    if (picked != null && picked != tglawal)
      setState(() {
        tglawal = picked;
        tanggalawal.text = tglawal.toString().substring(0, 10);
      });
  }

  Future<Null> pilihTanggalAkhir(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: tglakhir,
        firstDate: DateTime.now(),
        lastDate: DateTime(2050, 12));
    //lastDate: DateTime( .year, date.month - 1, date.day));
    if (picked != null && picked != tglakhir)
      setState(() {
        tglakhir = picked;
        tanggalakhir.text = tglakhir.toString().substring(0, 10);
      });
  }

  Future<String> tambahLibur() async {
    Map paramData = {
      'id': session.userlogin,
      'awal': tanggalawal.text,
      'akhir': tanggalakhir.text
    };
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/tambahLibur"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      var data = json.decode(res.body);
      data = data[0]['status'];
      Fluttertoast.showToast(msg: data);
    }).catchError((err) {
      print(err);
    });
  }

  void showAlert() {
    AlertDialog dialog = new AlertDialog(
      content: new Container(
        width: 260.0,
        height: 250,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // new Expanded(child: new Center(child: new Text("Tambah Libur"))),
            new Expanded(
              child: Column(
                children: [
                  SizedBox(width: 30),
                  Padding(
                    padding: EdgeInsets.only(left: 0, right: 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Center(
                            child: TextFormField(
                              controller: tanggalawal,
                              decoration:
                                  InputDecoration(labelText: 'Tanggal Awal'),
                              style: TextStyle(
                                letterSpacing: 1.0,
                              ),
                              enabled: false,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: Container(
                                  margin:
                                      EdgeInsets.fromLTRB(0.0, 20.0, 0.0, .0),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(0),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            blurRadius: 5,
                                            spreadRadius: 1)
                                      ]),
                                  child: Icon(
                                    Icons.date_range,
                                    size: 28,
                                    color:
                                        (_like) ? Colors.red : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.only(left: 0, right: 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Center(
                            child: TextFormField(
                              controller: tanggalakhir,
                              decoration:
                                  InputDecoration(labelText: 'Tanggal Akhir'),
                              style: TextStyle(
                                letterSpacing: 1.0,
                              ),
                              enabled: false,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  pilihTanggalAkhir(context);
                                },
                                child: Container(
                                  margin:
                                      EdgeInsets.fromLTRB(0.0, 20.0, 0.0, .0),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(0),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            blurRadius: 5,
                                            spreadRadius: 1)
                                      ]),
                                  child: Icon(
                                    Icons.date_range,
                                    size: 28,
                                    color:
                                        (like2) ? Colors.red : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  Container(
                    child: new RaisedButton(
                      onPressed: () {
                        tambahLibur();
                        Navigator.of(context, rootNavigator: true).pop(true);
                      },
                      padding: new EdgeInsets.all(16.0),
                      color: Colors.blue,
                      child: new Text(
                        'Tambah Libur',
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
          data[0]["provinsi"].toString(),
          data[0]["kota"].toString());
      setState(() => this.userprofile = userlog);
      print("foto : " + userprofile.foto);
      if (userprofile.jeniskelamin == "pria" && userprofile.foto == "pria.png")
        foto = session.ipnumber + "/gambar/pria.jpg";
      else if (userprofile.jeniskelamin == "wanita" &&
          userprofile.foto == "wanita.png")
        foto = session.ipnumber + "/gambar/wanita.png";
      else
        foto = session.ipnumber + "/gambar/" + userprofile.foto;
      return userlog;
    }).catchError((err) {
      print(err);
    });
  }

  Widget cetakbintang(x, y) {
    if (x <= y) {
      return Image.asset("assets/images/bfull.png",
          width: 20, height: 20, fit: BoxFit.cover);
    } else if (x > y && x < y + 1) {
      return Image.asset("assets/images/bstengah.png",
          width: 20, height: 20, fit: BoxFit.cover);
    } else {
      return Image.asset("assets/images/bkosong.png",
          width: 20, height: 20, fit: BoxFit.cover);
    }
  }

  void evtLogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("user");
    pref.remove("role");
    String data = jsonEncode(session.Cart);
    pref.setString(("cart" + session.userlogin.toString()), data);
    session.Cart.clear();
    session.alamat = new ClassAlamat("0", "", "", "", "", "", "", "", "");
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Profile Page"),
    //     backgroundColor: session.warna,
    //   ),
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: <Widget>[
    //         SizedBox(height: 50),
    //         ClipRRect(
    //           borderRadius: BorderRadius.circular(100.0),
    //           child: Image.network(
    //             this.foto,
    //             width: 150,
    //             height: 150,
    //             fit: BoxFit.cover,
    //           ),
    //         ),
    //         Container(
    //           padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
    //           child: Center(
    //               child: Text(
    //             "@" + userprofile.username,
    //             style: TextStyle(color: Colors.grey, fontSize: 15),
    //           )),
    //         ),
    //         Container(
    //           padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
    //           child: Center(
    //               child: Text(
    //             userprofile.nama,
    //             style: TextStyle(fontSize: 20),
    //           )),
    //         ),
    //         Container(
    //           padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
    //           child: Center(
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 cetakbintang(1, double.parse(userprofile.rating)),
    //                 cetakbintang(2, double.parse(userprofile.rating)),
    //                 cetakbintang(3, double.parse(userprofile.rating)),
    //                 cetakbintang(4, double.parse(userprofile.rating)),
    //                 cetakbintang(5, double.parse(userprofile.rating))
    //               ],
    //             ),
    //           ),
    //         ),
    //         Container(
    //           padding: EdgeInsets.fromLTRB(20, 30, 10, 30),
    //           margin: EdgeInsets.all(15.0),
    //           decoration:
    //               BoxDecoration(border: Border.all(color: Colors.black)),
    //           child: Row(
    //             children: [
    //               Expanded(
    //                 flex: 1,
    //                 child: Column(
    //                   children: [
    //                     Container(
    //                       padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
    //                       child: Center(
    //                         child: Text("Berat",
    //                             style: TextStyle(
    //                                 color: Colors.grey, fontSize: 15)),
    //                       ),
    //                     ),
    //                     Container(
    //                       child: Center(
    //                         child: Text(userprofile.berat + " kg",
    //                             style: TextStyle(
    //                                 color: Colors.black, fontSize: 20)),
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //               Expanded(
    //                 flex: 1,
    //                 child: Column(
    //                   children: [
    //                     Container(
    //                       padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
    //                       child: Center(
    //                         child: Text("Tinggi",
    //                             style: TextStyle(
    //                                 color: Colors.grey, fontSize: 15)),
    //                       ),
    //                     ),
    //                     Container(
    //                       child: Center(
    //                         child: Text(userprofile.tinggi + " cm",
    //                             style: TextStyle(
    //                                 color: Colors.black, fontSize: 20)),
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Container(
    //           padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
    //           child: Center(
    //               child: Text(
    //             "Rp. " + userprofile.saldo,
    //             style: TextStyle(color: Colors.black, fontSize: 20),
    //           )),
    //         ),
    //         Container(
    //           padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
    //           child: Center(
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 IconButton(
    //                   icon: Image.asset('assets/images/edit.png'),
    //                   iconSize: 50,
    //                   padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
    //                   onPressed: () {
    //                     Navigator.pushNamed(context, "/editprofile");
    //                   },
    //                 ),
    //                 IconButton(
    //                   icon: Image.asset('assets/images/saldo.png'),
    //                   iconSize: 50,
    //                   padding: EdgeInsets.fromLTRB(75, 0, 75, 0),
    //                   onPressed: () {
    //                     Navigator.pushNamed(context, "/saldo");
    //                   },
    //                 ),
    //                 IconButton(
    //                   icon: Image.asset('assets/images/withdraw.png'),
    //                   iconSize: 50,
    //                   padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
    //                   onPressed: () {},
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [HexColor("#1b4965"), HexColor("#62b6cb")],
                      begin: FractionalOffset.bottomCenter,
                      end: FractionalOffset.topCenter)),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 34),
                  child: Column(
                    children: [
                      Text(
                        "My\nProfile",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            // fontWeight: FontWeight.bold,
                            fontFamily: 'Nisebuschgardens'),
                      ),
                      SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     IconButton(
                      //       onPressed: () {},
                      //       icon: Icon(
                      //         AntDesign.arrowleft,
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //     IconButton(
                      //       onPressed: () {
                      //         evtLogout();
                      //       },
                      //       icon: Icon(
                      //         AntDesign.logout,
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      Container(
                        height: size.height * 0.45,
                        child: LayoutBuilder(builder: (context, constraints) {
                          double innerHeight = constraints.maxHeight;
                          double innerWidth = constraints.maxWidth;
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: innerHeight * 0.75,
                                  width: innerWidth,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 80),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Text(
                                                userprofile.nama,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        128, 101, 22, 1),
                                                    fontSize: 20),
                                              ),
                                            ),
                                            // Container(
                                            //   child: IconButton(
                                            //     onPressed: () {
                                            //       Navigator.pushNamed(
                                            //           context, "/editprofile");
                                            //     },
                                            //     icon: Icon(AntDesign.edit,
                                            //         size: 20,
                                            //         color: Colors.yellow[900]),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 10, 10, 0),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              cetakbintang(
                                                  1,
                                                  double.parse(
                                                      userprofile.rating)),
                                              cetakbintang(
                                                  2,
                                                  double.parse(
                                                      userprofile.rating)),
                                              cetakbintang(
                                                  3,
                                                  double.parse(
                                                      userprofile.rating)),
                                              cetakbintang(
                                                  4,
                                                  double.parse(
                                                      userprofile.rating)),
                                              cetakbintang(
                                                  5,
                                                  double.parse(
                                                      userprofile.rating))
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'Tinggi',
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                userprofile.tinggi + " cm",
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        128, 101, 22, 1),
                                                    fontSize: 20),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8),
                                            child: Container(
                                              height: 50,
                                              width: 5,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Berat',
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                userprofile.berat + " kg",
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        128, 101, 22, 1),
                                                    fontSize: 20),
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: SizedBox(
                                      height: 115,
                                      width: 115,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        overflow: Overflow.visible,
                                        children: [
                                          Container(
                                            child: CircleAvatar(
                                              // borderRadius:
                                              //     BorderRadius.circular(100.0),
                                              radius: 75,
                                              // child: Image.network(
                                              //   this.foto,
                                              //   width: 150,
                                              //   height: 150,
                                              //   fit: BoxFit.cover,
                                              // ),
                                              backgroundImage:
                                                  NetworkImage(this.foto),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                          ),
                                          // Positioned(
                                          //   bottom: 0,
                                          //   right: -10,
                                          //   child: SizedBox(
                                          //     height: 46,
                                          //     width: 46,
                                          //     child: FlatButton(
                                          //         padding: EdgeInsets.zero,
                                          //         shape: RoundedRectangleBorder(
                                          //             borderRadius:
                                          //                 BorderRadius.circular(
                                          //                     50),
                                          //             side: BorderSide(
                                          //                 color: Colors.white)),
                                          //         color: Color(0xFFF5F6F9),
                                          //         onPressed: () {
                                          //           Navigator.pushNamed(context,
                                          //               "/editprofile");
                                          //         },
                                          //         child: Icon(
                                          //           AntDesign.edit,
                                          //         )),
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          );
                        }),
                      ),
                      SizedBox(height: 20),
                      Container(
                          child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: FlatButton(
                                padding: EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.pushNamed(context, "/editprofile");
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      AntDesign.edit,
                                      size: 22,
                                      color: Colors.yellow[900],
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                        child: Text("Edit Profile",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1)),
                                    Icon(Icons.arrow_forward_ios)
                                  ],
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: FlatButton(
                                padding: EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.pushNamed(context, "/saldo");
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      AntDesign.wallet,
                                      size: 22,
                                      color: Colors.yellow[900],
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                        child: Text("Dompet Saya",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1)),
                                    Icon(Icons.arrow_forward_ios)
                                  ],
                                )),
                          ),
                          session.role == "konsultan"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: FlatButton(
                                      padding: EdgeInsets.all(20),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      color: Colors.white,
                                      onPressed: () {
                                        // Navigator.pushNamed(
                                        //     this.context, "/tambahlibur");
                                        showAlert();
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            AntDesign.calendar,
                                            size: 22,
                                            color: Colors.yellow[900],
                                          ),
                                          SizedBox(width: 20),
                                          Expanded(
                                              child: Text("Tambah Libur",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1)),
                                          Icon(Icons.arrow_forward_ios)
                                        ],
                                      )),
                                )
                              : SizedBox(height: 0),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: FlatButton(
                                padding: EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                color: Colors.white,
                                onPressed: () {
                                  evtLogout();
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      AntDesign.logout,
                                      size: 22,
                                      color: Colors.yellow[900],
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                        child: Text("Logout",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1)),
                                    Icon(Icons.arrow_forward_ios)
                                  ],
                                )),
                          )
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
