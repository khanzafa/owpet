// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:owpet/src/models/user.dart';
// import 'package:owpet/src/screens/Komunitas/forum_screen.dart';
// import 'package:owpet/src/screens/Login/login_screen.dart';
// import 'package:owpet/src/screens/Login/register_screen.dart';
// import 'package:owpet/src/screens/Pets/add_pet_screen.dart';
// import 'package:owpet/src/screens/Makan/edit_meal_screen.dart';
// import 'package:owpet/src/screens/Home/home_screen.dart';
// import 'package:owpet/src/screens/Makan/meal_monitoring_screen.dart';
// import 'package:owpet/src/screens/Pets/my_pets_screen.dart';
// import 'sample_feature/sample_item_details_view.dart';
// import 'sample_feature/sample_item_list_view.dart';
// import 'settings/settings_controller.dart';
// import 'settings/settings_view.dart';
// import 'package:provider/provider.dart';
// import 'package:owpet/src/services/auth_service.dart';

// /// The Widget that configures your application.
// class MyApp extends StatelessWidget {
//   const MyApp({
//     super.key,
//     required this.settingsController,
//   });

//   final SettingsController settingsController;

//   @override
//   Widget build(BuildContext context) {
//     // Glue the SettingsController to the MaterialApp.
//     //
//     // The ListenableBuilder Widget listens to the SettingsController for changes.
//     // Whenever the user updates their settings, the MaterialApp is rebuilt.
//     // return ListenableBuilder(
//     //   listenable: settingsController,
//     //   builder: (BuildContext context, Widget? child) {
//     //     return MaterialApp(
//     //       home: MyHomeScreen(),
//     //       // Providing a restorationScopeId allows the Navigator built by the
//     //       // MaterialApp to restore the navigation stack when a user leaves and
//     //       // returns to the app after it has been killed while running in the
//     //       // background.
//     // restorationScopeId: 'app',

//     // // Provide the generated AppLocalizations to the MaterialApp. This
//     // // allows descendant Widgets to display the correct translations
//     // // depending on the user's locale.
//     // localizationsDelegates: const [
//     //   AppLocalizations.delegate,
//     //   GlobalMaterialLocalizations.delegate,
//     //   GlobalWidgetsLocalizations.delegate,
//     //   GlobalCupertinoLocalizations.delegate,
//     // ],
//     // supportedLocales: const [
//     //   Locale('en', ''), // English, no country code
//     // ],

//     // // Use AppLocalizations to configure the correct application title
//     // // depending on the user's locale.
//     // //
//     // // The appTitle is defined in .arb files found in the localization
//     // // directory.
//     // onGenerateTitle: (BuildContext context) =>
//     //     AppLocalizations.of(context)!.appTitle,

//     // // Define a light and dark color theme. Then, read the user's
//     // // preferred ThemeMode (light, dark, or system default) from the
//     // // SettingsController to display the correct theme.
//     // // theme: ThemeData(),
//     // // darkTheme: ThemeData.dark(),
//     // // themeMode: settingsController.themeMode,
//     // theme: ThemeData.light(),
//     // themeMode: ThemeMode.light,

//     //       // Define a function to handle named routes in order to support
//     //       // Flutter web url navigation and deep linking.
//     //       // onGenerateRoute: (RouteSettings routeSettings) {
//     //       //   return MaterialPageRoute<void>(
//     //       //     settings: routeSettings,
//     //       //     builder: (BuildContext context) {
//     //       //       switch (routeSettings.name) {
//     //       //         case SettingsView.routeName:
//     //       //           return SettingsView(controller: settingsController);
//     //       //         case SampleItemDetailsView.routeName:
//     //       //           return const SampleItemDetailsView();
//     //       //         case SampleItemListView.routeName:
//     //       //         default:
//     //       //           return const SampleItemListView();
//     //       //       }
//     //       //     },
//     //       //   );
//     //       // },
//     //       routes: {
//     //         '/home': (context) => MyHomeScreen(),

//     //         // ROUTES FOR TESTING ONLY (KALIAN KALAU MAU SLICING GANTI INI SAMA SCREEN KALIAN)
//     //         // '/': (context) => MealMonitoringScreen(petId: '2jwHq8GSHHxTgZ5orTeT'),
//     //         // '/' : (context) => ForumScreen(),
//     //         // '/' : (context) => MyPetsScreen(userId: 'qUtR4Sp5FAHyOpmxeD9l',),
//     //         // '/' : (context) => AddPetScreen(),
//     //         '/register' : (context) => RegisterScreen(),
//     //         '/login' : (context) => LoginScreen(),
//     //       },
//     //     );
//     //   },
//     // );

