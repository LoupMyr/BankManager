import 'package:bank_tracker/class/strings.dart';
import 'package:bank_tracker/class/tools.dart';
import 'package:bank_tracker/class/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PortefeuilleAjoutPage extends StatefulWidget {
  PortefeuilleAjoutPage({super.key, required this.title});
  String title;

  @override
  State<PortefeuilleAjoutPage> createState() => PortefeuilleAjoutPageState();
}

class PortefeuilleAjoutPageState extends State<PortefeuilleAjoutPage> {
  final Tools _tools = Tools();
  final _formKey = GlobalKey<FormState>();
  String _titre = '';
  double _montant = -1;
  int _duree = -1;
  String _dropdownValueDuree = 'Jours';
  int _idSelectDuree = 0;
  String _dropdownValueCategorie = 'Sélectionner une catégorie';
  int _idSelectCategorie = -1;
  Text _labelErrCategorie = const Text('');
  var _arg;
  bool _hasRecup = false;
  bool _estEdit = false;
  final _fieldTitre = TextEditingController();
  final _fieldMontant = TextEditingController();
  final _fieldDuree = TextEditingController();
  DateTime _selectedDateDebut = DateTime.now();
  String _dateDebut = '';
  DateTime _selectedDateFin = DateTime.now();
  String _dateFin = '';
  String _dateDebutPrint = '';
  String _dateFinPrint = '';

  IconButton selectDateDebut() {
    return IconButton(
      tooltip: 'Date de début',
      hoverColor: Colors.transparent,
      onPressed: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: _selectedDateDebut,
            firstDate: DateTime(2000),
            lastDate: DateTime(2101));
        if (pickedDate != null) {
          pickedDate.add(const Duration(hours: 1));
          String formattedDate =
              DateFormat('dd-MM-yyyy hh:mm:ss').format(pickedDate);
          setState(() {
            _dateDebut = formattedDate;
            _dateDebutPrint = DateFormat('dd-MM-yyyy').format(pickedDate);
            _selectedDateDebut = pickedDate;
          });
        }
      },
      icon: const Icon(Icons.calendar_today),
    );
  }

  IconButton selectDateFin() {
    return IconButton(
      tooltip: 'Date de fin',
      hoverColor: Colors.transparent,
      onPressed: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: _selectedDateFin,
            firstDate: DateTime(2000),
            lastDate: DateTime(2101));
        if (pickedDate != null) {
          pickedDate.add(const Duration(hours: 1));
          String formattedDate =
              DateFormat('dd-MM-yyyy hh:mm:ss').format(pickedDate);
          setState(() {
            _dateFin = formattedDate;
            _dateFinPrint = DateFormat('dd-MM-yyyy').format(pickedDate);
            _selectedDateFin = pickedDate;
          });
        }
      },
      icon: const Icon(Icons.calendar_today),
    );
  }

  Future<String> sendRequest() async {
    var response = await _tools.postPortefeuille(
        _titre, _montant, _dateDebut, _dateFin, _idSelectCategorie);
    if (response.statusCode == 201) {
      Navigator.restorablePopAndPushNamed(context, '/routePortefeuilleList');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Portefeuille crée'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Une erreur est survenue ${response.statusCode}'),
      ));
    }
    return '';
  }

  Future<String> sendPatchRequest() async {
    var response = await _tools.patchPortefeuille(_titre, _montant, _dateDebut,
        _dateFin, _idSelectCategorie, _arg['id'].toString());
    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/routePortefeuilleList');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Portefeuille modifié'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Une erreur est survenue ${response.statusCode}'),
      ));
    }
    return '';
  }

  void fillFields() {
    _hasRecup = true;
    widget.title = 'Modifier un portefeuille virtuel';
    _fieldTitre.value = TextEditingValue(text: _arg['titre']);
    _fieldMontant.value =
        TextEditingValue(text: _arg['montantInitial'].toString());
    _fieldDuree.value = TextEditingValue(text: _arg['duree'].toString());
    int idCate = int.parse(_tools.splitUri(_arg['categorie']));
    setState(() {
      _dateDebut = _arg['dateDebut'];
      _dateDebutPrint =
          DateFormat('dd-MM-yyyy').format(DateTime.parse(_arg['dateDebut']));
      _selectedDateDebut = DateTime.parse(_arg['dateDebut']);
      _dateFin = _arg['dateFin'];
      _dateFinPrint =
          DateFormat('dd-MM-yyyy').format(DateTime.parse(_arg['dateFin']));
      _selectedDateFin = DateTime.parse(_arg['dateFin']);
      _idSelectCategorie = idCate;
      _dropdownValueCategorie = Strings.listCategories[idCate];
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _fieldTitre,
                    decoration: const InputDecoration(
                      label: Text('Titre: '),
                    ),
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _fieldMontant,
                    decoration: const InputDecoration(
                      label: Text('Montant inital du portefeuille: '),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (valeur) {
                      if (valeur == null || valeur.isEmpty) {
                        _montant = -1;
                      } else {
                        _montant = double.parse(valeur);
                      }
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text('Date de début:'),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    Text('Date de fin:'),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_dateDebutPrint),
                    selectDateDebut(),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10)),
                    selectDateFin(),
                    Text(_dateFinPrint),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return DropdownButton(
                    style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 16),
                    menuMaxHeight: 300,
                    value: _dropdownValueCategorie,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: Strings.listCategories
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      _idSelectCategorie =
                          Strings.listCategories.indexOf(newValue!);
                      if (Strings.listCategories.indexOf(newValue) == 0) {
                        setState(() {
                          _labelErrCategorie = const Text(
                            'Veuillez choisir une valeur',
                            style: TextStyle(color: Colors.red),
                          );
                        });
                      } else {
                        setState(() {
                          _labelErrCategorie = const Text('');
                        });
                      }
                      setState(() {
                        _dropdownValueCategorie = newValue;
                      });
                    },
                  );
                }),
                _labelErrCategorie,
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade400),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_estEdit) {
                        sendPatchRequest();
                      } else {
                        sendRequest();
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Valider"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
