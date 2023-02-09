import 'package:bank_tracker/class/local.dart';
import 'package:bank_tracker/class/strings.dart';
import 'package:bank_tracker/class/tools.dart';
import 'package:bank_tracker/class/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;

class AjoutPrelevementPage extends StatefulWidget {
  const AjoutPrelevementPage({super.key, required this.title});
  final String title;

  @override
  State<AjoutPrelevementPage> createState() => AjoutPrelevementPageState();
}

class AjoutPrelevementPageState extends State<AjoutPrelevementPage> {
  final _formKeyDepense = GlobalKey<FormState>();
  Tools _tools = Tools();
  //*************************/
  String _date = '';
  String _datePrint = '';
  double _montant = -1;
  String _titre = '';
  bool _estDebit = true;
  /*************************/
  String _dropdownValueCategorieDebit = Strings.listCategories[0];
  int _idSelectCategorieDebit = -1;
  /************************ */
  String _dropdownValueCategorieCredit = Strings.listCategoriesRentree[0];
  int _idSelectCategorieCredit = -1;
  //*************************/
  String _symbol = '- ';
  bool _value = false;
  //**************************/
  final _fieldMontant = TextEditingController();
  final _fieldTitre = TextEditingController();
//*********************** */
  var _arg;
  bool _hasRecup = false;
  bool _estEdit = false;

