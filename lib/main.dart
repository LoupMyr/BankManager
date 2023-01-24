import 'package:bank_tracker/ajoutPage.dart';
import 'package:bank_tracker/detailsMoisPage.dart';
import 'package:bank_tracker/graphePage.dart';
import 'package:bank_tracker/myhomepage.dart';
import 'package:bank_tracker/recapPage.dart';
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
        home: const MyHomePage(title: 'Bank Tracker'),
        routes: <String, WidgetBuilder>{
          '/routeHome': (BuildContext context) =>
              const MyHomePage(title: "Bank Tracker - Accueil"),
          '/routeAjout': (BuildContext context) =>
              const AjoutPage(title: "Bank Tracker - Ajout"),
          '/routeGraphe': (BuildContext context) =>
              const GraphePage(title: "Bank Tracker - Graphes"),
          '/routeRecap': (BuildContext context) =>
              const RecapPage(title: "Bank Tracker - Recapitulatif"),
          '/routeDetailsMois': (BuildContext context) =>
              const DetailsMoisPage(title: "Bank Tracker - Details"),
        });
  }
}
