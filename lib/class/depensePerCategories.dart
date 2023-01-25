class TotalPerCategories {
  TotalPerCategories(this._categorie, this._total);

  String _categorie;
  double _total;

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
}
