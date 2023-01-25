import 'package:bank_tracker/class/decimalTextInputFormatter.dart';
import 'package:bank_tracker/class/strings.dart';
import 'package:bank_tracker/class/tools.dart';
import 'package:bank_tracker/class/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AjoutPage extends StatefulWidget {
  const AjoutPage({super.key, required this.title});
  final String title;

  @override
  State<AjoutPage> createState() => AjoutPageState();
}

class AjoutPageState extends State<AjoutPage> {
  final _formKey = GlobalKey<FormState>();
  Tools _tools = Tools();
  String _date = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String _dropdownValue = ' ';
  int _idSelectCategorie = -1;
  Text _labelErrType = const Text('');
  double _montant = -1;
  String _debiteur = '';
  String _remarques = '';
  final fieldRemarques = TextEditingController();
  final fieldMontant = TextEditingController();
  final fieldDebiteur = TextEditingController();

  void sendRequest() async {
    var response = await _tools.postDepense(
        _montant, _debiteur, _date, _idSelectCategorie.toString(), _remarques);
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Dépense ajouté'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Une erreur est survenue ${response.statusCode}'),
      ));
    }
  }

  void clearTexts() {
    fieldDebiteur.clear();
    fieldMontant.clear();
    fieldRemarques.clear();
    _dropdownValue = ' ';
    _idSelectCategorie = -1;
    _montant = -1;
    _debiteur = '';
    _remarques = '';
    _date = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      drawer: Widgets.createDrawer(context),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: fieldMontant,
                    decoration: const InputDecoration(label: Text('Montant: ')),
                    inputFormatters: [
                      DecimalTextInputFormatter(decimalRange: 2)
                    ],
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
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
                    controller: fieldDebiteur,
                    decoration:
                        const InputDecoration(label: Text('Débiteur : ')),
                    validator: (valeur) {
                      if (valeur == null || valeur.isEmpty) {
                        _debiteur = '';
                      } else {
                        _debiteur = valeur;
                      }
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Date : ', style: TextStyle(fontSize: 17)),
                    IconButton(
                      hoverColor: Colors.transparent,
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101));
                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                          setState(() {
                            _date = formattedDate;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                    ),
                    Text(_date),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                DropdownButton(
                  menuMaxHeight: 300,
                  value: _dropdownValue,
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
                        _labelErrType = const Text(
                          'Veuillez choisir une valeur',
                          style: TextStyle(color: Colors.red),
                        );
                      });
                    } else {
                      setState(() {
                        _labelErrType = const Text('');
                      });
                    }
                    setState(() {
                      _dropdownValue = newValue;
                    });
                  },
                ),
                _labelErrType,
                const Padding(padding: EdgeInsets.all(10)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextFormField(
                    controller: fieldRemarques,
                    maxLines: 5,
                    decoration: const InputDecoration(hintText: 'Remarques: '),
                    validator: (valeur) {
                      if (valeur == null || valeur.isEmpty) {
                        _remarques = '';
                      } else {
                        _remarques = valeur;
                      }
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      sendRequest();
                      clearTexts();
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
