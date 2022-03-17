import 'package:flutter/material.dart';
import 'package:lab0_tested_base/src/authentication/authentication_view.dart';
import 'package:lab0_tested_base/src/widgets/drawer/drawer_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  static const routeName = '/';
  static const homeViewScaffoldKey = Key('homeViewScaffoldKey');
  static const navToAuthIconButtonKey = Key('navToAuthIconButton');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeViewScaffoldKey,
      appBar: AppBar(
        title: const Text('Sample Items'),
        actions: [
          IconButton(
            key: navToAuthIconButtonKey,
            icon: const Icon(Icons.login_outlined),
            onPressed: () {
              Navigator.restorablePushNamed(
                  context, AuthenticationView.routeName);
            },
          ),
        ],
      ),
      drawer: const DrawerView(),
      body: Container(),
    );
  }
}
