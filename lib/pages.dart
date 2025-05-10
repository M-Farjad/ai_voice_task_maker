import 'headers.dart';

class Pages {
  Pages._();

  static const String init = '/';
  static const String home = '/home';
  static const String login = '/login';

  static List<GetPage<dynamic>>? getPages = [
    GetPage(
      name: init,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: home,
      page: () => const HomePage(),
    ),
    GetPage(
      name: login,
      page: () => LoginPage(),
    ),
  ];
}
