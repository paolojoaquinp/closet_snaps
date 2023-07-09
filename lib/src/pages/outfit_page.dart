import 'dart:io';

import 'package:closet_snaps/src/models/outfit_model.dart';
import 'package:closet_snaps/src/providers/db_provider.dart';
import 'package:closet_snaps/src/utils/utils.dart' as utils;
import 'package:closet_snaps/src/widgets/clothes.dart';
import 'package:closet_snaps/src/widgets/snakbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:uuid/uuid.dart';

class OutfitPage extends StatefulWidget {
  const OutfitPage({Key? key}) : super(key: key);

  @override
  State<OutfitPage> createState() => _OutfitPageState();
}

class _OutfitPageState extends State<OutfitPage> {
  var uuid = Uuid();
  final formKey = GlobalKey<FormState>();
  ClothesModel clothesModel = ClothesModel();
  Shoes shoesModel = Shoes();
  String? fotoUrl;
  PickedFile? foto;
  List<dynamic> _clothes = [
    {'nombre':'Polera','tipo':'shirt'},
    {'nombre':'Pantalones','tipo':'pants'},
    {'nombre':'Zapatos','tipo':'shoes'},
    {'nombre':'Sudadera','tipo':'hoodie'},
  ];
  String? _opcionSeleccionada = 'shirt';
  
