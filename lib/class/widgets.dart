import 'package:flutter/material.dart';

class Widgets {
  static Widget createDrawer(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.5,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const FlutterLogo(),
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
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: const Text(
                    ' Ajouter un débit / crédit',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            onTap: () => Navigator.pushReplacementNamed(context, '/routeAjout'),
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
        ],
      ),
    );
  }
}
