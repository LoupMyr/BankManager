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
              "Qu'est ce que Bank Manager ?",
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                    "Bank Manager vous permet de faire vos comptes rapidement et facilement et\nd'avoir une vue d'ensemble de vos dépenses simple et intuitive.",
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
    var depenses = await _tools.getDepensesByUserID();
    var rentrees = await _tools.getRentreesByUserID();
    var prelevements = await _tools.getPrelevementsByUserId();
    await checkPrelevements(prelevements);
    String? s = await Local.storage.read(key: 'solde');
    _solde = double.parse(s!);
    _solde = double.parse(_solde.toStringAsFixed(2));
    _list = depenses + rentrees;
    if (_list.isNotEmpty) {
      _list.sort((a, b) {
        return DateTime.parse(b['datePaiement'])
            .compareTo(DateTime.parse(a['datePaiement']));
      });
    }
    return '';
  }

  Future<void> checkPrelevements(List<dynamic> prelevements) async {
    for (var elt in prelevements) {
      DateTime dateElt = DateTime.parse(elt['datePaiement']);
      while (dateElt.isBefore(DateTime.now())) {
        if (elt['estDebit']) {
          await addDepense(elt, dateElt);
        } else {
          await addRentree(elt, dateElt);
        }
        DateTime newDate =
            DateTime(dateElt.year, dateElt.month + 1, dateElt.day);
        await _tools.patchDatePaiementPrelevement(
            DateFormat('dd-MM-yyyy').format(newDate), elt['id'].toString());
        dateElt = newDate;
      }
    }
  }

  Future<void> addDepense(var elt, DateTime dateElt) async {
    double montant = double.parse(elt['montant'].toString());
    String date = DateFormat('dd-MM-yyyy hh:mm:ss').format(dateElt);

    await _tools.postDepense(montant, elt['titre'], date,
        _tools.splitUri(elt['categorieDebit'].toString()), '', null);
    String? soldeStr = await Local.storage.read(key: 'solde');
    double solde = double.parse(soldeStr!);
    String? userId = await Local.storage.read(key: 'id');
    double newSolde = solde - montant;
    var patch = await _tools.patchSoldeByUserId(newSolde, userId!);

    await Local.storage.write(key: 'solde', value: newSolde.toString());
  }

  Future<void> addRentree(var elt, DateTime dateElt) async {
    double montant = double.parse(elt['montant'].toString());
    String date = DateFormat('dd-MM-yyyy hh:mm:ss').format(dateElt);
    var response = await _tools.postRentree(montant, elt['titre'], date,
        _tools.splitUri(elt['categorieCredit'].toString()), '');
    String? soldeStr = await Local.storage.read(key: 'solde');
    double solde = double.parse(soldeStr!);
    String? userId = await Local.storage.read(key: 'id');
    double newSolde = solde + montant;
    var patch = await _tools.patchSoldeByUserId(newSolde, userId!);

    await Local.storage.write(key: 'solde', value: newSolde.toString());
  }

  Widget buildListDepenses() {
    Widget body = SizedBox();
    if (_list.isNotEmpty) {
      int nbIterations = 0;
      if (_list.length >= 5) {
        nbIterations = 5;
      } else {
        nbIterations = _list.length - 1;
      }
      List<Widget> children =
          Widgets.createList(nbIterations, _list, context, 0.35, 0.15);
      body = SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.35,
        child: ListView(
          shrinkWrap: true,
          children: children,
        ),
      );
    } else {
      body = const SizedBox(
        child: Text('Aucune dépenses ou rentrée récentes'),
      );
    }
    return body;
  }

  SizedBox buildSolde() {
    Color clr = Colors.white;
    if (_solde <= 0) {
      clr = Colors.red.shade600;
    }
    return SizedBox(
      child: Column(
        children: <Widget>[
          const Text('Votre solde actuelle:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
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
        FloatingActionButton fab = FloatingActionButton(
          onPressed: popUpInfo,
          child: null,
          backgroundColor: Colors.teal.shade400,
        );
        if (snapshot.hasData) {
          sbsolde = buildSolde();
          fab = FloatingActionButton(
            onPressed: popUpInfo,
            backgroundColor: Colors.teal.shade400,
            child: const Icon(Icons.info_outline),
          );
          colActivites = Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(child: sbsolde),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                buildListDepenses(),
              ],
            ),
          ]);
        } else if (snapshot.hasError) {
          colActivites = Column(children: const [
            Icon(Icons.error_outline, color: Colors.red),
          ]);
        } else {
          colActivites = Column(children: [
            SpinKitChasingDots(size: 150, color: Colors.teal.shade400),
          ]);
        }
        return Scaffold(
          appBar:
              AppBar(centerTitle: true, title: Text(widget.title), actions: [
            IconButton(
                onPressed: logout,
                icon: const Icon(Icons.logout_outlined),
                tooltip: 'Deconnexion'),
          ]),
          drawer: Widgets.createDrawer(context),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
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
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade400),
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
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade400),
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