  Color colorMain = Colors.grey;
  Offset? _position;
  bool _guardando = false;
  bool _isStreet = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaner de Ropa'),
        actions: <Widget>[
          IconButton(onPressed: _seleccionarFoto, icon: const Icon(Icons.photo_size_select_actual)),
          IconButton(onPressed: _tomarFoto, icon: const Icon(Icons.camera_alt)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.blue,
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTapUp: (TapUpDetails details) {
                      setState(() {
                        _position = details.localPosition;
                        (() async {
                          colorMain = await _extraerColorDominante();
                          setState(() { });
                        })();
                      });
                    },
                    child: _mostrarFoto()
                  ),
                ),
                _crearColor(),
                _crearCategoria(),
                (_opcionSeleccionada == 'shoes') ? _crearSwitch(context) : Container(),
                _crearBoton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearSwitch(BuildContext context) {
    return SwitchListTile(
      title: Text('Es Zapato de calle?',
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary
        ),
      ),
      value: _isStreet, 
      onChanged: (value) {
          setState(() {
            _isStreet = value;
          });
      }
    );
  }

  Future<Color> _extraerColorDominante() async {
    try {
      if (foto != null) {
        final paletteGenerator = await PaletteGenerator.fromImageProvider(
          FileImage(File(foto!.path)),
          size: Size(300, 300),
          region: _position != null
              ? Rect.fromCenter(
                  center: _position!,
                  width: 10,
                  height: 10,
                )
              : null,
        );
        return paletteGenerator.dominantColor!.color;
      }
      if (fotoUrl != null) {
        final paletteGenerator = await PaletteGenerator.fromImageProvider(
          NetworkImage(fotoUrl!),
          size: Size(300, 300),
          region: _position != null
              ? Rect.fromCenter(
                  center: _position!,
                  width: 10,
                  height: 10,
                )
              : null,
        );
        return paletteGenerator.dominantColor!.color;
      } else {
        return Colors.white;
      }
    } catch(e) {
      return Colors.white;
    }
  }

  Widget _mostrarFoto() {
    if(fotoUrl != null) {
      return FadeInImage(
        image: NetworkImage(fotoUrl as String),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      return Image(
        image: AssetImage(foto?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }
  
  Widget _crearColor() {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24),
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: size.width * 0.45,
            child: FutureBuilder<Color>(
              future: _extraerColorDominante(),
              builder: (context,  snapshot) {
                return Text(
                  'Color identificado: ${snapshot.data?.toString() ?? 'Ninguno'}'
                );
              },
            ),
          ),
          const Spacer(),
          FutureBuilder<Color>(
            future: _extraerColorDominante(),
            builder: (context, snapshot) {
              return SizedBox(
                width: 120,
                child: (() {
                  switch (_opcionSeleccionada) {
                    case 'shirt':
                      return Shirt(snapshot.data ?? Colors.grey);
                    case 'pants':
                      return Pants(snapshot.data ?? Colors.grey);
                    case 'hoodie':
                      return Hoodie(snapshot.data ?? Colors.grey);
                    case 'shoes':
                      return Container(
                        height: 32,
                        child: ShoesWidget(isStreet: _isStreet,color:snapshot.data ?? Colors.grey)
                      );
                    default:
                      return Shirt(snapshot.data ?? Colors.grey);
                  }
                })(),
              );
            },
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> getOptionsDropdown() {
    List<DropdownMenuItem<String>> lista = [];
    _clothes.forEach((el) { 
      lista.add(DropdownMenuItem(
          value: el['tipo'] as String,
          child: Text(el['nombre'] as String,style: Theme.of(context).textTheme.bodyLarge),
      ));
    });

    return lista;
  }

  Widget _crearCategoria() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(Icons.select_all),
        SizedBox(width: 24,),
        Expanded(
          child: DropdownButton(
            isExpanded: true,
            value: _opcionSeleccionada,
            items: getOptionsDropdown(),
            onChanged: (opt) {
              setState(() {
                _opcionSeleccionada = opt;
              });
              clothesModel.type = _opcionSeleccionada;
            }
          ),
        ),
      ],
    );
  }

  Widget _crearBoton() {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      textStyle: TextStyle(color: Colors.white),
      backgroundColor: Colors.deepPurple
    );
    return ElevatedButton.icon(
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      style: raisedButtonStyle,
      onPressed: (!_guardando && colorMain!=Colors.grey) ? (() =>_submit(context)) : null
    );
  }

  void _submit(BuildContext context) async {
    final fechaActual = DateTime.now();
    try {
      final validar = formKey.currentState as FormState;
      if(!validar.validate()) return;
      formKey.currentState?.save();
      setState(() {
        _guardando = true;
      });
      if (_opcionSeleccionada == 'shoes') {
        setState(() {
            shoesModel.id = uuid.v4();
            shoesModel.color = colorMain.value.toRadixString(16);
            shoesModel.typeShoes = _isStreet ? 'street' : 'normal'; // PONER isStreet en FORM de la PAGE
            shoesModel.createdAt = fechaActual.millisecondsSinceEpoch.abs();
        });
        /* await DBProvider.db.deleteDatabase(); */
        await DBProvider.db.nuevoShoes(shoesModel);
      } else {
        setState(() {
          clothesModel.id = uuid.v4();
          clothesModel.color = colorMain.value.toRadixString(16);
          clothesModel.type = _opcionSeleccionada;
          clothesModel.createdAt = fechaActual.millisecondsSinceEpoch.abs();
        });
        await DBProvider.db.nuevoClothes(clothesModel);
      }
    } catch (e){
      showSnackBar(context, e.toString());
    } finally {
      showSnackBar(context, 'Registro guardado');
      Navigator.pop(context);
    }
  } 

  void showSnackBar(BuildContext context, String msg) {
    mostrarSnackbar(context,msg);
    setState(() {
      _guardando = false;
    });
  }

  void _seleccionarFoto() async {
   _procesarImagen(ImageSource.gallery);
  }

  void _tomarFoto() {
    _procesarImagen(ImageSource.camera);
  }
  _procesarImagen(ImageSource origen) async {
    try {
      foto = await ImagePicker.platform.pickImage(
        source: origen
      ) as PickedFile?;
      if(foto != null) {
        fotoUrl = null;   
      }
      colorMain = await utils.getColorPalette(fotoUrl,foto);
      setState(() {});
    } catch(e) {
      rethrow;
    }
  }
}