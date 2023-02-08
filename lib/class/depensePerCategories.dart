class TotalPerCategories {
  TotalPerCategories(this._categorie, this._total, this._depenses);

  String _categorie;
  double _total;
  List<dynamic> _depenses;

  String getCategorie() {
    return this._categorie;
  }

  void setCategorie(String newCategorie) {
    this._categorie = newCategorie;
  }

  double getTotal() {
    return this._total;
  }

  void setTotal(double newTotal) {
    this._total = newTotal;
  }

  String getPhraseBuilder() {
    return this._categorie;
  }

  List<dynamic> getDepenses() {
    return this._depenses;
  }

  void setDepenses(List<dynamic> newDepenses) {
    this._depenses = newDepenses;
  }
}
