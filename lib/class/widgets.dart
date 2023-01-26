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
            title: const Text('Accueil'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/routeHome');
            },
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          ListTile(
            title: const Text('Graphes'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/routeGraphe');
            },
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          ListTile(
            title: const Text('Ajouter une dépense / rentrée'),
            onTap: () => Navigator.pushReplacementNamed(context, '/routeAjout'),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          ListTile(
            title: const Text('Recapitulatif'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/routeRecap');
            },
          ),
        ],
      ),
    );
  }
}
