import 'package:closet_snaps/src/user_preferences/user_preferences.dart';
import 'package:closet_snaps/src/widgets/snakbar.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String _nombre = '';
  late UserPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _prefs = UserPreferences(); 
    _nombre = _prefs.nombre;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Datos Personales'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            _inputEdit(context),
            _submit(_prefs,context)
          ],
        ),
      ),
    );
  }
  Widget _submit(UserPreferences prefs,BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );
    return ElevatedButton.icon(
      icon: Icon(Icons.download_done_outlined),
      style: raisedButtonStyle, 
      onPressed: () {
        prefs.nombre = _nombre;
        Navigator.pop(context);
        mostrarSnackbar(context, 'Nombre Guardado\n${_nombre}');
      },
      label: Text('Guardar', style: TextStyle(fontSize: 12),),
    );
  }

  Widget _inputEdit(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(color: theme.tertiary),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.tertiary, width: 2.0), // Establece el color y el ancho del borde cuando no está enfocado
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusColor: theme.tertiary,
        iconColor: theme.tertiary,
        labelStyle: TextStyle(color: theme.tertiary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        counter: Text('Letras ${_nombre.length}'),
        hintText: 'Nombre de la persona',
        helperText: 'Introduce tu nombre',
        suffixIcon: Icon(Icons.accessibility),
        icon: Icon(Icons.account_circle),
        labelText: _nombre
      ),
      onChanged: (valor) {
        setState(() {        
          _nombre = valor;
        });
      },
    );
  }
}