  void sendRequest() async {
    if (_idSelectCategorieCredit != -1 || _idSelectCategorieDebit != -1) {
      var response;
      if (_idSelectCategorieDebit != -1 && _idSelectCategorieCredit == -1) {
        response = await _tools.postPrelevement(_titre, _montant, _date,
            _estDebit, _idSelectCategorieDebit.toString());
      } else {
        response = await _tools.postPrelevement(_titre, _montant, _date,
            _estDebit, _idSelectCategorieCredit.toString());
      }
      if (response.statusCode == 201) {
        Navigator.pushReplacementNamed(context, '/routePrelevementList');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Action mensuel ajouté'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Une erreur est survenue ${response.statusCode}'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Veuillez choisir une catégorie.'),
      ));
    }
  }

  void sendRequestPatch() async {
    if (_idSelectCategorieCredit != -1 || _idSelectCategorieDebit != -1) {
      var response;
      if (_idSelectCategorieDebit != -1 && _idSelectCategorieCredit == -1) {
        response = await _tools.patchPrelevement(
            _titre,
            _montant,
            _date,
            _estDebit,
            _idSelectCategorieDebit.toString(),
            _arg['id'].toString());
      } else {
        response = await _tools.patchPrelevement(
            _titre,
            _montant,
            _date,
            _estDebit,
            _idSelectCategorieCredit.toString(),
            _arg['id'].toString());
      }
      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/routePrelevementList');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Action mensuel modifié'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Une erreur est survenue ${response.statusCode}'),
        ));
      }
    }
  }

  void clearTextsFormDepense() {
    _fieldTitre.clear();
    _fieldMontant.clear();
    _date = '';
    _datePrint = '';
  }

  void changeSymbol() {
    if (_estDebit) {
      _symbol = '- ';
    } else {
      _symbol = '+ ';
    }
    setState(() => _symbol);
  }

  void fillFields() {
    _fieldMontant.value = TextEditingValue(text: _arg['montant'].toString());
    _fieldTitre.value = TextEditingValue(text: _arg['titre']);
    setState(() {
      _date = _arg['datePaiement'];
      _datePrint =
          DateFormat('dd-MM-yyyy').format(DateTime.parse(_arg['datePaiement']));
      _estDebit = _arg['estDebit'];
      if (_estDebit) {
        _idSelectCategorieDebit =
            int.parse(_tools.splitUri(_arg['categorieDebit']));
        _dropdownValueCategorieDebit =
            Strings.listCategories[_idSelectCategorieDebit];
      } else {
        _idSelectCategorieCredit =
            int.parse(_tools.splitUri(_arg['categorieCredit']));
        _dropdownValueCategorieCredit =
            Strings.listCategoriesRentree[_idSelectCategorieCredit];
      }
      _hasRecup = true;
    });
  }

  StatefulWidget createDropdownButtonDebit() {
    setState(() {
      _idSelectCategorieCredit = -1;
      _dropdownValueCategorieCredit = Strings.listCategoriesRentree[0];
    });

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return DropdownButton(
        style:
            TextStyle(color: Theme.of(context).primaryColorLight, fontSize: 16),
        menuMaxHeight: 300,
        value: _dropdownValueCategorieDebit,
        icon: const Icon(Icons.keyboard_arrow_down),
        items: Strings.listCategories
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          _idSelectCategorieDebit = Strings.listCategories.indexOf(newValue!);

          setState(() {
            _dropdownValueCategorieDebit = newValue;
          });
        },
      );
    });
  }

  StatefulWidget createDropdownButtonCredit() {
    setState(() {
      _idSelectCategorieDebit = -1;
      _dropdownValueCategorieDebit = Strings.listCategories[0];
    });
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return DropdownButton(
        style:
            TextStyle(color: Theme.of(context).primaryColorLight, fontSize: 16),
        menuMaxHeight: 300,
        value: _dropdownValueCategorieCredit,
        icon: const Icon(Icons.keyboard_arrow_down),
        items: Strings.listCategoriesRentree
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          _idSelectCategorieCredit =
              Strings.listCategoriesRentree.indexOf(newValue!);
          setState(() {
            _dropdownValueCategorieCredit = newValue;
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _arg = ModalRoute.of(context)!.settings.arguments as dynamic;
    if (_arg != '' && !_hasRecup) {
      _estEdit = true;
      fillFields();
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            Form(
              key: _formKeyDepense,
              child: Column(children: [
                Row(children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: ListTile(
                      title: const Text('Débit'),
                      leading: Radio(
                        value: false,
                        groupValue: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = value!;
                            _estDebit = true;
                            changeSymbol();
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: ListTile(
                      title: const Text('Crédit'),
                      leading: Radio(
                        value: true,
                        groupValue: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = value!;
                            _estDebit = false;
                            changeSymbol();
                          });
                        },
                      ),
                    ),
                  ),
                ]),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _fieldMontant,
                    decoration: InputDecoration(
                      label: const Text('Montant du débit: '),
                      prefix: Text(
                        _symbol,
                        style: const TextStyle(fontSize: 20),
                      ),
                      suffix: const Text(
                        ' €',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (valeur) {
                      if (valeur == null ||
                          valeur.isEmpty ||
                          double.tryParse(valeur)! < 0) {
                        _montant = -1;
                      } else {
                        _montant = double.tryParse(valeur)!;
                      }
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _fieldTitre,
                    decoration: const InputDecoration(label: Text('Titre : ')),
                    validator: (valeur) {
                      if (valeur == null || valeur.isEmpty) {
                        _titre = '';
                      } else {
                        _titre = valeur;
                      }
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Première date: ',
                        style: TextStyle(fontSize: 17)),
                    IconButton(
                      hoverColor: Colors.transparent,
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 31)),
                        );
                        if (pickedDate != null) {
                          pickedDate.add(const Duration(hours: 1));
                          String formattedDate =
                              DateFormat('dd-MM-yyyy hh:mm:ss')
                                  .format(pickedDate);

                          setState(() {
                            _date = formattedDate;
                            _datePrint =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                    ),
                    Text(_datePrint),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(10)),
                _estDebit
                    ? createDropdownButtonDebit()
                    : createDropdownButtonCredit(),
                const Padding(padding: EdgeInsets.all(10)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade400),
                  onPressed: () {
                    if (_formKeyDepense.currentState!.validate()) {
                      _estEdit ? sendRequestPatch() : sendRequest();
                      clearTextsFormDepense();
                    }
                  },
                  child: const Text("Valider"),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
