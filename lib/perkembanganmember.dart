import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Perkembanganmember extends StatefulWidget {
  // const perkembanganmember({ Key? key }) : super(key: key);

  @override
  PerkembanganmemberState createState() => PerkembanganmemberState();
}

class PerkembanganmemberState extends State<Perkembanganmember> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SfCartesianChart(),
    ));
  }
}
