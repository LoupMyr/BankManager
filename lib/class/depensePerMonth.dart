class TotalPerMonth {
  TotalPerMonth(this._mois, this._total);

  String _mois;
  double _total;

  String getMois() {
    return this._mois;
  }

  void setMois(String newMois) {
    this._mois = newMois;
  }

  double getTotal() {
    return this._total;
  }

  void setTotal(double newTotal) {
    this._total = newTotal;
  }
}
