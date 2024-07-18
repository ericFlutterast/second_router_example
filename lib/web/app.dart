import 'package:flutter/cupertino.dart';
import 'package:learning_navigator_api/web/common/widgets/app_material.dart';

class App extends StatelessWidget {
  const App({super.key});

  static run() => runApp(const App());

  @override
  Widget build(BuildContext context) {
    return const AppMaterial();
  }
}