//     return MaterialApp(
//       home: AuthWrapper(),
//       routes: {
//         '/home': (context) => AuthWrapper(),
//         '/add_pet': (context) => AddPetScreen(userId: '',),
//         // '/edit_meal': (context) => EditMealScreen(),
//         // '/meal_monitoring': (context) => MealMonitoringScreen(),
//         // '/my_pets': (context) => MyPetsScreen(),
//         '/forum': (context) => ForumScreen(),
//         '/register': (context) => RegisterScreen(),
//         '/login': (context) => LoginScreen(),
//       },
//       restorationScopeId: 'app',

//       // Provide the generated AppLocalizations to the MaterialApp. This
//       // allows descendant Widgets to display the correct translations
//       // depending on the user's locale.
//       localizationsDelegates: const [
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: const [
//         Locale('en', ''), // English, no country code
//       ],

//       // Use AppLocalizations to configure the correct application title
//       // depending on the user's locale.
//       //
//       // The appTitle is defined in .arb files found in the localization
//       // directory.
//       onGenerateTitle: (BuildContext context) =>
//           AppLocalizations.of(context)!.appTitle,

//       // Define a light and dark color theme. Then, read the user's
//       // preferred ThemeMode (light, dark, or system default) from the
//       // SettingsController to display the correct theme.
//       // theme: ThemeData(),
//       // darkTheme: ThemeData.dark(),
//       // themeMode: settingsController.themeMode,
//       theme: ThemeData.light(),
//       themeMode: ThemeMode.light,
//     );
//   }
// }

// // class AuthenticationWrapper extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     final authService = Provider.of<AuthService>(context, listen: false);

// //     return FutureBuilder<User?>(
// //       future: authService.getActiveUser(),
// //       builder: (context, snapshot) {
// //         if (snapshot.connectionState == ConnectionState.waiting) {
// //           return CircularProgressIndicator();
// //         } else if (snapshot.hasData) {
// //           return MyHomeScreen();
// //         } else {
// //           return LoginScreen();
// //         }
// //       },
// //     );
// //   }
// // }

// class AuthWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final firebaseUser = context.watch<User?>();

//     if (firebaseUser != null) {
//       return FutureBuilder<User?>(
//         future: context.read<AuthService>().getCurrentUser(),
//         builder: (context, snapshot) {
//           print("Snapshot: $snapshot");
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasData) {
//             return MyHomeScreen(user: snapshot.data!);
//           } else {
//             return LoginScreen();
//           }
//         },
//       );
//     }
//     return LoginScreen();
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:owpet/src/models/user.dart';
import 'package:owpet/src/screens/Komunitas/forum_screen.dart';
import 'package:owpet/src/screens/Login/login_screen.dart';
import 'package:owpet/src/screens/Login/register_screen.dart';
import 'package:owpet/src/screens/Pets/add_pet_screen.dart';
import 'package:owpet/src/screens/Home/home_screen.dart';
import 'package:owpet/src/screens/Pets/my_pets_screen.dart';
import 'package:provider/provider.dart';
import 'package:owpet/src/services/auth_service.dart';
import 'settings/settings_controller.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;


class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;
  
  @override
  Widget build(BuildContext context) {
    final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

    return ListenableProvider<SettingsController>(
      create: (_) => settingsController,
      child: Consumer<SettingsController>(
        builder: (context, settingsController, child) {
          return MaterialApp(
            home: AuthWrapper(),
            routes: {
              '/home': (context) => AuthWrapper(),
              '/add_pet': (context) => AddPetScreen(userId: ''),
              '/forum': (context) => ForumScreen(),
              '/register': (context) => RegisterScreen(),
              '/login': (context) => LoginScreen(),
            },
            restorationScopeId: 'app',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
            ],
            onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,
            theme: ThemeData.light(),
            themeMode: ThemeMode.light,
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<auth.User?>();

    if (firebaseUser != null) {
      return FutureBuilder<User?>(
        future: context.read<AuthService>().getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return MyHomeScreen(user: snapshot.data!);
          } else {
            return LoginScreen();         
          }
        },
      );
    }
    return LoginScreen();    
  }
}
