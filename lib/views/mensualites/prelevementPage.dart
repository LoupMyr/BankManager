import 'package:bank_tracker/class/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bank_tracker/class/tools.dart';
import 'package:bank_tracker/class/widgets.dart';
import 'package:intl/intl.dart';

class PrelevementPage extends StatefulWidget {
  const PrelevementPage({super.key, required this.title});
  final String title;

  @override
  State<PrelevementPage> createState() => PrelevementPageState();
}

class PrelevementPageState extends State<PrelevementPage> {
  Tools _tools = Tools();
  List<dynamic> _listDepenses = List.empty(growable: true);
  var _arg;

  Future<String> recupDepenses() async {
    _listDepenses = await _tools.getDepensesByPortefeuilleId(_arg['id']);
    return '';
  }

  Container buildDetails() {
    String categorie = '';
    try {
      categorie = Strings
          .listCategories[int.parse(_tools.splitUri(_arg['categorieDebit']))];
    } catch (e) {
      categorie = Strings.listCategoriesRentree[
          int.parse(_tools.splitUri(_arg['categorieCredit']))];
    }
    return Container(
      child: Column(children: <Widget>[
        createRow('Titre:', _arg['titre'], Icon(Icons.text_fields_outlined)),
        createRow('Catégorie:', categorie, Icon(Icons.bookmark_outline)),
        createRow(
          'Date de paiement:',
          DateFormat('yyyy-MM-dd').format(DateTime.parse(_arg['datePaiement'])),
          Icon(Icons.calendar_today_outlined),
        ),
      ]),
    );
  }

  Container createRow(String txt, var elt, Icon icon) {
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
            elt,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blueGrey.shade300, fontSize: 18),
          ),
        ]),
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
            container = buildDetails();
          } else if (snapshot.hasError) {
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
                  col,
                ]),
              ),
            ),
          );
        });
  }
}
