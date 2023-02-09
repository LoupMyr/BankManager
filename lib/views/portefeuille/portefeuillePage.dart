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
        Text(_arg['titre']),
        Text('${_arg['montantInitial'].toString()} €'),
        Text('${_arg['solde'].toString()} €'),
        Text(Strings
            .listCategories[int.parse(_tools.splitUri(_arg['categorie']))]),
        Text(
            'Date Création: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(_arg['dateCreation']))}'),
        Text(
            'Date début: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(_arg['dateDebut']))}'),
        Text(
            'Date fin: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(_arg['dateFin']))}'),
      ]),
    );
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
                  const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                  col
                ]),
              ),
            ),
          );
        });
  }
}
