import 'dart:async';
import 'package:bank_tracker/class/local.dart';
import 'package:bank_tracker/class/tools.dart';
import 'package:flutter/material.dart';
import 'package:bank_tracker/class/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final Tools _tools = Tools();
  double _solde = -1;
  List<dynamic> _list = List.empty(growable: true);

  Future<void> popUpInfo() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Qu'est ce que Bank Tracker ?",
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                    "Bank Tracker vous permet de faire vos comptes rapidement et facilement et\nd'avoir une vue d'ensemble de vos dépenses simple et intuitive.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Commencer !'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void logout() async {
    Local.storage.deleteAll();
    Navigator.pushReplacementNamed(context, '/routeConnexion');
  }

  Future<String> recupInfos() async {
    String? s = await Local.storage.read(key: 'solde');
    _solde = double.parse(s!);
    _solde = double.parse(_solde.toStringAsFixed(2));
    var depenses = await _tools.getDepensesByUserID();
    var rentrees = await _tools.getRentreesByUserID();
    _list = depenses + rentrees;
    if (_list.isNotEmpty) {
      _list.sort((a, b) {
        return DateTime.parse(b['datePaiement'])
            .compareTo(DateTime.parse(a['datePaiement']));
      });
    }
    return '';
  }

  List<Widget> buildListDepenses() {
    List<Widget> body = List.empty(growable: true);
    List<Widget> children = List.empty(growable: true);
    if (_list.isNotEmpty) {
      int nbIterations = 0;
      if (_list.length >= 5) {
        nbIterations = 5;
      } else {
        nbIterations = _list.length - 1;
      }
      for (int i = 0; i < nbIterations; i++) {
        String remarques = '/';
        String person = '';
        String symbol = '-';
        TextStyle textStyle = const TextStyle(color: Colors.red);
        try {
          remarques = _list[i]['remarques'];
        } catch (e) {}
        if (_list[i]['@type'] == "Rentree") {
          person = _list[i]['crediteur'];
          symbol = '+';
          textStyle = const TextStyle(color: Colors.green);
        } else {
          person = _list[i]['debiteur'];
        }
        children.add(const Divider(
          thickness: 2,
        ));
        children.add(
          ListTile(
            title: Text('$symbol ${_list[i]['montant'].toString()}€',
                style: textStyle),
            subtitle: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(DateFormat('dd-MM-yyyy')
                        .format(DateTime.parse(_list[i]['datePaiement']))),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text(' $person', overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(remarques, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () => Navigator.pushReplacementNamed(
                context, '/routeDetailAction',
                arguments: _list[i]),
          ),
        );
      }
      body = [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.35,
          child: ListView(
            shrinkWrap: true,
            children: children,
          ),
        ),
      ];
    } else {
      body = [
        const SizedBox(
          child: Text('Aucune dépenses ou rentrée récentes'),
        )
      ];
    }
    return body;
  }

  SizedBox buildSolde() {
    Color clr = Colors.black;
    if (_solde <= 0) {
      clr = Colors.red.shade600;
    }
    return SizedBox(
      child: Column(
        children: <Widget>[
          const Text('Votre solde actuelle:'),
          Text(
            '${_solde.toString()} €',
            style: TextStyle(
                fontSize: 40, color: clr, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: recupInfos(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Column colActivites = Column();
        SizedBox sbsolde = const SizedBox();
        FloatingActionButton fab =
            FloatingActionButton(onPressed: popUpInfo, child: null);
        if (snapshot.hasData) {
          fab = FloatingActionButton(
              onPressed: popUpInfo, child: const Icon(Icons.info_outline));
          colActivites = Column(children: buildListDepenses());
          sbsolde = buildSolde();
        } else if (snapshot.hasError) {
          colActivites = Column(children: const [
            Icon(Icons.error_outline, color: Color.fromARGB(255, 255, 17, 0)),
          ]);
        } else {
          colActivites = Column(children: [
            SpinKitChasingDots(size: 150, color: Colors.red.shade300),
          ]);
        }
        return Scaffold(
          appBar:
              AppBar(centerTitle: true, title: Text(widget.title), actions: [
            IconButton(
                onPressed: logout, icon: const Icon(Icons.logout_outlined)),
          ]),
          drawer: Widgets.createDrawer(context),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(child: sbsolde),
                Container(alignment: Alignment.center, child: colActivites),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.width * 0.3,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                            context, '/routeAjout'),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(Icons.monetization_on_outlined, size: 50),
                            Text(
                              'Ajouter une action',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.width * 0.3,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                            context, '/routeRecap'),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(Icons.account_balance_sharp, size: 50),
                            Text(
                              'Votre récap',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          floatingActionButton: fab,
        );
      },
    );
  }
}
