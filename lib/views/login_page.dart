import 'package:lottie/lottie.dart';

import '../controllers/login_controller.dart';
import '../headers.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final control = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie Animation
              Lottie.asset(
                Assets.recording, // Replace with your Lottie file path
                height: 200,
              ),
              const SizedBox(height: 50),
              // Title
              Text(
                'Welcome to AI Voice Task Maker',
                textAlign: TextAlign.center,
                style: TxtStyles.regularPoppins22(
                  Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              // Google Auth Button
              Obx(
                () => ElevatedButton.icon(
                  onPressed:
                      control.isLoading.value ? null : control.loginWithGoogle,
                  icon: Image.asset(
                    Assets.googleLogo,
                    height: 24,
                    width: 24,
                  ),
                  label: control.isLoading.value
                      ? const CircularProgressIndicator.adaptive()
                      : Text(
                          'Sign in with Google',
                          style: TxtStyles.regularWorkSans16(Colors.black),
                        ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
