import 'package:bank_tracker/class/tools.dart';
import 'package:bank_tracker/class/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PrelevementListPage extends StatefulWidget {
  const PrelevementListPage({super.key, required this.title});
  final String title;

  @override
  State<PrelevementListPage> createState() => PrelevementListPageState();
}

class PrelevementListPageState extends State<PrelevementListPage> {
  Tools _tools = Tools();
  List<dynamic> _listPrelevement = List.empty(growable: true);

  Future<String> recupPrelevements() async {
    _listPrelevement = await _tools.getPrelevementsByUserId();
    return '';
  }

  Column buildBody() {
    List<Widget> tab = List.empty(growable: true);
    if (_listPrelevement.isNotEmpty) {
      for (var elt in _listPrelevement) {
        Color color = Colors.red;
        if (!elt['estDebit']) {
          color = Colors.green;
        }
        tab.add(
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: color, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.7,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade400),
                  onPressed: () => Navigator.pushNamed(
                      context, '/routePrelevementDetails',
                      arguments: elt),
                  child: Text(elt['titre']),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.pushNamed(
                    context, '/routeAjoutPrelevement',
                    arguments: elt),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => buildDeletePopUp(elt['id'].toString()),
              ),
            ],
          ),
        );
        tab.add(
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
          ),
        );
      }
    } else {
      tab = [
        const Text('Aucune action mensuelle enregistré.'),
      ];
    }
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: tab);
  }

  Future<void> buildDeletePopUp(String id) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Vous êtes sur le point de supprimer une action mensuelle !',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                    'Voulez-vous tout de même poursuivre cette action ?',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Oui'),
                onPressed: () async {
                  await deletePrelevement(id);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Annuler'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    build(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> deletePrelevement(String id) async {
    var response = await _tools.deletePrelevement(id);
    if (response.statusCode == 204) {
      await recupPrelevements();
      setState(() {
        build(context);
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Prelevement supprimé.'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Une erreur est survenue ${response.statusCode}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: recupPrelevements(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Column col = Column();
          Container container = Container();
          if (snapshot.hasData) {
            col = buildBody();
            container = Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.85,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade400),
                onPressed: () {
                  Navigator.pushNamed(context, '/routeAjoutPrelevement',
                      arguments: '');
                },
                child: const Text('Ajouter une nouvelle action mensuel'),
              ),
            );
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
            ),
            drawer: Widgets.createDrawer(context),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox.fromSize(
                          size: const Size(1, 100),
                        ),
                        container,
                      ],
                    ),
                    SizedBox.fromSize(
                      size: const Size(1, 100),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        col,
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
