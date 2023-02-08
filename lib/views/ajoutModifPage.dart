import 'package:bank_tracker/class/local.dart';
import 'package:bank_tracker/class/strings.dart';
import 'package:bank_tracker/class/tools.dart';
import 'package:bank_tracker/class/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AjoutModifPage extends StatefulWidget {
  AjoutModifPage({super.key, required this.title});
  String title;

  @override
  State<AjoutModifPage> createState() => AjoutModifPageState();
}

class AjoutModifPageState extends State<AjoutModifPage> {
  final _formKeyDepense = GlobalKey<FormState>();
  final _formKeyRentree = GlobalKey<FormState>();
  Tools _tools = Tools();
  bool _switchValue = false;
  Form _form = Form(
    child: Column(),
  );
  //*************************/
  String _dateDepense = '';
  String _dateDepensePrint = '';
  String _dropdownValueCategorieDepense = 'Sélectionner une catégorie';
  int _idSelectCategorieDepense = -1;
  Text _labelErrCategorieDepense = const Text('');
  double _montantDepense = -1;
  String _debiteurDepense = '';
  String _remarquesDepense = '';
  int? _idPortefeuille;
  String _portefeuilleNom = '';
  //*************************/
  String _dateRentree = '';
  String _dateRentreePrint = '';
  String _dropdownValueCategorieRentree = 'Sélectionner une catégorie';
  int _idSelectCategorieRentree = -1;
  Text _labelErrCategorieRentree = const Text('');
  double _montantRentree = -1;
  String _crediteurRentree = '';
  String _remarquesRentree = '';
  //**************************/
  final fieldRemarquesDepense = TextEditingController();
  final fieldMontantDepense = TextEditingController();
  final fieldDebiteurDepense = TextEditingController();
//**************************/
  final fieldRemarquesRentree = TextEditingController();
  final fieldMontantRentree = TextEditingController();
  final fieldCrediteurRentree = TextEditingController();
//*********************** */
  List<dynamic> _listPortefeuilles = List.empty(growable: true);

