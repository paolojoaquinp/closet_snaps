import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  bool _darkTheme = false;
  ThemeData? _currentTheme;

  bool get darkTheme => this._darkTheme;
  ThemeData get currentTheme => this._currentTheme as ThemeData;

  ThemeChanger(int theme) {
    _currentTheme = ThemeData.dark();
    switch(theme) {
      case 1:
        darkTheme   = false;
      break;
      case 2:
        darkTheme   = true;
      break;
      default: 
        darkTheme = false;
        
    }
  }

  set darkTheme(bool value) {
    _darkTheme = value;
    if(value) {
      _currentTheme = ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.purple, 
          appBarTheme: const AppBarTheme(
            color: Colors.purple,
          ),
          textTheme: _currentTheme!.textTheme.copyWith(
            bodyLarge: _currentTheme!.textTheme.bodyMedium!.copyWith(
              color: Colors.white
            ),
            bodyMedium: _currentTheme!.textTheme.bodyMedium!.copyWith(
              color: Colors.white
            ),
          )
      ).copyWith(
          colorScheme: _currentTheme!.colorScheme.copyWith(
            secondary: Color(0xffFFCA3A),
            primary: Colors.purple,
            background: Colors.white,
            tertiary: Colors.white,
      ));
/*       _currentTheme = ThemeData.dark().copyWith(
          colorScheme: _currentTheme!.colorScheme.copyWith(
            secondary: Color(0xffFFCA3A),
            primary: Colors.purple,
            background: Colors.white,
            tertiary: Colors.white,
          )
        ); */
    } else {
      _currentTheme = ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.purple, 
          appBarTheme: const AppBarTheme(
            color: Colors.purple,
          ),
          textTheme: _currentTheme!.textTheme.copyWith(
            bodyLarge: _currentTheme!.textTheme.bodyMedium!.copyWith(
              color: Colors.black
            ),
            bodyMedium: _currentTheme!.textTheme.bodyMedium!.copyWith(
              color: Colors.black
            ),
          )
      ).copyWith(
          colorScheme: _currentTheme!.colorScheme.copyWith(
            secondary: Color(0xffFFCA3A),
            primary: Colors.purple,
            background: Colors.black87,
            tertiary: Colors.black
          )
      );
/*       _currentTheme = ThemeData.light().copyWith(
          colorScheme: _currentTheme!.colorScheme.copyWith(
            secondary: Color(0xffFFCA3A),
            primary: Colors.purple,
            background: Colors.black87,
            tertiary: Colors.black
          )
        ); */
    }
    notifyListeners();
  }
/*   set currentTheme(ThemeData value) {
    _currentTheme = value;
    notifyListeners();
  } */
}