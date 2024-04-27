import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:office_mate/firebase_options.dart';
import 'package:office_mate/ui/screens/home_screen.dart';
import 'package:office_mate/ui/viewmodels/office_details_viewmodel.dart';
import 'package:office_mate/ui/viewmodels/office_manager_viewmodel.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app on the web or on mobile devices with different configurations
  final runnableApp = _buildRunnableApp(
    isWeb: kIsWeb,
    webAppWidth: kIsWeb ? 600.0 : double.infinity,
    app: MultiProvider(
      providers: [
        ChangeNotifierProvider<OfficeDetailsViewModel>(create: (_) => OfficeDetailsViewModel()),
        ChangeNotifierProvider<OfficeManagerViewModel>(create: (_) => OfficeManagerViewModel()),
      ],
      child: const MainApp(),
    ),
  );

  runApp(
    runnableApp
  );
}

Widget _buildRunnableApp({
  required bool isWeb,
  required double webAppWidth,
  required Widget app,
}) {
  if (!isWeb) {
    return app;
  }

  return Center(
    child: ClipRect(
      child: SizedBox(
        width: webAppWidth,
        child: app,
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
