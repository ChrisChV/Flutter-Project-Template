import 'package:catcher/catcher_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_template/notifiers/implementations/AppUserNotifier.dart';
import 'package:flutter_project_template/pages/Contact.dart';
import 'package:flutter_project_template/pages/Login.dart';
import 'package:flutter_project_template/services/ErrorService.dart';
import 'package:flutter_project_template/services/FCMService.dart';
import 'package:flutter_project_template/services/remoteConf/RCService.dart';
import 'package:provider/provider.dart';

void main() async{
  Map<String, CatcherOptions> catcherConf = ErrorService.getCatcherConfig();
  WidgetsFlutterBinding.ensureInitialized();
  FCMService.initFCM();
  await RCService.initRemoteConf();
  Catcher(TabbedAppBarSample(),
      debugConfig: catcherConf['debug'],
      releaseConfig: catcherConf['release'],
      profileConfig: catcherConf['profile']
  );
}

class TabbedAppBarSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppUserNotifier(),),
      ],
      child: MaterialApp(
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
