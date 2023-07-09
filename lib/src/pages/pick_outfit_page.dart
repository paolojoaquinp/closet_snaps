import 'package:closet_snaps/src/models/arguments_model.dart';
import 'package:closet_snaps/src/models/outfit_model.dart';
import 'package:closet_snaps/src/pages/home_page.dart';
import 'package:closet_snaps/src/providers/db_provider.dart';
import 'package:closet_snaps/src/utils/utils.dart' as utils;
import 'package:closet_snaps/src/widgets/clothes.dart';
import 'package:closet_snaps/src/widgets/outfit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

class PickOutfitPage extends StatefulWidget {
  const PickOutfitPage({Key? key}) : super(key: key);

  @override
  State<PickOutfitPage> createState() => _PickOutfitPageState();
}

class _PickOutfitPageState extends State<PickOutfitPage> {
  OutfitModel? outfitArgument;
  OutfitModel _outfitModel = new OutfitModel();
  int _indexType = 1;

  List<dynamic> _typesClothes = [
    {'nombre':'Color','tipo':'color'},
    {'nombre':'Tipo de Ropa','tipo':'type'},
  ];
  
  List<Widget Function(Color)> arr = [
    (Color color) => Shirt(color), /* shirt */
    (Color color) => Hoodie(color),/* hoodie */
  ];

  final listArr = <int,dynamic> {
    0 : [],/* shirt */
    1 : [],/* hoodies */
  };
  
  List<Shoes> _shoes = [];
  List<dynamic> _pants = [];

  @override
  void initState() {
    super.initState();


    DBProvider.db.getClothesByType('shirt').then((value) {
      setState(() {
        listArr[0] = value as List<dynamic>;
      });
    });
    DBProvider.db.getClothesByType('hoodie').then((value) {
      setState(() {
        listArr[1] = value as List<dynamic>;
      });
    });
    DBProvider.db.getClothesByType('pants').then((value) {
      setState(() {
        _pants = value as List<dynamic>;
      });
    });
    DBProvider.db.getShoes().then((value) {
      setState(() {
        if(value != null) {
          _shoes = value;
        }
      });
    });
  }



  String? _opcSel = 'color';
  int _selectedIndexUpper = 0;
/*   int _selectedIndexUpper1 = 0; */


  int _selectedIndexLower = 0;
  int _selectedIndexShoes = 0;
 
  String? keyId;

  void _previousClothes(List<dynamic> clothes, int selectedIndex, void Function(int) updateSelectedIndex) {
    if (selectedIndex > 0) {
      updateSelectedIndex(selectedIndex - 1);
    } else {
      updateSelectedIndex(clothes.length - 1);
    }
  }

