import 'package:bank_tracker/class/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key, required this.title});
  final String title;

  @override
  State<InscriptionPage> createState() => InscriptionPageState();
}

class InscriptionPageState extends State<InscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  Tools _tools = Tools();
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _nom = '';
  String _prenom = '';
  double _solde = 0;
  Widget _col = Column();
  int _indexPage = 0;
  bool _obscureTextMdp = true;
  bool _obscureTextMdpConf = true;
  final _fieldNom = TextEditingController();
  final _fieldPrenom = TextEditingController();
  final _fieldEmail = TextEditingController();
  final _fieldPassword = TextEditingController();
  final _fieldPasswordConfirm = TextEditingController();
  final _fieldSolde = TextEditingController();

  void sendRequest() async {
    var response =
        await _tools.postUser(_email, _password, _nom, _prenom, _solde);
    if (response.statusCode == 201) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Vous êtes inscrit !'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Une erreur est survenue ${response.statusCode}'),
      ));
    }
  }

  void firstPage() {
    _col = Column(children: [
      Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1)),
      RichText(
        text: TextSpan(
            text: 'Nom: ',
            style: TextStyle(color: Theme.of(context).hintColor, fontSize: 18),
            children: const <TextSpan>[
              TextSpan(
                text: '* ',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )
            ]),
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.width * 0.15,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(20)),
        child: TextFormField(
          controller: _fieldNom,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            hintText: 'Dupond',
            floatingLabelAlignment: FloatingLabelAlignment.center,
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
          ),
          validator: (valeur) {
            if (valeur == null || valeur.isEmpty) {
              return 'Saisie vide';
            } else {
              _nom = valeur;
            }
          },
          onChanged: (value) {
            setState(() {
              _nom = value;
            });
          },
        ),
      ),
      Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1)),
      RichText(
        text: TextSpan(
            text: 'Prenom: ',
            style: TextStyle(color: Theme.of(context).hintColor, fontSize: 18),
            children: const <TextSpan>[
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )
            ]),
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.width * 0.15,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(20)),
        child: TextFormField(
          controller: _fieldPrenom,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            hintText: 'Paul',
            floatingLabelAlignment: FloatingLabelAlignment.center,
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
          ),
          validator: (valeur) {
            if (valeur == null || valeur.isEmpty) {
              return 'Saisie vide';
            } else {
              _prenom = valeur;
            }
          },
          onChanged: (value) {
            setState(() {
              _prenom = value;
            });
          },
        ),
      ),
    ]);
    setState(() {
      _col;
    });
  }

  void secondPage() {
    _col = Column(children: [
      Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1)),
      RichText(
        text: TextSpan(
            text: 'Email: ',
            style: TextStyle(color: Theme.of(context).hintColor, fontSize: 18),
            children: const <TextSpan>[
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )
            ]),
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.width * 0.15,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(20)),
        child: TextFormField(
          controller: _fieldEmail,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            hintText: 'compte@email.com',
            floatingLabelAlignment: FloatingLabelAlignment.center,
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
          ),
          validator: (valeur) {
            if (valeur == null || valeur.isEmpty) {
              return 'Veuillez saisir une email valide';
            } else {
              _email = valeur;
            }
          },
          onChanged: (value) {
            setState(() {
              _email = value;
            });
          },
        ),
      ),
      Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1)),
      RichText(
        text: TextSpan(
            text: 'Mot de passe: ',
            style: TextStyle(color: Theme.of(context).hintColor, fontSize: 18),
            children: const <TextSpan>[
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )
            ]),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.80,
            height: MediaQuery.of(context).size.width * 0.15,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(20)),
            child: TextFormField(
              controller: _fieldPassword,
              obscureText: _obscureTextMdp,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'monMotDePasse',
                floatingLabelAlignment: FloatingLabelAlignment.center,
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
              ),
              validator: (valeur) {
                if (valeur == null || valeur.isEmpty || valeur.length < 6) {
                  return 'Veuillez saisir un mot de passse valide (plus de 6 caractères)';
                } else {
                  _password = valeur;
                }
              },
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
            ),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  _obscureTextMdp = !_obscureTextMdp;
                });
              },
              icon: const Icon(Icons.remove_red_eye)),
        ],
      ),
      Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1)),
      RichText(
        text: TextSpan(
            text: 'Confirmer mot de passe: ',
            style: TextStyle(color: Theme.of(context).hintColor, fontSize: 18),
            children: const <TextSpan>[
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )
            ]),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.80,
            height: MediaQuery.of(context).size.width * 0.15,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(20)),
            child: TextFormField(
              controller: _fieldPasswordConfirm,
              obscureText: _obscureTextMdpConf,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'monMotDePasse',
                floatingLabelAlignment: FloatingLabelAlignment.center,
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
              ),
              validator: (valeur) {
                if (valeur == null || valeur.isEmpty || valeur != _password) {
                  return 'Mots de passe différents';
                } else {
                  _confirmPassword = valeur;
                }
              },
              onChanged: (value) {
                setState(() {
                  _confirmPassword = value;
                });
              },
            ),
          ),
          IconButton(
              alignment: AlignmentDirectional.centerEnd,
              onPressed: () {
                setState(() {
                  _obscureTextMdpConf = !_obscureTextMdpConf;
                });
              },
              icon: const Icon(Icons.remove_red_eye)),
        ],
      ),
    ]);
    setState(() {
      _col;
    });
  }

  void thirdPage() {
    _col = Column(children: [
      Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1)),
      RichText(
        text: TextSpan(
            text: 'Solde acutelle: ',
            style: TextStyle(color: Theme.of(context).hintColor, fontSize: 18),
            children: const <TextSpan>[
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )
            ]),
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.width * 0.15,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(20)),
        child: TextFormField(
          controller: _fieldSolde,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            hintText: '875.62',
            floatingLabelAlignment: FloatingLabelAlignment.center,
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          validator: (valeur) {
            if (valeur == null || valeur.isEmpty) {
              return 'Saisie non valide';
            } else {
              _solde = double.tryParse(valeur)!;
            }
          },
          onChanged: (value) {
            setState(() {
              _solde = double.parse(value);
            });
          },
        ),
      ),
      Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1)),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            sendRequest();
          }
        },
        child: const Text("Valider"),
      ),
    ]);
    setState(() {
      _col;
    });
  }

  void guessPage() {
    switch (_indexPage) {
      case 0:
        firstPage();

        break;
      case 1:
        if (_nom.isNotEmpty && _prenom.isNotEmpty) {
          secondPage();
        } else {
          _indexPage--;
        }
        break;
      case 2:
        if (_nom.isNotEmpty &&
            _prenom.isNotEmpty &&
            _email.isNotEmpty &&
            _password.isNotEmpty &&
            _confirmPassword.isNotEmpty) {
          thirdPage();
        }
        break;
    }
  }

  void incrementIndexPage() {
    if (_indexPage < 3) {
      _indexPage++;
      guessPage();
    }
  }

  void decrementIndexPage() {
    if (_indexPage != 0) {
      _indexPage--;
      guessPage();
    }
  }

  IconButton buttonNext() {
    IconButton result = const IconButton(onPressed: null, icon: Icon(null));
    if (_indexPage != 2) {
      result = IconButton(
          onPressed: incrementIndexPage,
          icon: const Icon(
            Icons.arrow_forward,
            size: 25,
          ));
    }
    return result;
  }

  IconButton buttonPrevious() {
    IconButton result = const IconButton(onPressed: null, icon: Icon(null));
    if (_indexPage != 0) {
      result = IconButton(
          onPressed: decrementIndexPage,
          icon: const Icon(
            Icons.arrow_back,
            size: 25,
          ));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    guessPage();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: _col,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buttonPrevious(),
            buttonNext(),
          ],
        ),
      ),
    );
  }
}
