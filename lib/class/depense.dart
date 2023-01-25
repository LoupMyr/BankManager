class Depense {
  Depense(this._montant, this._debiteur, this._datePaiement, this._categorieId,
      this._remarques, this._userId);

  double _montant;
  String _debiteur;
  String _datePaiement;
  String _categorieId;
  String? _remarques;
  String _userId;

  double getMontant() {
    return this._montant;
  }

  String getDebiteur() {
    return this._debiteur;
  }

  String getDatePaiement() {
    return this._datePaiement;
  }

  String getCategorieId() {
    return this._categorieId;
  }

  String? getRemarques() {
    return this._remarques;
  }

  String getUserId() {
    return this._userId;
  }

  void setMontant(double newMontant) {
    this._montant = newMontant;
  }

  void setDebiteur(String newDebiteur) {
    this._debiteur = newDebiteur;
  }

  void setDatePaiement(String newDatePaiement) {
    this._datePaiement = newDatePaiement;
  }

  void setCategorieId(String newCategorieId) {
    this._categorieId = newCategorieId;
  }

  void setRemarques(String newRemarques) {
    this._remarques = newRemarques;
  }

  void setUserId(String newUserId) {
    this._userId = newUserId;
  }
}