  void _nextClothes(List<dynamic> clothes, int selectedIndex, void Function(int) updateSelectedIndex) {
    if (selectedIndex < clothes.length - 1) {
      updateSelectedIndex(selectedIndex + 1);
    } else {
      updateSelectedIndex(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color currentColorUpper = listArr[_indexType].isEmpty 
      ? Colors.transparent 
      : (listArr[_indexType][_selectedIndexUpper] != null ? utils.parseColorfromString(listArr[_indexType][_selectedIndexUpper].color ?? '000') : Colors.transparent );
  
    Color currentColorPants = _pants.isEmpty 
      ? Colors.transparent 
      : (_pants[_selectedIndexLower] != null ? utils.parseColorfromString(_pants[_selectedIndexLower].color ?? '000') : Colors.transparent );
    
    Color currentColorShoes = _shoes.isEmpty 
      ? Colors.transparent 
      : (_shoes[_selectedIndexShoes] != null ? utils.parseColorfromString(_shoes[_selectedIndexShoes].color ?? '000') : Colors.transparent );
    /* String isStreetCurrent = _shoes[_selectedIndexShoes].typeShoes ?? '0'; */
    return Scaffold(
      appBar: AppBar(title: Text('Selecciona Conjunto')),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 12),
            child: Column(
              children: [
                const Text('Estas cambiando:',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                _crearCategoria(context),
              ],
            ),
          ),
          Expanded(
            flex: 12,
            child: pickOutfitWidget(currentColorUpper,currentColorPants,currentColorShoes)
          ),
          Expanded(
            flex: 3,
            child: actionsPickOutfit(context)
          )
        ],
      ),
    );
  }

  
  Widget pickOutfitWidget(Color currentColorUpper,Color currentColorPants, Color currentColorShoes){
    return Column(
      children: <Widget>[
        Expanded(
          flex: 8,
          child: Row(
            children: <Widget>[
              Expanded(flex: 2,child: IconButton(
                  onPressed: _opcSel == 'color' ? () => _previousClothes(listArr[_indexType], _selectedIndexUpper, (index) => setState(() => _selectedIndexUpper = index)) :
                                                  () {_previousClothes(_typesClothes, _indexType, (index) => setState(() => _indexType = index));},
                  icon: FaIcon(FontAwesomeIcons.arrowLeft,)
              )),
              
              Expanded(flex: 8,child: listArr[_indexType].length > 0 ? arr[_indexType](currentColorUpper) : 
                   Center(child: Text( _indexType==0 ? "SIN POLERAS":"SIN SUDADERAS")
              )),
              
              Expanded(flex: 2,child: IconButton(
                  onPressed: _opcSel == 'color' ? () => _nextClothes(listArr[_indexType], _selectedIndexUpper, (index) => setState(() => _selectedIndexUpper = index)) :
                                                  () { _nextClothes(_typesClothes, _indexType, (index) => setState(() => _indexType = index));},
                  icon: FaIcon(FontAwesomeIcons.arrowRight,)))
            ],
          ),
        ),
        Expanded(flex:8, child: Row(
            children: <Widget>[
              Expanded(flex: 2,child: IconButton(onPressed: () => _previousClothes(_pants, _selectedIndexLower, (index) => setState(() => _selectedIndexLower = index)),icon: FaIcon(FontAwesomeIcons.arrowLeft,))),
              Expanded(flex: 8,child: Pants(currentColorPants ?? Colors.red)),
              Expanded(flex: 2,child: IconButton(onPressed: ()=> _nextClothes(_pants, _selectedIndexLower, (index) => setState(() => _selectedIndexLower = index)), icon: FaIcon(FontAwesomeIcons.arrowRight,)))
            ],
          ),),
        Expanded(flex:2, child: Row(
            children: <Widget>[
              Expanded(flex: 2,child: IconButton(onPressed: () => _previousClothes(_shoes, _selectedIndexShoes, (index) => setState(() => _selectedIndexShoes = index)), icon: FaIcon(FontAwesomeIcons.arrowLeft,))),
              Expanded(flex: 8,child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 8),
                child: ShoesWidget(
                  color:currentColorShoes,
                  isStreet: _shoes.isEmpty || _shoes[_selectedIndexShoes].typeShoes == 'street' ? true : false
                ),
              )),
              Expanded(flex: 2,child: IconButton(onPressed: () => _nextClothes(_shoes, _selectedIndexShoes, (index) => setState(() => _selectedIndexShoes = index)), icon: FaIcon(FontAwesomeIcons.arrowRight,)))
            ],
          ),),
      ],
    );
  }

  Widget _crearCategoria(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: DropdownButton(
            style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white38),
            isExpanded: true,
            value: _opcSel,
            items: getOptionsDropdown(),
            onChanged: (opt) {
              setState(() {
                _opcSel = opt;
              });
            }
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> getOptionsDropdown() {
    List<DropdownMenuItem<String>> lista = [];
    _typesClothes.forEach((el) { 
      lista.add(DropdownMenuItem(        
        child: Text(el['nombre'] as String),
        value: el['tipo'] as String
      ));
    });

    return lista;
  }

  Widget actionsPickOutfit(BuildContext context){
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      /* minimumSize: Size(88, 36), */
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );
    final args = ModalRoute.of(context)?.settings.arguments as ArgumentsCreateOutfit;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ElevatedButton(
            style: raisedButtonStyle,
            onPressed: () {
              Navigator.pushNamed(context, 'schedule-page');
            },
            child: Text('Generar automaticamente', style: TextStyle(fontSize: 12),),
          ),
          ElevatedButton(
            style: raisedButtonStyle.copyWith(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green) 
            ),
            onPressed: (listArr[_indexType].length>0 && _pants.isNotEmpty && _shoes.isNotEmpty)? () {
              final date = DateTime.now();
              /* if create {} else update {}*/
              var uuid = const Uuid();
              // Outfit Model
              _outfitModel.id = uuid.v4();
              _outfitModel.upper = listArr[_indexType][_selectedIndexUpper].id;
              _outfitModel.lower = _pants[_selectedIndexLower].id;
              _outfitModel.shoes = _shoes[_selectedIndexShoes].id;
              _outfitModel.createdAt = date.millisecondsSinceEpoch.abs();
              // Outfit 
              Color colorUpper = utils.parseColorfromString(listArr[_indexType][_selectedIndexUpper].color as String);
              Color colorPants = utils.parseColorfromString(_pants[_selectedIndexLower].color as String);
              Color colorShoes = utils.parseColorfromString(_shoes[_selectedIndexShoes].color as String);
              final outfitPrepared = Outfit(
                upperClothes: arr[_indexType](colorUpper),
                lowerClothes: Pants(colorPants),
                shoes: colorShoes,
                streetShoes: _shoes[_selectedIndexShoes].typeShoes == 'street' ? true : false
              );
              args.updateOutfit(args.keyId,_outfitModel,outfitPrepared);
              if(args.outfit.id == null || args.keyId.length < 13) {
                Navigator.pop(context);
              } else {
                setState(() {
                _selectedIndexLower = 0;
                _selectedIndexShoes = 0;
                _selectedIndexUpper = 0;
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              }
            } : null,
            child: Text('Guardar Conjunto'),
          ),
        ],
      ),
    );
  }
}