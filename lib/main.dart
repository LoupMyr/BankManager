import 'package:bank_tracker/views/ajoutModifPage.dart';
import 'package:bank_tracker/views/mensualites/ajoutPrelevementPage.dart';
import 'package:bank_tracker/views/details%20&%20graphes/detailsActionPage.dart';
import 'package:bank_tracker/views/details%20&%20graphes/detailsMoisPage.dart';
import 'package:bank_tracker/views/details%20&%20graphes/graphePage.dart';
import 'package:bank_tracker/views/mensualites/prelevementListPage.dart';
import 'package:bank_tracker/views/myhomepage.dart';
import 'package:bank_tracker/views/portefeuille/ajouterPortefeuillePage.dart';
import 'package:bank_tracker/views/portefeuille/portefeuilleListPage.dart';
import 'package:bank_tracker/views/portefeuille/portefeuillePage.dart';
import 'package:bank_tracker/views/recapPage.dart';
import 'package:bank_tracker/views/user/connexionPage.dart';
import 'package:bank_tracker/views/user/inscriptionPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Bank\'Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.dark,
        home: const ConnexionPage(title: 'Connexion'),
        routes: <String, WidgetBuilder>{
          '/routeHome': (BuildContext context) =>
              const MyHomePage(title: "Accueil"),
          '/routeAjout': (BuildContext context) =>
              AjoutModifPage(title: "Ajout sortie d'argent"),
          '/routeGraphe': (BuildContext context) =>
              const GraphePage(title: "Graphes"),
          '/routeRecap': (BuildContext context) =>
              const RecapPage(title: "Recapitulatif"),
          '/routeDetailsMois': (BuildContext context) =>
              const DetailsMoisPage(title: "Details"),
          '/routeConnexion': (BuildContext context) =>
              const ConnexionPage(title: "Connexion"),
          '/routeInscription': (BuildContext context) =>
              const InscriptionPage(title: "Inscription"),
          '/routeDetailAction': (BuildContext context) =>
              const DetailsActionPage(title: "Détails action"),
          '/routePortefeuilleList': (BuildContext context) =>
              const PortefeuilleListPage(title: "Vos portefeuilles virtuels"),
          '/routePortefeuilleAjout': (BuildContext context) =>
              PortefeuilleAjoutPage(title: "Ajouter un portefeuille virtuel"),
          '/routePortefeuille': (BuildContext context) =>
              const PortefeuillePage(title: "Détails portefeuille"),
          '/routeAjoutPrelevement': (BuildContext context) =>
              const AjoutPrelevementPage(title: "Ajout mensualité"),
          '/routePrelevementList': (BuildContext context) =>
              const PrelevementListPage(title: "Liste de vos mensualités"),
        });
  }
}
