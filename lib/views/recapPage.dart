import 'package:bank_tracker/class/local.dart';
import 'package:bank_tracker/class/tools.dart';
import 'package:bank_tracker/class/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RecapPage extends StatefulWidget {
  const RecapPage({super.key, required this.title});
  final String title;

  @override
  State<RecapPage> createState() => RecapPageState();
}

class RecapPageState extends State<RecapPage> {
  final Tools _tools = Tools();
  List<dynamic> _list = List.empty(growable: true);
  bool _switchValueCredit = true;
  bool _switchValueDebit = true;
  var _depenses;
  var _rentrees;
  bool _hasRecup = false;

  Future<String> recupInfos() async {
    if (!_hasRecup) {
      _depenses = await _tools.getDepensesByUserID();
      _rentrees = await _tools.getRentreesByUserID();
      _hasRecup = true;
      _list = _depenses + _rentrees;
      if (_list.isNotEmpty) {
        _tools.sortListByDate(_list);
      }
      if (_depenses.isNotEmpty) {
        _tools.sortListByDate(_depenses);
      }
      if (_rentrees.isNotEmpty) {
        _tools.sortListByDate(_rentrees);
      }
    }
    return '';
  }

  List<dynamic> guessList() {
    List<dynamic> tab = List.empty(growable: true);
    if (_switchValueCredit && _switchValueDebit) {
      tab = _list;
    } else if (_switchValueCredit && !_switchValueDebit) {
      tab = _rentrees;
    } else if (!_switchValueCredit && _switchValueDebit) {
      tab = _depenses;
    }
    return tab;
  }

  Widget buildList() {
    List<dynamic> tab = guessList();
    List<Widget> children = List.empty(growable: true);
    if (tab.isNotEmpty) {
      children = Widgets.createList(tab.length, tab, context, 0.6, 0.3);
    } else {
      children = [const Text('Aucun changement enregistré')];
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.7,
      child: ListView(
        shrinkWrap: true,
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: recupInfos(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Column colActivite = Column();
        if (snapshot.hasData) {
          colActivite = Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const <Widget>[
                  Text('Afficher les crédits:'),
                  // Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Text('Afficher les debits:'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Switch(
                    value: _switchValueCredit,
                    onChanged: (value) {
                      setState(() {
                        _switchValueCredit = value;
                      });
                      buildList();
                    },
                  ),
                  Switch(
                    value: _switchValueDebit,
                    onChanged: (value) {
                      setState(() {
                        _switchValueDebit = value;
                      });
                      buildList();
                    },
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
              buildList(),
            ],
          );
        } else if (snapshot.hasError) {
          colActivite = Column(children: const [
            Icon(Icons.error_outline, color: Color.fromARGB(255, 255, 17, 0)),
          ]);
        } else {
          colActivite = Column(children: [
            SpinKitChasingDots(size: 150, color: Colors.teal.shade400),
          ]);
        }
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(widget.title),
          ),
          drawer: Widgets.createDrawer(context),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(child: colActivite),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
