import 'dart:developer';

import 'package:bank_tracker/class/local.dart';
import 'package:bank_tracker/class/tools.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key, required this.title});
  final String title;

  @override
  State<ConnexionPage> createState() => ConnexionPageState();
}

class ConnexionPageState extends State<ConnexionPage> {
  final _formKey = GlobalKey<FormState>();
  Tools _tools = Tools();
  String _email = '';
  String _password = '';
  bool _obscureTextMdp = true;
  bool _isChecked = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _loadUserEmailPassword();
    super.initState();
  }

  void sendRequest() async {
    var response = await _tools.authentication(_email, _password);
    if (response.statusCode == 200) {
      var data = convert.jsonDecode(response.body);
      String solde = data['data']['solde'].toString();
      await Local.storage.write(key: 'token', value: data['token']);
      await Local.storage.write(key: 'prenom', value: data['data']['prenom']);
      await Local.storage.write(key: 'nom', value: data['data']['nom']);
      await Local.storage.write(key: 'roles', value: data['data']['roles'][0]);
      await Local.storage.write(key: 'solde', value: solde);
      await Local.storage.write(key: 'email', value: _email);
      await Local.storage.write(key: 'password', value: _password);
      Navigator.pushReplacementNamed(context, '/routeHome');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Bienvenue ${data['data']['prenom']} !'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Une erreur est survenue ${response.statusCode}'),
      ));
    }
  }

  void _loadUserEmailPassword() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.getString("email") ?? "";
      var password = prefs.getString("password") ?? "";
      var remeberMe = prefs.getBool("remember_me") ?? false;
      if (remeberMe) {
        setState(() {
          _isChecked = true;
        });
        _emailController.text = email;
        _passwordController.text = password;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void _handleRemeberme(bool value) {
    _isChecked = value;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool("remember_me", value);
        prefs.setString('email', _emailController.text);
        prefs.setString('password', _passwordController.text);
      },
    );
    setState(() {
      _isChecked = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/routeInscription'),
              icon: const Icon(Icons.person_add))
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.1)),
                const Text('Email: ', style: TextStyle(fontSize: 18)),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.width * 0.15,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                    controller: _emailController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'compte@email.com',
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      floatingLabelStyle: TextStyle(fontSize: 14),
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
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.1)),
                const Text('Mot de passe: ', style: TextStyle(fontSize: 18)),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.80,
                    height: MediaQuery.of(context).size.width * 0.15,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(20)),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureTextMdp,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'monMotDePasse',
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        floatingLabelStyle: TextStyle(fontSize: 14),
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                      ),
                      validator: (valeur) {
                        if (valeur == null || valeur.isEmpty) {
                          return 'Saisie vide';
                        } else {
                          _password = valeur;
                        }
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
                ]),
                const Padding(padding: EdgeInsets.all(20)),
                SizedBox(
                  height: 24.0,
                  width: 50.0,
                  child: Theme(
                    data: ThemeData(
                      unselectedWidgetColor: Colors.blue,
                    ),
                    child: Checkbox(
                      activeColor: Colors.blue,
                      value: _isChecked,
                      onChanged: (bool? value) {
                        _handleRemeberme(value!);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                const Text(
                  'Se souvenir de moi',
                  style: TextStyle(
                    color: Color(0xff646464),
                    fontSize: 12,
                    fontFamily: 'Rubic',
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.1)),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      sendRequest();
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
