import 'package:ai_voice_task_maker/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'headers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(); // Load environment variables from .env file
  // Initialize GetX Controller
  Get.put(TaskController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Voice Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        // scaffoldBackgroundColor: Colors.grey[100],
        cardTheme: CardTheme(
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple[500],
        ),
      ),
      initialRoute: Pages.init,
      getPages: Pages.getPages,
    );
  }
}
