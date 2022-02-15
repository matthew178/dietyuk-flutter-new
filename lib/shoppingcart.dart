import 'ClassProduk.dart';
import 'dart:convert';

class shoppingcart {
  String kodeproduk, username, jumlah, konsultan, harga;
  ClassProduk produkini;

  shoppingcart(
      this.kodeproduk, this.username, this.jumlah, this.konsultan, this.harga);

  shoppingcart.fromJson(Map<String, dynamic> json)
      : kodeproduk = json['kodeproduk'],
        username = json['username'],
        jumlah = json['jumlah'],
        konsultan = json['konsultan'],
        harga = json['harga'];

  Map toJson() => {
        'kodeproduk': kodeproduk,
        'username': username,
        'jumlah': jumlah,
        'konsultan': konsultan,
        'harga': harga
      };

  // static List<shoppingcart> decode(String cart)=>(json.decode(cart) as List<dynamic>).map<shoppingcart>((item) => shoppingcart.fromJson(item).));
}
