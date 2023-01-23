import 'package:flutter/material.dart';

class Widgets {
  static Widget createDrawer(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.3,
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
            title: const Text('Graphes'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/routeGraphe');
            },
          ),
          ListTile(
              title: const Text('Ajouter une dépense'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/routeAjout')),
          ListTile(
            title: const Text('Recap'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/routeRecap');
            },
          ),
        ],
      ),
    );
  }
}
