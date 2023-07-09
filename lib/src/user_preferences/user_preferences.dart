import 'package:shared_preferences/shared_preferences.dart';

/*
  Recordar instalar el paquete de:
    shared_preferences:
  Inicializar en el main
    final prefs = new PreferenciasUsuario();
    await prefs.initPrefs();
    
    Recuerden que el main() debe de ser async {...
*/

class UserPreferences {

  static final UserPreferences _instancia = new UserPreferences._internal();

  factory UserPreferences() {
    return _instancia;
  }

  UserPreferences._internal();

  SharedPreferences? _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del nombre
  int get currentIndex {
    return _prefs?.getInt('currentIndex') ?? 0;
  }

  set currentIndex( int value ) {
    _prefs?.setInt('currentIndex', value);
  }

  String get shirtColor {
    return _prefs?.getString('shirtColor') ?? 'red';
  }

  set shirtColor( String value ) {
    _prefs?.setString('shirtColor', value);
  }


  String get pantsColor {
    return _prefs?.getString('pantsColor') ?? 'red';
  }

  set pantsColor( String value ) {
    _prefs?.setString('pantsColor', value);
  }

  
  String get shoesColor {
    return _prefs?.getString('shoesColor') ?? 'black';
  }

  set shoesColor( String value ) {
    _prefs?.setString('shoesColor', value);
  }

  int get isStreetShoes {
    return _prefs?.getInt('isStreetShoes') ?? 0;
  }

  set isStreetShoes( int value ) {
    _prefs?.setInt('isStreetShoes', value);
  }
  String get scheduleId {
    return _prefs?.getString('scheduleId') ?? '';
  }

  set scheduleId( String value ) {
    _prefs?.setString('scheduleId', value);
  }
  
  String get nombre {
    return _prefs?.getString('nombre') ?? '';
  }

  set nombre(String value) {
    _prefs?.setString('nombre',value);
  }
  String get defaultRoute {
    return _prefs?.getString('defaultRoute') ?? 'on-boarding';
  }

  set defaultRoute(String value) {
    _prefs?.setString('defaultRoute',value);
  }

  // GET y SET de la última página
  /* int get paginaActual {
    return _prefs?.getInt('paginaActual') ?? 0;
  }

  set paginaActual(int value ) {
    _prefs?.setInt('paginaActual', value);
  } */

}
