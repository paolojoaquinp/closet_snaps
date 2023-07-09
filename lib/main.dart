import 'package:closet_snaps/src/models/user_preferences_model.dart';
import 'package:closet_snaps/src/pages/about_page.dart';
import 'package:closet_snaps/src/pages/closet_detail_page.dart';
import 'package:closet_snaps/src/pages/create_outfit_page.dart';
import 'package:closet_snaps/src/pages/edit_profile_page.dart';
import 'package:closet_snaps/src/pages/home_page.dart';
import 'package:closet_snaps/src/pages/outfit_page.dart';
import 'package:closet_snaps/src/pages/pick_outfit_page.dart';
import 'package:closet_snaps/src/pages/schedule_page.dart';
import 'package:closet_snaps/src/pages/splash_set_name.dart';
import 'package:closet_snaps/src/theme/theme.dart';
import 'package:closet_snaps/src/user_preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('es');
  final prefs = UserPreferences();
  await prefs.initPrefs();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserPreferencesModel>(
          create: (_) => UserPreferencesModel()
        ),
        ChangeNotifierProvider<ThemeChanger>(
          create: (_) => ThemeChanger(2), // dark default = 2
        ),
    ],
    child: const MyApp()
  ));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    final prefs = UserPreferences();
    final appTheme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
        title: 'ClosetSnaps',
        debugShowCheckedModeBanner: false,
        initialRoute: prefs.defaultRoute,
        theme: appTheme.currentTheme,
        routes: {
          'home' :(BuildContext context) => const HomePage(),
          'about' :(BuildContext context) => const AboutPage(),
          'schedule-page' :(BuildContext context) => const SchedulePage(),
          'edit' :(BuildContext context) => const EditProfilePage(),
          'outfit-page' :(BuildContext context) => const OutfitPage(),
          'closet-page' :(BuildContext context) => const ClosetDetailPage(),
          'create-outfit-page' :(BuildContext context) => const CreateOutfitPage(),
          'pick-outfit-page' :(BuildContext context) => const PickOutfitPage(),
          'on-boarding': (BuildContext context) => const SetNamePage()
        }
    );
  }
}