import 'package:bank_tracker/class/local.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

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

  Future<http.Response> getPortefeuilles() async {
    return await http.get(
      Uri.parse(
          'https://s3-4428.nuage-peda.fr/apiBank/public/api/portefeuilles'),
    );
  }

  Future<http.Response> getPrelevements() async {
    return await http.get(
      Uri.parse(
          'https://s3-4428.nuage-peda.fr/apiBank/public/api/prelevements'),
    );
  }

  Future<http.Response> getCategorieById(String idCategorie) async {
    return await http.get(Uri.parse(
        'https://s3-4428.nuage-peda.fr/apiBank/public/api/categories/$idCategorie'));
  }

  Future<http.Response> getPortefeuilleById(String idPortefeuille) async {
    return await http.get(Uri.parse(
        'https://s3-4428.nuage-peda.fr/apiBank/public/api/portefeuilles/$idPortefeuille'));
  }

  Future<List<dynamic>> getDepensesByUserID() async {
    List<dynamic> tab = List.empty(growable: true);
    String? idUser = await Local.storage.read(key: 'id');
    var response = await getDepenses();
    if (response.statusCode == 200) {
      var depenses = convert.jsonDecode(response.body);
      for (var elt in depenses['hydra:member']) {
        String idUserElt = this.splitUri(elt['user']);
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
      var portefeuilles = convert.jsonDecode(response.body);
      for (var elt in portefeuilles['hydra:member']) {
        String idUserElt = this.splitUri(elt['user']);
        if (idUserElt == idUser) {
          tab.add(elt);
        }
      }
    }
    return tab;
  }

  Future<List<dynamic>> getPortefeuillesByUserId() async {
    List<dynamic> tab = List.empty(growable: true);
    String? idUser = await Local.storage.read(key: 'id');
    var response = await getPortefeuilles();
    if (response.statusCode == 200) {
      var depenses = convert.jsonDecode(response.body);
      for (var elt in depenses['hydra:member']) {
        String idUserElt = this.splitUri(elt['user']);
        if (idUserElt == idUser) {
          tab.add(elt);
        }
      }
    }
    return tab;
  }

  Future<List<dynamic>> getPrelevementsByUserId() async {
    List<dynamic> tab = List.empty(growable: true);
    String? idUser = await Local.storage.read(key: 'id');
    var response = await getPrelevements();
    if (response.statusCode == 200) {
      var depenses = convert.jsonDecode(response.body);
      for (var elt in depenses['hydra:member']) {
        String idUserElt = this.splitUri(elt['user']);
        if (idUserElt == idUser) {
          tab.add(elt);
        }
      }
    }
    return tab;
  }

  Future<List<dynamic>> getDepensesByPortefeuilleId(int id) async {
    List<dynamic> response = await getDepensesByUserID();
    List<dynamic> tab = List.empty(growable: true);
    for (var elt in response) {
      try {
        String idPortefeuille = splitUri(elt['portefeuille']);
        if (idPortefeuille == id.toString()) {
          tab.add(elt);
        }
      } catch (e) {}
    }
    return tab;
  }

  //POST

  Future<http.Response> postDepense(
      double montant,
      String debiteur,
      String date,
      String idCategorie,
      String remarques,
      int? idPortefeuille) async {
    Map<String, dynamic> rem = {};
    Map<String, dynamic> portefeuille = {};
    if (idPortefeuille != null) {
      portefeuille = {
        "portefeuille": "/apiBank/public/api/portefeuilles/$idPortefeuille",
      };
    }
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
      ...portefeuille,
      "user": "/apiBank/public/api/users/$idUser"
    };
    return await http.post(
      Uri.parse('https://s3-4428.nuage-peda.fr/apiBank/public/api/depenses'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode(body),
    );
  }

  Future<http.Response> postPortefeuille(String titre, double montant,
      String dateDebut, String dateFin, int categorieId) async {
    String? idUser = await Local.storage.read(key: 'id');
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final Map<String, dynamic> body = {
      "titre": titre,
      "user": "/apiBank/public/api/users/${idUser!}",
      "montantInitial": montant,
      "dateDebut": dateDebut,
      "dateFin": dateFin,
      "solde": montant,
      "categorie": '/apiBank/public/api/categories/$categorieId',
      "dateCreation": date
    };
    return await http.post(
      Uri.parse(
          'https://s3-4428.nuage-peda.fr/apiBank/public/api/portefeuilles'),
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

  Future<http.Response> postPrelevement(String titre, double montant,
      String date, bool estDebit, String idCategorie) async {
    String? idUser = await Local.storage.read(key: 'id');
    Map<String, dynamic> categorie = {};
    if (estDebit) {
      categorie = {
        "categorieDebit": '/apiBank/public/api/categories/$idCategorie'
      };
    } else {
      categorie = {
        "categorieCredit": '/apiBank/public/api/categorie_rentrees/$idCategorie'
      };
    }
    final Map<String, dynamic> body = {
      "montant": montant,
      "user": "/apiBank/public/api/users/${idUser!}",
      "datePaiement": date,
      "estDebit": estDebit,
      "titre": titre,
      ...categorie,
    };
    return await http.post(
      Uri.parse(
          'https://s3-4428.nuage-peda.fr/apiBank/public/api/prelevements'),
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

  Future<http.Response> patchSoldeByPortefeuilleId(
      double newSolde, String idPortefeuille) async {
    var json = convert.jsonEncode(<String, dynamic>{"solde": newSolde});
    return await http.patch(
        Uri.parse(
            'https://s3-4428.nuage-peda.fr/apiBank/public/api/portefeuilles/$idPortefeuille'),
        headers: <String, String>{
          'Accept': 'application/ld+json',
          'Content-Type': 'application/merge-patch+json',
        },
        body: json);
  }

  Future<http.Response> patchPrelevement(
    String titre,
    double montant,
    String date,
    bool estDebit,
    String idCategorie,
    String idPrelevement,
  ) async {
    Map<String, dynamic> categorieDebit = {"categorieDebit": null};
    Map<String, dynamic> categorieCredit = {"categorieCredit": null};
    if (estDebit) {
      categorieDebit = {
        "categorieDebit": '/apiBank/public/api/categories/$idCategorie'
      };
    } else {
      categorieCredit = {
        "categorieCredit": '/apiBank/public/api/categorie_rentrees/$idCategorie'
      };
    }
    final Map<String, dynamic> body = {
      "montant": montant,
      "datePaiement": date,
      "estDebit": estDebit,
      "titre": titre,
      ...categorieDebit,
      ...categorieCredit,
    };
    return await http.patch(
      Uri.parse(
          'https://s3-4428.nuage-peda.fr/apiBank/public/api/prelevements/$idPrelevement'),
      headers: <String, String>{
        'Accept': 'application/ld+json',
        'Content-Type': 'application/merge-patch+json',
      },
      body: convert.jsonEncode(body),
    );
  }

  Future<http.Response> patchDatePaiementPrelevement(
      String date, String idPrelevement) async {
    final Map<String, dynamic> body = {
      "datePaiement": date,
    };
    return await http.patch(
      Uri.parse(
          'https://s3-4428.nuage-peda.fr/apiBank/public/api/prelevements/$idPrelevement'),
      headers: <String, String>{
        'Accept': 'application/ld+json',
        'Content-Type': 'application/merge-patch+json',
      },
      body: convert.jsonEncode(body),
    );
  }

  Future<http.Response> patchPortefeuille(
      String titre,
      double montant,
      String dateDebut,
      String dateFin,
      int categorieId,
      String idPortefeuille) async {
    final Map<String, dynamic> body = {
      "titre": titre,
      "montantInitial": montant,
      "dateDebut": dateDebut,
      "dateFin": dateFin,
      "categorie": '/apiBank/public/api/categories/$categorieId',
    };
    return await http.patch(
      Uri.parse(
          'https://s3-4428.nuage-peda.fr/apiBank/public/api/portefeuilles/$idPortefeuille'),
      headers: <String, String>{
        'Accept': 'application/ld+json',
        'Content-Type': 'application/merge-patch+json',
      },
      body: convert.jsonEncode(body),
    );
  }

  Future<http.Response> patchDepenseClearPortefeuille(String id) async {
    Map<String, dynamic> body = {"portefeuille": null};
    return await http.patch(
      Uri.parse(
          'https://s3-4428.nuage-peda.fr/apiBank/public/api/depenses/$id'),
      headers: <String, String>{
        'Accept': 'application/ld+json',
        'Content-Type': 'application/merge-patch+json',
      },
      body: convert.jsonEncode(body),
    );
  }

  Future<http.Response> deletePortefeuille(String id) async {
    return await http.delete(
      Uri.parse(
          'https://s3-4428.nuage-peda.fr/apiBank/public/api/portefeuilles/$id'),
    );
  }

  Future<http.Response> deletePrelevement(String id) async {
    return await http.delete(
      Uri.parse(
          'https://s3-4428.nuage-peda.fr/apiBank/public/api/prelevements/$id'),
    );
  }

  Future<void> deleteDepensesOfPorteuille(String id) async {
    var response = await this.getDepenses();
    List<dynamic> tab = List.empty(growable: true);
    if (response.statusCode == 200) {
      var lesDepenses = convert.jsonDecode(response.body);
      for (var elt in lesDepenses['hydra:member']) {
        try {
          String idPortefeuilleElt = this.splitUri(elt['portefeuille']);
          if (idPortefeuilleElt == id) {
            tab.add(elt);
          }
        } catch (e) {}
      }
      if (tab.isNotEmpty) {
        for (var elt in tab) {
          var response =
              await this.patchDepenseClearPortefeuille(elt['id'].toString());
        }
      }
    }
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

  bool estExpire(var elt) {
    bool result = false;
    if (DateTime.parse(elt['dateFin']).compareTo(DateTime.now()) < 0) {
      result = true;
    }
    return result;
  }
}
