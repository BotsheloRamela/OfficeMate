import 'package:firebase_core/firebase_core.dart';
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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<OfficeDetailsViewModel>(create: (_) => OfficeDetailsViewModel()),
        ChangeNotifierProvider<OfficeManagerViewModel>(create: (_) => OfficeManagerViewModel()),
      ],
      child: const MainApp(),
    )
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
