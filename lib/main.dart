import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:owpet/firebase_options.dart';
import 'package:owpet/src/models/user.dart';
import 'package:owpet/src/providers/search_provider.dart';
import 'package:owpet/src/screens/Home/home_screen.dart';
import 'package:owpet/src/screens/Login/login_screen.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

import 'package:owpet/src/services/auth_service.dart';
import 'package:owpet/src/services/forum_service.dart';
import 'package:owpet/src/services/grooming_service.dart';
import 'package:owpet/src/services/pet_service.dart';
import 'package:owpet/src/services/meal_service.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MultiProvider(providers: [
    Provider<AuthService>(
      create: (_) => AuthService(),
    ),
    StreamProvider(
      create: (context) => context.read<AuthService>().authStateChanges,
      initialData: null,
    ),
    Provider<PetService>(
      create: (_) => PetService(),
    ),
    Provider<MealService>(
      create: (_) => MealService(),
    ),
    // Provider<GroomingService>(
    //   create: (_) => GroomingService(),
    // ),
    Provider<ForumService>(
      create: (_) => ForumService(),
    ),
    Provider<User>(
      create: (_) => User(
        id: '',
        email: '',
        name: '',
        password: '',
        telephone: '',
        description: '',
        photo: '',
      ),
    ),
    ChangeNotifierProvider(create: (_) => SearchProvider()),
  ], child: MyApp(settingsController: settingsController)));
  // runApp(ChangeNotifierProvider<AuthService>(
  //     create: (context) => AuthService(),
  //     child: MyApp()));
  // runApp(
  //   MultiProvider(
  // providers: [
  //   Provider<AuthService>(
  //     create: (_) => AuthService(),
  //   ),
  //   StreamProvider(
  //     create: (context) => context.read<AuthService>().authStateChanges,
  //     initialData: null,
  //   ),
  // ],
  //     child: MaterialApp(
  //       home: AuthWrapper(),
  //     ),
  //   )
  // );
}
