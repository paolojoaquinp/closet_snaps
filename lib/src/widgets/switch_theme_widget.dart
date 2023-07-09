import 'package:closet_snaps/src/pages/home_page.dart';
import 'package:closet_snaps/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SwitchThemeWidget extends StatefulWidget {
  const SwitchThemeWidget({super.key});

  @override
  State<SwitchThemeWidget> createState() => _SwitchThemeWidgetState();
}

class _SwitchThemeWidgetState extends State<SwitchThemeWidget> {
  bool _darkModeEnabled = true;

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    return SwitchListTile(
      title: const Text('Modo oscuro'),
      value: _darkModeEnabled,
      onChanged: (bool value) {
        setState(() {
          _darkModeEnabled = value;
        });
        _toggleDarkMode(appTheme);
      },
    );
  }


  void _toggleDarkMode(ThemeChanger appTheme) {
    appTheme.darkTheme = !(appTheme.darkTheme);
  }
}
