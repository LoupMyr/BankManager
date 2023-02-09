import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Widgets {
  static Widget createDrawer(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.6,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: InkWell(
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/routeHome'),
              child: const Image(
                image: AssetImage('assets/logo.png'),
              ),
            ),
          ),
          ListTile(
            title: Row(
              children: const <Widget>[
                Icon(Icons.home_outlined),
                Text(' Accueil')
              ],
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/routeHome');
            },
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          ListTile(
            title: Row(
              children: const <Widget>[
                Icon(Icons.align_vertical_bottom_rounded),
                Text(' Graphes'),
              ],
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/routeGraphe');
            },
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          ListTile(
            title: Row(
              children: <Widget>[
                const Icon(Icons.monetization_on_outlined),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.40,
                  child: const Text(
                    ' Ajouter un débit / crédit',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            onTap: () => Navigator.pushReplacementNamed(context, '/routeAjout'),
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                const Icon(Icons.event_repeat),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.40,
                  child: const Text(
                    ' Vos mensualités',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            onTap: () => Navigator.pushReplacementNamed(
                context, '/routePrelevementList'),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          ListTile(
            title: Row(
              children: const <Widget>[
                Icon(Icons.account_balance_sharp),
                Text(' Recapitulatif'),
              ],
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/routeRecap');
            },
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          ListTile(
            title: Row(
              children: const <Widget>[
                Icon(Icons.wallet),
                Text(' Vos portefeuilles'),
              ],
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/routePortefeuilleList');
            },
          ),
        ],
      ),
    );
  }

  static List<Widget> createList(int nbIterations, List<dynamic> _list,
      BuildContext context, double coefRem, double coefPerson) {
    List<Widget> children = List.empty(growable: true);
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
                    width: MediaQuery.of(context).size.width * coefPerson,
                    child: Text(' $person',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * coefRem,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: Text(
                      '\n$remarques',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () => Navigator.pushNamed(context, '/routeDetailAction',
              arguments: _list[i]),
        ),
      );
    }
    return children;
  }
}
