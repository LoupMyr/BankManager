import 'package:bank_tracker/views/ajoutModifPage.dart';
import 'package:bank_tracker/views/detailsActionPage.dart';
import 'package:bank_tracker/views/detailsMoisPage.dart';
import 'package:bank_tracker/views/graphePage.dart';
import 'package:bank_tracker/views/myhomepage.dart';
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
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.red,
          primarySwatch: Colors.red,
        ),
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
        });
  }
}
