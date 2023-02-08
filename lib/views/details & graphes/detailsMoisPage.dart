import 'dart:async';
import 'package:bank_tracker/class/depensePerCategories.dart';
import 'package:bank_tracker/class/widgets.dart';
import 'package:bank_tracker/class/strings.dart';
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
  final Tools _tools = Tools();
  int _idMois = -1;
  var _depenses;
  var _categories;
  String _date = '';
  bool _hasDataBool = false;
  bool _createOnce = false;
  final List<TotalPerCategories> _list = List.empty(growable: true);
  ListView _listView = ListView(
    shrinkWrap: true,
    children: const [
      Text('Sélectionner une catégorie pour plus d\'information.')
    ],
  );

  Future<String> recupDepenses() async {
    _depenses = await _tools.getDepensesByUserID();
    var responseC = await _tools.getCategories();
    if (responseC.statusCode == 200) {
      _categories = convert.jsonDecode(responseC.body);
      _hasDataBool = true;
      createTab();
      _createOnce = true;
    }
    return '';
  }

  void createTab() {
    _list.clear();
    List<dynamic> tabEltMois = List.empty(growable: true);
    for (var elt in _depenses) {
      int moisElt = int.parse(
          DateFormat('MM').format(DateTime.parse(elt['datePaiement'])));
      if (moisElt == _idMois) {
        _date = DateFormat('MM-yy').format(DateTime.parse(elt['datePaiement']));
        tabEltMois.add(elt);
      }
    }
    for (var c in _categories['hydra:member']) {
      double totalCategorie = 0;
      List<dynamic> depenses = List.empty(growable: true);
      for (var elt in tabEltMois) {
        List<String> temp = elt['categorieActivite'].split('/');
        String idCategorie = temp[temp.length - 1];
        if (c['id'].toString() == idCategorie) {
          totalCategorie =
              totalCategorie + double.parse(elt['montant'].toString());
          String? remarques;
          try {
            remarques = elt['remarques'];
          } catch (e) {}
          List<String> tempUser = elt['user'].split('/');
          String idUser = temp[temp.length - 1];
          depenses.add(elt);
        }
      }
      if (totalCategorie > 0) {
        _list.add(TotalPerCategories(c['libelle'], totalCategorie, depenses));
      }
    }
  }

  void updateColumn(TotalPerCategories categorie) {
    List<Widget> tabChildren = List.empty(growable: true);
    for (var depense in categorie.getDepenses()) {
      tabChildren = Widgets.createList(categorie.getDepenses().length,
          categorie.getDepenses(), context, 0.6, 0.5);
    }
    setState(() {
      _listView = ListView(
        shrinkWrap: true,
        children: tabChildren,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _idMois = ModalRoute.of(context)!.settings.arguments as int;
    return FutureBuilder(
        future: recupDepenses(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<Widget> children = List.empty(growable: true);
          if (snapshot.hasData) {
            if (_hasDataBool) {
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
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                          ));
                    },
                  ),
                  series: <CircularSeries<TotalPerCategories, String>>[
                    DoughnutSeries<TotalPerCategories, String>(
                      dataSource: _list,
                      onPointTap: (pointInteractionDetails) {
                        updateColumn(
                            _list[pointInteractionDetails.pointIndex!]);
                      },
                      xValueMapper: (TotalPerCategories data, index) =>
                          data.getCategorie(),
                      yValueMapper: (TotalPerCategories data, index) =>
                          data.getTotal(),
                      dataLabelMapper: (data, index) =>
                          '${data.getTotal().toStringAsFixed(2)}€',
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          labelPosition: ChartDataLabelPosition.outside,
                          textStyle: TextStyle(fontWeight: FontWeight.bold)),
                      radius: '75',
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Column(children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: SingleChildScrollView(
                      child: _listView,
                    ),
                  ),
                ]),
              ];
            } else {
              recupDepenses();
            }
          } else if (snapshot.hasError) {
            children = [
              const Icon(Icons.error_outline, color: Colors.red),
            ];
          } else {
            children = [
              SpinKitChasingDots(size: 150, color: Colors.teal.shade400),
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
            body: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        child: Text(
                      'Détail de vos dépenses de \n${Strings.listMonths[_idMois - 1]}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                    Column(children: children),
                  ]),
            ),
          );
        });
  }
}