  void sendRequestDepense() async {
    double montant = _montantDepense;
    var response = await _tools.postDepense(
        _montantDepense,
        _debiteurDepense,
        _dateDepense,
        _idSelectCategorieDepense.toString(),
        _remarquesDepense,
        _idPortefeuille);
    if (response.statusCode == 201) {
      String? soldeStr = await Local.storage.read(key: 'solde');
      double solde = double.parse(soldeStr!);
      String? userId = await Local.storage.read(key: 'id');
      double newSolde = solde - montant;
      var patch = await _tools.patchSoldeByUserId(newSolde, userId!);
      if (patch.statusCode == 200) {
        await Local.storage.write(key: 'solde', value: newSolde.toString());
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Débit ajouté'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Une erreur est survenue (PATCH) ${patch.statusCode}'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Une erreur est survenue (POST) ${response.statusCode}'),
      ));
    }
  }

  void clearTextsFormDepense() {
    fieldDebiteurDepense.clear();
    fieldMontantDepense.clear();
    fieldRemarquesDepense.clear();
    _dropdownValueCategorieDepense = 'Sélectionner une catégorie';
    _idSelectCategorieDepense = -1;
    _montantDepense = -1;
    _debiteurDepense = '';
    _remarquesDepense = '';
    _dateDepense = '';
  }

  void sendRequestRentree() async {
    double montant = _montantRentree;
    var response = await _tools.postRentree(_montantRentree, _crediteurRentree,
        _dateRentree, _idSelectCategorieRentree.toString(), _remarquesRentree);
    if (response.statusCode == 201) {
      String? soldeStr = await Local.storage.read(key: 'solde');
      double solde = double.parse(soldeStr!);
      String? userId = await Local.storage.read(key: 'id');
      double newSolde = solde + montant;
      var patch = await _tools.patchSoldeByUserId(newSolde, userId!);
      if (patch.statusCode == 200) {
        await Local.storage.write(key: 'solde', value: newSolde.toString());
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Crédit ajouté'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Une erreur est survenue (PATCH) ${patch.statusCode}'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Une erreur est survenue (POST) ${response.statusCode}'),
      ));
    }
  }

  void clearTextsFormRentree() {
    setState(() {
      fieldCrediteurRentree.clear();
      fieldMontantRentree.clear();
      fieldRemarquesDepense.clear();
      _dropdownValueCategorieRentree = 'Sélectionner une catégorie';
      _idSelectCategorieRentree = -1;
      _montantRentree = -1;
      _crediteurRentree = '';
      _remarquesRentree = '';
      _dateRentree = '';
    });
  }

  void guessPage() {
    if (!_switchValue) {
      setState(
        () => createFormDepense(),
      );
    } else {
      setState(
        () => createFormRentree(),
      );
    }
  }

  Future<void> recupPortefeuilles() async {
    _listPortefeuilles = await _tools.getPortefeuillesByUserId();
  }

  void createFormDepense() {
    widget.title = 'Ajout d\'un débit';
    _form = Form(
      key: _formKeyDepense,
      child: Column(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextFormField(
            controller: fieldMontantDepense,
            decoration: const InputDecoration(
              label: Text('Montant du débit: '),
              prefix: Text(
                '- ',
                style: TextStyle(fontSize: 20),
              ),
              suffix: Text(
                ' €',
                style: TextStyle(fontSize: 20),
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: (valeur) {
              if (valeur == null ||
                  valeur.isEmpty ||
                  double.tryParse(valeur)! < 0) {
                _montantDepense = -1;
              } else {
                _montantDepense = double.tryParse(valeur)!;
              }
            },
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextFormField(
            controller: fieldDebiteurDepense,
            decoration: const InputDecoration(label: Text('Débiteur : ')),
            validator: (valeur) {
              if (valeur == null || valeur.isEmpty) {
                _debiteurDepense = '';
              } else {
                _debiteurDepense = valeur;
              }
            },
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Date débit : ', style: TextStyle(fontSize: 17)),
            IconButton(
              hoverColor: Colors.transparent,
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101));
                if (pickedDate != null) {
                  pickedDate.add(const Duration(hours: 1));
                  String formattedDate =
                      DateFormat('dd-MM-yyyy hh:mm:ss').format(pickedDate);

                  setState(() {
                    _dateDepense = formattedDate;
                    _dateDepensePrint =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
            ),
            IconButton(
              hoverColor: Colors.transparent,
              onPressed: () async {
                setState(() {
                  _dateDepense =
                      DateFormat('dd-MM-yyyy hh:mm:ss').format(DateTime.now());
                  _dateDepensePrint =
                      DateFormat('dd-MM-yyyy').format(DateTime.now());
                });
              },
              icon: const Icon(Icons.today),
            ),
            Text(_dateDepensePrint),
          ],
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        DropdownButton(
          menuMaxHeight: 300,
          value: _dropdownValueCategorieDepense,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: Strings.listCategories
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            _idSelectCategorieDepense =
                Strings.listCategories.indexOf(newValue!);
            if (Strings.listCategories.indexOf(newValue) == 0) {
              setState(() {
                _labelErrCategorieDepense = const Text(
                  'Veuillez choisir une valeur',
                  style: TextStyle(color: Colors.red),
                );
              });
            } else {
              setState(() {
                _labelErrCategorieDepense = const Text('');
              });
            }
            setState(() {
              _dropdownValueCategorieDepense = newValue;
            });
          },
        ),
        _labelErrCategorieDepense,
        const Padding(padding: EdgeInsets.all(10)),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: TextFormField(
            controller: fieldRemarquesDepense,
            maxLines: 5,
            decoration: const InputDecoration(hintText: 'Remarques: '),
            validator: (valeur) {
              if (valeur == null || valeur.isEmpty) {
                _remarquesDepense = '';
              } else {
                _remarquesDepense = valeur;
              }
            },
          ),
        ),
        const Padding(padding: EdgeInsets.all(10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              hoverColor: Colors.transparent,
              onPressed: () async {
                await recupPortefeuilles();
                createPopUpPortefeuille();
              },
              icon: const Icon(Icons.wallet_outlined),
            ),
            Text(_portefeuilleNom),
          ],
        ),
        const Padding(padding: EdgeInsets.all(10)),
        ElevatedButton(
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade400),
          onPressed: () {
            if (_formKeyDepense.currentState!.validate()) {
              sendRequestDepense();
              clearTextsFormDepense();
            }
          },
          child: const Text("Valider"),
        ),
      ]),
    );
  }

  void createFormRentree() {
    widget.title = 'Ajout d\'un crédit';
    _form = Form(
      key: _formKeyRentree,
      child: Column(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextFormField(
            controller: fieldMontantRentree,
            decoration: const InputDecoration(
              label: Text('Montant du crédit: '),
              prefix: Text(
                '+ ',
                style: TextStyle(fontSize: 20),
              ),
              suffix: Text(
                ' €',
                style: TextStyle(fontSize: 20),
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: (valeur) {
              if (valeur == null || valeur.isEmpty) {
                _montantRentree = -1;
              } else {
                _montantRentree = double.tryParse(valeur)!;
              }
            },
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextFormField(
            controller: fieldCrediteurRentree,
            decoration: const InputDecoration(label: Text('Créditeur : ')),
            validator: (valeur) {
              if (valeur == null || valeur.isEmpty) {
                _crediteurRentree = '';
              } else {
                _crediteurRentree = valeur;
              }
            },
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Date crédit: ', style: TextStyle(fontSize: 17)),
            IconButton(
              hoverColor: Colors.transparent,
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101));
                if (pickedDate != null) {
                  pickedDate.add(const Duration(hours: 1));
                  String formattedDate =
                      DateFormat('dd-MM-yyyy hh:mm:ss').format(pickedDate);
                  setState(() {
                    _dateRentree = formattedDate;
                    _dateRentreePrint =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
            ),
            IconButton(
              hoverColor: Colors.transparent,
              onPressed: () async {
                setState(() {
                  _dateRentree =
                      DateFormat('dd-MM-yyyy hh:mm:ss').format(DateTime.now());
                  _dateRentreePrint =
                      DateFormat('dd-MM-yyyy').format(DateTime.now());
                });
              },
              icon: const Icon(Icons.today),
            ),
            Text(_dateRentreePrint),
          ],
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        DropdownButton(
          menuMaxHeight: 300,
          value: _dropdownValueCategorieRentree,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: Strings.listCategoriesRentree
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            _idSelectCategorieRentree =
                Strings.listCategoriesRentree.indexOf(newValue!);
            if (Strings.listCategoriesRentree.indexOf(newValue) == 0) {
              setState(() {
                _labelErrCategorieRentree = const Text(
                  'Veuillez choisir une valeur',
                  style: TextStyle(color: Colors.red),
                );
              });
            } else {
              setState(() {
                _labelErrCategorieRentree = const Text('');
              });
            }
            setState(() {
              _dropdownValueCategorieRentree = newValue;
            });
          },
        ),
        _labelErrCategorieRentree,
        const Padding(padding: EdgeInsets.all(10)),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: TextFormField(
            controller: fieldRemarquesRentree,
            maxLines: 5,
            decoration: const InputDecoration(hintText: 'Remarques: '),
            validator: (valeur) {
              if (valeur == null || valeur.isEmpty) {
                _remarquesRentree = '';
              } else {
                _remarquesRentree = valeur;
              }
            },
          ),
        ),
        const Padding(padding: EdgeInsets.all(10)),
        ElevatedButton(
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade400),
          onPressed: () {
            if (_formKeyRentree.currentState!.validate()) {
              sendRequestRentree();
              clearTextsFormRentree();
            }
          },
          child: const Text("Valider"),
        ),
      ]),
    );
  }

  Future<void> createPopUpPortefeuille() async {
    List<Widget> tab = createTab();
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Ajouter à un portefeuille virtuel: ',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: tab,
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'))
            ],
          );
        });
  }

  List<Widget> createTab() {
    List<Widget> tab = List.empty(growable: true);
    if (_listPortefeuilles.isNotEmpty) {
      for (var elt in _listPortefeuilles) {
        tab.add(
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.6,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade400),
              onPressed: () {
                setState(() {
                  _idPortefeuille = elt['id'];
                  _portefeuilleNom = elt['titre'];
                });
                Navigator.pop(context);
              },
              child: Text(elt['titre']),
            ),
          ),
        );
      }
    } else {
      tab = [
        const Text(
          'Vous n\'avez aucun portefeuille virtuel de créé pour le moment.',
          textAlign: TextAlign.center,
        )
      ];
    }
    return tab;
  }

  @override
  Widget build(BuildContext context) {
    guessPage();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      drawer: Widgets.createDrawer(context),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            Switch(
                value: _switchValue,
                onChanged: (value) {
                  guessPage();
                  setState(() {
                    _switchValue = value;
                  });
                }),
            _form
          ]),
        ),
      ),
    );
  }
}
