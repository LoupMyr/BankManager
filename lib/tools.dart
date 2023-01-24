import 'package:http/http.dart' as http;

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
}
