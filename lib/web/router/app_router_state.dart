enum PageName {
  home(name: 'home'),
  chat(name: 'chat'),
  friends(name: 'friends'),
  profile(name: 'profile');

  const PageName({required this.name});

  final String name;
}

final class AppRouterState {
  AppRouterState.home()
      : pageName = PageName.home,
        isUnknown = false;
  AppRouterState.chat()
      : pageName = PageName.chat,
        isUnknown = false;
  AppRouterState.friends()
      : pageName = PageName.friends,
        isUnknown = false;
  AppRouterState.profile()
      : pageName = PageName.profile,
        isUnknown = false;
  AppRouterState.unknown() : isUnknown = true;

  PageName? pageName;
  final bool isUnknown;

  bool get isHome => pageName == PageName.home;
  bool get isChat => pageName == PageName.chat;
  bool get isFriends => pageName == PageName.friends;
  bool get isProfile => pageName == PageName.profile;
}
