import 'package:bank_tracker/class/local.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Tools {
  Tools();

  Future<http.Response> getDepenses() async {
    return await http.get(
      Uri.parse('https://s3-4428.nuage-peda.fr/apiBank/public/api/depenses'),
    );
  }

  Future<http.Response> getRentrees() async {
    return await http.get(
      Uri.parse('https://s3-4428.nuage-peda.fr/apiBank/public/api/rentrees'),
    );
  }

  Future<http.Response> getCategories() async {
    return await http.get(
      Uri.parse('https://s3-4428.nuage-peda.fr/apiBank/public/api/categories'),
    );
  }

  Future<http.Response> getCategorieById(String idCategorie) async {
    return await http.get(Uri.parse(
        'https://s3-4428.nuage-peda.fr/apiBank/public/api/categories/$idCategorie'));
  }

  Future<List<dynamic>> getDepensesByUserID() async {
    List<dynamic> tab = List.empty(growable: true);
    String? idUser = await Local.storage.read(key: 'id');
    var response = await getDepenses();
    if (response.statusCode == 200) {
      var depenses = convert.jsonDecode(response.body);
      for (var elt in depenses['hydra:member']) {
        List<String> temp = elt['user'].split('/');
        String idUserElt = temp[temp.length - 1];
        if (idUserElt == idUser) {
          tab.add(elt);
        }
      }
    }
    return tab;
  }

  Future<List<dynamic>> getRentreesByUserID() async {
    List<dynamic> tab = List.empty(growable: true);
    String? idUser = await Local.storage.read(key: 'id');
    var response = await getRentrees();
    if (response.statusCode == 200) {
      var depenses = convert.jsonDecode(response.body);
      for (var elt in depenses['hydra:member']) {
        List<String> temp = elt['user'].split('/');
        String idUserElt = temp[temp.length - 1];
        if (idUserElt == idUser) {
          tab.add(elt);
        }
      }
    }
    return tab;
  }

  //POST

  Future<http.Response> postDepense(double montant, String debiteur,
      String date, String idCategorie, String remarques) async {
    Map<String, dynamic> rem = {};
    String? idUser = await Local.storage.read(key: 'id');
    if (remarques.isNotEmpty) {
      rem = {
        "remarques": remarques,
      };
    }
    final Map<String, dynamic> body = {
      "montant": montant,
      "debiteur": debiteur,
      "datePaiement": date,
      "categorieActivite": '/apiBank/public/api/categories/$idCategorie',
      ...rem,
      "user": "/apiBank/public/api/users/${idUser!}"
    };
    print(body);
    return await http.post(
      Uri.parse('https://s3-4428.nuage-peda.fr/apiBank/public/api/depenses'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode(body),
    );
  }

  Future<http.Response> postRentree(double montant, String crediteur,
      String date, String idCategorie, String remarques) async {
    Map<String, dynamic> rem = {};
    String? idUser = await Local.storage.read(key: 'id');
    if (remarques.isNotEmpty) {
      rem = {
        "remarques": remarques,
      };
    }
    final Map<String, dynamic> body = {
      "montant": montant,
      "crediteur": crediteur,
      "datePaiement": date,
      ...rem,
      "categorie": '/apiBank/public/api/categorie_rentrees/$idCategorie',
      "user": "/apiBank/public/api/users/${idUser!}"
    };
    return await http.post(
      Uri.parse('https://s3-4428.nuage-peda.fr/apiBank/public/api/rentrees'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode(body),
    );
  }

  Future<http.Response> postUser(String email, String password, String nom,
      String prenom, double solde) async {
    return http.post(
        Uri.parse('https://s3-4428.nuage-peda.fr/apiBank/public/api/users'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: convert.jsonEncode(<String, dynamic>{
          "email": email,
          "roles": ['ROLE_USER'],
          "password": password,
          "nom": nom,
          "prenom": prenom,
          "dateInscription": DateTime.now().toString(),
          "solde": solde
        }));
  }

  Future<http.Response> authentication(String email, String password) async {
    return http.post(
        Uri.parse(
            'https://s3-4428.nuage-peda.fr/apiBank/public/api/authentication_token'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: convert.jsonEncode(
            <String, dynamic>{"email": email, "password": password}));
  }

  Future<http.Response> patchSoldeByUserId(
      double newSolde, String idUser) async {
    var json = convert.jsonEncode(<String, dynamic>{"solde": newSolde});
    return await http.patch(
        Uri.parse(
            'https://s3-4428.nuage-peda.fr/apiBank/public/api/users/$idUser'),
        headers: <String, String>{
          'Accept': 'application/ld+json',
          'Content-Type': 'application/merge-patch+json',
        },
        body: json);
  }

  String splitUri(String str) {
    List<String> temp = str.split('/');
    return (temp[temp.length - 1]);
  }

  List<dynamic> sortListByDate(List<dynamic> list) {
    list.sort((a, b) {
      return DateTime.parse(b['datePaiement'])
          .compareTo(DateTime.parse(a['datePaiement']));
    });
    return list;
  }
}
