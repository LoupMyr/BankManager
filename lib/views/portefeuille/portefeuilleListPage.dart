import 'package:bank_tracker/class/tools.dart';
import 'package:bank_tracker/class/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PortefeuilleListPage extends StatefulWidget {
  const PortefeuilleListPage({super.key, required this.title});
  final String title;

  @override
  State<PortefeuilleListPage> createState() => PortefeuilleListPageState();
}

class PortefeuilleListPageState extends State<PortefeuilleListPage> {
  final Tools _tools = Tools();
  List<dynamic> _listPortefeuilles = List.empty(growable: true);

  Future<String> recupPortefeuilles() async {
    _listPortefeuilles = await _tools.getPortefeuillesByUserId();
    return '';
  }

  Column buildBody(BuildContext context) {
    List<Widget> tab = List.empty(growable: true);
    if (_listPortefeuilles.isNotEmpty) {
      for (var elt in _listPortefeuilles) {
        tab.add(
          Row(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.7,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade400),
                  onPressed: () => Navigator.pushNamed(
                      context, '/routePortefeuille',
                      arguments: elt),
                  child: Text(elt['titre']),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  await Navigator.pushNamed(context, '/routePortefeuilleAjout',
                      arguments: elt);
                },
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
        const Text('Aucun portefeuille.'),
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
                'Vous êtes sur le point de supprimer un de vos portefeuille virtuel !'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Etes-sur de vouloir continuer ?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Oui'),
                onPressed: () async {
                  await deletePortefeuille(id);
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

  Future<void> deletePortefeuille(String id) async {
    await _tools.deleteDepensesOfPorteuille(id);
    var response = await _tools.deletePortefeuille(id);
    if (response.statusCode == 204) {
      await recupPortefeuilles();
      setState(() {
        build(context);
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Portefeuille supprimé.'),
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
        future: recupPortefeuilles(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Column col = Column();
          Container container = Container();
          if (snapshot.hasData) {
            col = buildBody(context);
            container = Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.85,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade400),
                onPressed: () {
                  Navigator.pushNamed(context, '/routePortefeuilleAjout',
                      arguments: '');
                },
                child: const Text('Ajouter nouveau portefeuille virtuel'),
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
