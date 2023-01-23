import 'package:bank_tracker/widgets.dart';
import 'package:flutter/material.dart';

class RecapPage extends StatefulWidget {
  const RecapPage({super.key, required this.title});
  final String title;

  @override
  State<RecapPage> createState() => RecapPageState();
}

class RecapPageState extends State<RecapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      drawer: Widgets.createDrawer(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text('Bank Tracker'),
          ],
        ),
      ),
    );
  }
}
