import 'package:bank_tracker/class/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bank_tracker/class/tools.dart';
import 'package:bank_tracker/class/widgets.dart';
import 'package:intl/intl.dart';

class PortefeuillePage extends StatefulWidget {
  const PortefeuillePage({super.key, required this.title});
  final String title;

  @override
  State<PortefeuillePage> createState() => PortefeuillePageState();
}

class PortefeuillePageState extends State<PortefeuillePage> {
  Tools _tools = Tools();
  List<dynamic> _listDepenses = List.empty(growable: true);
  var _arg;

  Future<String> recupDepenses() async {
    _listDepenses = await _tools.getDepensesByPortefeuilleId(_arg['id']);
    return '';
  }

  Column buildCol() {
    List<Widget> tab = List.empty(growable: true);
    if (_listDepenses.isNotEmpty) {
      tab = Widgets.createList(
          _listDepenses.length, _listDepenses, context, 0.6, 0.3);
    } else {
      tab = [const Text('Aucune dépenses enregistré dans ce portefeuille.')];
    }
    return Column(children: tab);
  }

  Container buildDetails() {
    return Container(
      child: Column(children: <Widget>[
        createRow('Titre:', _arg['titre'], Icon(Icons.text_fields_outlined), 0),
        createRow('Montant initial:', _arg['montantInitial'],
            Icon(Icons.attach_money_outlined), 1),
        createRow('Solde actuelle:', _arg['solde'],
            Icon(Icons.money_off_csred_outlined), 2),
        createRow(
            'Catégorie:',
            Strings
                .listCategories[int.parse(_tools.splitUri(_arg['categorie']))],
            Icon(Icons.bookmark_outline),
            3),
        createRow(
            'Date de création:',
            DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(_arg['dateCreation'])),
            Icon(Icons.calendar_today_outlined),
            4),
        createRow(
            'Date de debut:',
            DateFormat('yyyy-MM-dd').format(DateTime.parse(_arg['dateDebut'])),
            Icon(Icons.date_range),
            5),
        createRow(
            'Date de fin:',
            DateFormat('yyyy-MM-dd').format(DateTime.parse(_arg['dateFin'])),
            Icon(Icons.date_range),
            6),
        Row(
          children: [
            Text(
              'Liste des dépenses associé à ce portefeuille:',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ]),
    );
  }

  Container createRow(String txt, var elt, Icon icon, int idElt) {
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          icon,
          Padding(padding: EdgeInsets.only(right: 3)),
          Text(
            '$txt',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            guessStr(elt, idElt),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blueGrey.shade300, fontSize: 18),
          ),
        ]),
      ]),
    );
  }

  String guessStr(var elt, int idElt) {
    String txt = '${elt.toString()}\n';
    if (idElt == 1 || idElt == 2) {
      txt = '$elt €\n';
    }
    return txt;
  }

  @override
  Widget build(BuildContext context) {
    _arg = ModalRoute.of(context)!.settings.arguments as dynamic;
    return FutureBuilder(
        future: recupDepenses(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Column col = Column();
          Container container = Container();
          if (snapshot.hasData) {
            col = buildCol();
            container = buildDetails();
          } else if (snapshot.hasError) {
            col = Column(
              children: const <Widget>[
                Icon(Icons.error_outline, color: Colors.red),
              ],
            );
          } else {
            col = Column(
              children: <Widget>[
                SpinKitChasingDots(size: 150, color: Colors.teal.shade400),
              ],
            );
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
            body: SingleChildScrollView(
              child: Center(
                child: Column(children: <Widget>[
                  container,
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  col
                ]),
              ),
            ),
          );
        });
  }
}
