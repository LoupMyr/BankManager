import 'package:bank_tracker/class/local.dart';
import 'package:bank_tracker/class/tools.dart';
import 'package:bank_tracker/class/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key, required this.title});
  final String title;

  @override
  State<ProfilPage> createState() => ProfilPageState();
}

class ProfilPageState extends State<ProfilPage> {
  final Tools _tools = Tools();
  final _formEditEmail = new GlobalKey<FormState>();
  final _formEditPrenom = new GlobalKey<FormState>();
  final _formEditNom = new GlobalKey<FormState>();
  final _formEditSolde = new GlobalKey<FormState>();
  String _email = '';
  String _prenom = '';
  String _nom = '';
  double _solde = 0;
  Map<String, dynamic> _user = {};
  bool _hasRecup = false;
  String _idUser = '';
  Padding _gap = Padding(padding: EdgeInsets.symmetric(vertical: 15));

  Future<String> recupInfos() async {
    if (!_hasRecup) {
      _user = await Local.storage.readAll();
    }
    return '';
  }

  List<Widget> createList() {
    List<Widget> list = List.empty(growable: true);
    list.add(createRow(
        'Email: ', _user['email'], Icon(Icons.email_outlined), 0, 'email'));
    list.add(_gap);
    list.add(createRow(
        'Prenom: ', _user['prenom'], Icon(Icons.person_outline), 1, 'prenom'));
    list.add(_gap);
    list.add(createRow(
        'Nom: ', _user['nom'], Icon(Icons.assignment_ind_outlined), 2, 'nom'));
    list.add(_gap);
    list.add(createRow('Solde: ', _user['solde'],
        Icon(Icons.monetization_on_outlined), 3, 'solde'));

    return list;
  }

  Container createRow(
      String txt, var elt, Icon icon, int idMethod, String txtPopUp) {
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          icon,
          Padding(padding: EdgeInsets.only(right: 3)),
          Text(
            '$txt',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            idMethod == 3 ? '$elt €' : elt,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blueGrey.shade300, fontSize: 18),
          ),
          IconButton(
              onPressed: () => editMenu(elt, txtPopUp, txt, idMethod),
              icon: Icon(
                Icons.edit,
                size: 18,
              )),
        ]),
      ]),
    );
  }

  Future<String?> editMenu(
      String elt, String txt, String txtLabel, int idMethod) {
    GlobalKey<FormState> form = guessForm(idMethod);
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Modification $txt'),
        content: Form(
          key: form,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: TextFormField(
                  initialValue: elt,
                  decoration: InputDecoration(labelText: txtLabel),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Saisie vide';
                    } else {
                      guessModif(idMethod, value);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (form.currentState!.validate()) {
                      await guessMethod(idMethod);
                      _hasRecup = false;
                      await recupInfos();
                      setState(() {
                        createList();
                      });
                    }
                  },
                  child: const Text('Valider'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> guessMethod(int idMethod) async {
    _idUser = (await Local.storage.read(key: 'id'))!;
    switch (idMethod) {
      case 0:
        await editEmail();
        break;
      case 1:
        await editPrenom();
        break;
      case 2:
        await editNom();
        break;
      case 3:
        await editSolde();
        break;
    }
  }

  GlobalKey<FormState> guessForm(int idMethod) {
    GlobalKey<FormState> form = _formEditSolde;
    switch (idMethod) {
      case 0:
        form = _formEditEmail;
        break;
      case 1:
        form = _formEditPrenom;
        break;
      case 2:
        form = _formEditNom;
        break;
    }
    return form;
  }

  void guessModif(int idMethod, var elt) {
    switch (idMethod) {
      case 0:
        _email = elt;
        break;
      case 1:
        _prenom = elt;
        break;
      case 2:
        _nom = elt;
        break;
      case 3:
        _solde = double.parse(elt);
        break;
    }
  }

  Future<void> editEmail() async {
    var response = await _tools.patchEmail(_email, _idUser);
    if (response.statusCode == 200) {
      await Local.storage.write(key: 'email', value: _email);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Email modifié.'),
      ));
    }
    if (response.statusCode == 422) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Email déjà utilisé.'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Une erreur s\'est produite.'),
      ));
    }
  }

  Future<void> editPrenom() async {
    var response = await _tools.patchPrenom(_prenom, _idUser);
    if (response.statusCode == 200) {
      await Local.storage.write(key: 'prenom', value: _prenom);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Prenom modifié.'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Une erreur s\'est produite.'),
      ));
    }
  }

  Future<void> editNom() async {
    var response = await _tools.patchNom(_nom, _idUser);
    if (response.statusCode == 200) {
      await Local.storage.write(key: 'nom', value: _nom);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Nom modifié.'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Une erreur s\'est produite.'),
      ));
    }
  }

  Future<void> editSolde() async {
    var response = await _tools.patchSoldeByUserId(_solde, _idUser);
    if (response.statusCode == 200) {
      await Local.storage.write(key: 'solde', value: _solde.toString());
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Solde modifié.'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Une erreur s\'est produite.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: recupInfos(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Column colProfil = Column();
        if (snapshot.hasData) {
          colProfil = Column(
            children: createList(),
          );
        } else if (snapshot.hasError) {
          colProfil = Column(children: const [
            Icon(Icons.error_outline, color: Color.fromARGB(255, 255, 17, 0)),
          ]);
        } else {
          colProfil = Column(children: [
            SpinKitChasingDots(size: 150, color: Colors.teal.shade400),
          ]);
        }
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(widget.title),
          ),
          drawer: Widgets.createDrawer(context),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(child: colProfil),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
