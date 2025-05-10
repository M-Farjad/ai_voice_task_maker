import '../headers.dart';

class LoginController extends GetxController {
  final isLoading = false.obs;
  final isRecording = false.obs;

  Future<void> loginWithGoogle() async {
    final user = await AuthService.signInWithGoogle();
    if (user != null) {
      Get.offAllNamed(Pages.home);
      Get.snackbar("Welcome", "Hello ${user.displayName}");
    }
  }
}
