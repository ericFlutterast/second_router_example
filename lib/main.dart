import 'dart:io';

import 'package:flutter/material.dart';
import 'package:learning_navigator_api/web/home_web.dart';

/// Flutter code sample for [Navigator].

void main() {
  if (Platform.isAndroid || Platform.isIOS) {
    runApp(const NavigatorMobileExampleApp());
  }

  return runApp(const HomeWeb());
}

class NavigatorMobileExampleApp extends StatelessWidget {
  const NavigatorMobileExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //MaterialApp contains our top-level Navigator
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();

  static MainScreenState state(BuildContext context) {
    return context.findAncestorStateOfType<MainScreenState>() as MainScreenState;
  }
}

class MainScreenState extends State<MainScreen> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorState => _navigatorKey;

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Navigator(
          key: _navigatorKey,
          initialRoute: '/',
          onGenerateRoute: (RouteSettings settings) {
            return switch (settings.name) {
              '/' => CustomNavigator.createRout(
                  child: Container(
                    color: Colors.white70,
                    child: const Center(child: Text('Home')),
                  ),
                ),
              'chat' => CustomNavigator.createRout(
                  child: Container(
                    color: Colors.white70,
                    child: const Center(child: Text('Chat')),
                  ),
                ),
              'friends' => CustomNavigator.createRout(
                  child: Container(
                    color: Colors.white70,
                    child: const Center(child: Text('friends')),
                  ),
                ),
              'profile' => CustomNavigator.createRout(
                  child: Container(
                    color: Colors.white70,
                    child: const Center(child: Text('profile')),
                  ),
                ),
              _ => MaterialPageRoute(
                  builder: (context) {
                    return Container(
                      color: Colors.redAccent,
                      child: const Center(
                        child: Text(
                          "Page not found 404",
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            };
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        initValue: 0,
        selectedValue: (index) {},
      ),
    );
  }
}

class BottomNavigationBar extends StatefulWidget {
  const BottomNavigationBar({
    super.key,
    required this.initValue,
    required this.selectedValue,
  });

  final int initValue;
  final void Function(int) selectedValue;

  @override
  State<BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar> {
  late int _currentValue = widget.initValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1, color: Colors.black12.withOpacity(.6)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BottomNavButton(
              isActive: _currentValue == 0,
              onTap: () {
                MainScreen.state(context).navigatorState.currentState!.pushNamed('/');
                setState(() {
                  _currentValue = 0;
                });
                widget.selectedValue.call(_currentValue);
              },
              child: const Icon(Icons.home),
            ),
            BottomNavButton(
              isActive: _currentValue == 1,
              onTap: () {
                MainScreen.state(context).navigatorState.currentState!.pushNamed('chat');
                setState(() {
                  _currentValue = 1;
                });
                widget.selectedValue.call(_currentValue);
              },
              child: const Icon(Icons.chat),
            ),
            BottomNavButton(
              isActive: _currentValue == 2,
              onTap: () {
                MainScreen.state(context).navigatorState.currentState!.pushNamed('friends');
                setState(() {
                  _currentValue = 2;
                });
                widget.selectedValue.call(_currentValue);
              },
              child: const Icon(Icons.people),
            ),
            BottomNavButton(
              onTap: () {
                MainScreen.state(context).navigatorState.currentState!.pushNamed('profile');
                setState(() {
                  _currentValue = 3;
                });
                widget.selectedValue.call(_currentValue);
              },
              isActive: _currentValue == 3,
              child: const Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavButton extends StatefulWidget {
  const BottomNavButton({
    super.key,
    required this.onTap,
    required this.child,
    required this.isActive,
  });

  final void Function() onTap;
  final Widget child;
  final bool isActive;

  @override
  State<BottomNavButton> createState() => BottomNavButtonState();
}

class BottomNavButtonState extends State<BottomNavButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  double _height = 50;
  double _width = 50;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    if (widget.isActive) _animationController.forward();
  }

  @override
  void didUpdateWidget(covariant BottomNavButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isActive == widget.isActive) {
      return;
    }

    if (oldWidget.isActive) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      width: _width,
      child: GestureDetector(
        onTap: () {
          _animationController.forward();
          widget.onTap.call();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.isActive)
              ScaleTransition(
                scale: CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.linear,
                  reverseCurve: Curves.linear,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.shade300,
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            RotationTransition(
              turns: Tween<double>(
                begin: 0.0,
                end: widget.isActive ? 2.0 : 0.0,
              ).animate(_animationController),
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}

final class CustomNavigator {
  static void pushNamed({
    required final BuildContext context,
    required final String path,
  }) {
    Navigator.pushNamed(context, path);
  }

  static Route<T> createRout<T>({Widget? child}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, _) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeInCubic),
          child: child!,
        );
      },
    );
  }
}
