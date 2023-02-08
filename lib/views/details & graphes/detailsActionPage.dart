import 'package:bank_tracker/class/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;

class DetailsActionPage extends StatefulWidget {
  const DetailsActionPage({super.key, required this.title});
  final String title;

  @override
  State<DetailsActionPage> createState() => DetailsActionPageState();
}

class DetailsActionPageState extends State<DetailsActionPage> {
  var _action;
  final Tools _tools = Tools();
  String _categorieName = '';

  Future<void> recupCategorie() async {
    String categorieStr = '';
    if (_action['@type'] == 'Depense') {
      categorieStr = _action['categorieActivite'];
    } else {
      categorieStr = _action['categorie'];
    }
    var response = await _tools.getCategorieById(_tools.splitUri(categorieStr));
    if (response.statusCode == 200) {
      var categorie = convert.jsonDecode(response.body);
      _categorieName = categorie['libelle'];
    }
  }

  Column buildBody() {
    String remarques = '/';
    String person = '';
    String personStr = 'Débiteur: ';
    String symbol = '-';
    TextStyle textStyle = const TextStyle(color: Colors.red);
    try {
      remarques = _action['remarques'];
    } catch (e) {}
    if (_action['@type'] == 'Rentree') {
      symbol = '+';
      person = _action['crediteur'];
      personStr = 'Créditeur: ';
    } else {
      person = _action['debiteur'];
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        createText('Type:', _action['@type']),
        createText(personStr, person),
        createText('Remarques: ', remarques),
        createText('Montant: ', '$symbol ${_action['montant'].toString()}€'),
        createText(
            'Date de paiement: ',
            DateFormat('dd-MM-yyyy')
                .format(DateTime.parse(_action['datePaiement']))),
        createText('Catégorie: ', _categorieName),
      ],
    );
  }

  RichText createText(String title, String content) {
    return RichText(
      text: TextSpan(
          text: title,
          style: const TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500),
          children: <TextSpan>[
            TextSpan(
              text: ' $content',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal),
            )
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    _action = ModalRoute.of(context)!.settings.arguments as dynamic;
    return FutureBuilder(
        future: recupCategorie(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Column col = Column();
          if (snapshot.hasData) {
            col = buildBody();
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
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildBody(),
                ],
              ),
            ),
          );
        });
  }
}
