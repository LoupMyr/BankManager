import 'dart:async';

import 'package:bank_tracker/class/depensePerCategories.dart';
import 'package:bank_tracker/class/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:bank_tracker/class/tools.dart';
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

class DetailsMoisPage extends StatefulWidget {
  const DetailsMoisPage({super.key, required this.title});
  final String title;

  @override
  State<DetailsMoisPage> createState() => DetailsMoisPageState();
}

class DetailsMoisPageState extends State<DetailsMoisPage> {
  Tools _tools = Tools();
  int _idMois = -1;
  var _depenses;
  var _categories;
  double _total = 0;
  String _date = '';
  List<TotalPerCategories> _list = List.empty(growable: true);

  Future<String> recupDepenses() async {
    var responseD = await _tools.getDepenses();
    var responseC = await _tools.getCategories();
    if (responseD.statusCode == 200 && responseC.statusCode == 200) {
      _depenses = convert.jsonDecode(responseD.body);
      _categories = convert.jsonDecode(responseC.body);
      createTab();
    }
    return '';
  }

  void createTab() {
    List<dynamic> tabEltMois = List.empty(growable: true);
    for (var elt in _depenses['hydra:member']) {
      int moisElt = int.parse(
          DateFormat('MM').format(DateTime.parse(elt['datePaiement'])));
      if (moisElt == _idMois) {
        _date = DateFormat('MM-yy').format(DateTime.parse(elt['datePaiement']));
        _total = _total + double.parse(elt['montant'].toString());
        tabEltMois.add(elt);
      }
    }
    for (var c in _categories['hydra:member']) {
      double totalCategorie = 0;
      for (var elt in tabEltMois) {
        List<String> temp = elt['categorieActivite'].split('/');
        String idCategorie = temp[temp.length - 1];
        if (c['id'].toString() == idCategorie) {
          totalCategorie =
              totalCategorie + double.parse(elt['montant'].toString());
        }
      }
      if (totalCategorie > 0) {
        _list.add(TotalPerCategories(c['libelle'], totalCategorie));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _idMois = ModalRoute.of(context)!.settings.arguments as int;
    return FutureBuilder(
        future: recupDepenses(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = [
              const Padding(padding: EdgeInsets.only(top: 30)),
              SfCircularChart(
                  annotations: <CircularChartAnnotation>[
                    CircularChartAnnotation(
                      widget: SizedBox(
                        child: Text(_date,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ),
                    )
                  ],
                  legend: Legend(
                      isVisible: true,
                      position: LegendPosition.bottom,
                      shouldAlwaysShowScrollbar: true,
                      orientation: LegendItemOrientation.vertical,
                      height: '100'),
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    builder: (data, point, series, pointIndex, seriesIndex) {
                      return Padding(
                          padding: const EdgeInsets.all(5),
                          child: SizedBox(
                            child: Text('${data.getPhraseBuilder()}',
                                style: const TextStyle(color: Colors.white)),
                          ));
                    },
                  ),
                  series: <CircularSeries<TotalPerCategories, String>>[
                    DoughnutSeries<TotalPerCategories, String>(
                      dataSource: _list,
                      xValueMapper: (TotalPerCategories data, index) =>
                          data.getCategorie(),
                      yValueMapper: (TotalPerCategories data, index) =>
                          data.getTotal(),
                      dataLabelMapper: (data, index) => '${data.getTotal()}',
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          labelPosition: ChartDataLabelPosition.outside,
                          textStyle: TextStyle(fontWeight: FontWeight.bold)),
                      radius: '75',
                    )
                  ]),
            ];
          } else if (snapshot.hasError) {
            children = [
              const Icon(Icons.error_outline, color: Colors.red),
            ];
          } else {
            children = [
              SpinKitChasingDots(size: 150, color: Colors.red.shade400),
            ];
          }
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(widget.title),
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            drawer: Widgets.createDrawer(context),
            body: Column(children: children),
          );
        });
  }
}
