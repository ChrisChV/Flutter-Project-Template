import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_template/interfaces/modules/authentication/login/login_index.dart';
import 'package:flutter_project_template/interfaces/modules/contact/contact_index.dart';

class TabbedAppBarSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: choices.length,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Flutter project template'),
              bottom: TabBar(
                isScrollable: true,
                tabs: choices.map((Choice choice) {
                  return Tab(
                    text: choice.title,
                    icon: Icon(choice.icon),
                  );
                }).toList(),
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                Login(),
                Contact(),
              ],
            )
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});
  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'LOGIN', icon: Icons.view_agenda),
  const Choice(title: 'CONTACT', icon: Icons.info),
];