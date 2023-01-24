import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Tools {
  Tools();

  Future<http.Response> getDepenses() async {
    return await http.get(
      Uri.parse('https://s3-4428.nuage-peda.fr/apiBank/public/api/depenses'),
    );
  }

  Future<http.Response> getCategories() async {
    return await http.get(
      Uri.parse('https://s3-4428.nuage-peda.fr/apiBank/public/api/categories'),
    );
  }

  //POST

  Future<http.Response> postDepense(double montant, String debiteur,
      String date, String idCategorie, String remarques) async {
    Map<String, dynamic> rem = {};
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
}
