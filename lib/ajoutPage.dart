import 'package:bank_tracker/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AjoutPage extends StatefulWidget {
  const AjoutPage({super.key, required this.title});
  final String title;

  @override
  State<AjoutPage> createState() => AjoutPageState();
}

class AjoutPageState extends State<AjoutPage> {
  final _formKey = GlobalKey<FormState>();
  String _date = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String _dropdownValue = ' ';
  final List<String> _secteursActs = [
    ' ',
    'Jeux',
    'Restauration',
    'Loisirs',
    'Supermarché',
    'Véhicule',
    'Vie quotidienne',
    'Autres'
  ];
  int _idSelectSecteur = -1;
  Text _labelErrType = const Text('');

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
                    decoration: const InputDecoration(label: Text('Montant: ')),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    decoration:
                        const InputDecoration(label: Text('Débiteur : ')),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Text('Date : ')),
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
                DropdownButton(
                  menuMaxHeight: 300,
                  value: _dropdownValue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: _secteursActs
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    _idSelectSecteur = _secteursActs.indexOf(newValue!);
                    if (_secteursActs.indexOf(newValue) == 0) {
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
