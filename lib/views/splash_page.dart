import 'package:lottie/lottie.dart';
import '../headers.dart';
import '../services/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Check auth state and navigate accordingly
    Future.delayed(const Duration(seconds: 4), () async {
      final user = AuthService.currentUser;
      if (user != null) {
        // User is signed in
        Get.offAllNamed(Pages.home);
      } else {
        // User not signed in
        Get.offAllNamed(Pages.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          Assets.task,
          width: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
