import 'package:closet_snaps/src/models/arguments_model.dart';
import 'package:closet_snaps/src/models/outfit_model.dart';
import 'package:closet_snaps/src/models/user_preferences_model.dart';
import 'package:closet_snaps/src/pages/home_page.dart';
import 'package:closet_snaps/src/providers/db_provider.dart';
import 'package:closet_snaps/src/widgets/button_outfit.dart';
import 'package:closet_snaps/src/widgets/clothes.dart';
import 'package:closet_snaps/src/widgets/outfit.dart';
import 'package:closet_snaps/src/widgets/snakbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateOutfitPage extends StatefulWidget {
  const CreateOutfitPage();

  @override
  State<CreateOutfitPage> createState() => _CreateOutfitPageState();
  
}

class _CreateOutfitPageState extends State<CreateOutfitPage> {
  bool isCompleted=false;

  var schedule = <String,OutfitModel>{
    "first_ou"  : OutfitModel(),
    "second_ou" : OutfitModel(),
    "third_ou"  : OutfitModel(),
    "fourth_ou" : OutfitModel(),
    "fifth_ou"  : OutfitModel(),
    "sixth_ou"  : OutfitModel(),
    "seventh_ou": OutfitModel(),
  };
  var scheduleLayout = <String,Outfit>{
    "first_ou"  : Outfit(upperClothes: Shirt(Colors.black),lowerClothes: Pants(Colors.black),shoes: Colors.black,streetShoes: true,),
    "second_ou" : Outfit(upperClothes: Shirt(Colors.black),lowerClothes: Pants(Colors.black),shoes: Colors.black,streetShoes: true,),
    "third_ou"  : Outfit(upperClothes: Shirt(Colors.black),lowerClothes: Pants(Colors.black),shoes: Colors.black,streetShoes: true,),
    "fourth_ou" : Outfit(upperClothes: Shirt(Colors.black),lowerClothes: Pants(Colors.black),shoes: Colors.black,streetShoes: true,),
    "fifth_ou"  : Outfit(upperClothes: Shirt(Colors.black),lowerClothes: Pants(Colors.black),shoes: Colors.black,streetShoes: true,),
    "sixth_ou"  : Outfit(upperClothes: Shirt(Colors.black),lowerClothes: Pants(Colors.black),shoes: Colors.black,streetShoes: true,),
    "seventh_ou": Outfit(upperClothes: Shirt(Colors.black),lowerClothes: Pants(Colors.black),shoes: Colors.black,streetShoes: true,),
  };
  void updateOutfit(String keyDay, OutfitModel newOutfit, Outfit newLayout) {
    setState(() {
      schedule[keyDay] = newOutfit;
      scheduleLayout[keyDay] = newLayout;
    });
    verifyOuftitState();
  }
  void verifyOuftitState() {
    bool sw = true;
    schedule.forEach((key, value) {
      if((value.id ?? '').isEmpty){
        sw = false;
      }
    });
    setState(() {
      isCompleted = sw;
    });
  }

  void submmitButton(BuildContext context) async {
    try{
      var uuid = Uuid();
      final fechaActual = DateTime.now();
      final fechaDespuesUnaSemana = fechaActual.add(const Duration(days: 6));
      final scheduleModel = ScheduleModel();
      scheduleModel.id = uuid.v4();
      scheduleModel.firstOu = schedule["first_ou"]?.id;
      scheduleModel.secondOu = schedule["second_ou"]?.id;
      scheduleModel.thirdOu = schedule["third_ou"]?.id;
      scheduleModel.fourthOu = schedule["fourth_ou"]?.id;
      scheduleModel.fifthOu = schedule["fifth_ou"]?.id;
      scheduleModel.sixthOu = schedule["sixth_ou"]?.id;
      scheduleModel.seventhOu = schedule["seventh_ou"]?.id;
      scheduleModel.initDate = fechaActual.millisecondsSinceEpoch.abs();
      scheduleModel.endingDate = fechaDespuesUnaSemana.millisecondsSinceEpoch.abs();
      schedule.forEach((key, value) async {
        await DBProvider.db.nuevoOutfit(value);
      });
      await DBProvider.db.nuevoSchedule(scheduleModel);
      final userPreferences = Provider.of<UserPreferencesModel>(context, listen: false);
      userPreferences.scheduleActive = scheduleModel;
      if(context.mounted ) {
        mostrarSnackbar(context, 'Planificacion creada!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch(e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ArgumentsGenerateOutfit args = ModalRoute.of(context)?.settings.arguments as ArgumentsGenerateOutfit;
    return Scaffold(
      appBar: AppBar(title: Text(args.titlePage ?? 'Crear Plan Semanal')),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 12,
            child: args.schedule != null ? _botonesTablaFuture(args.schedule?.id as String) : _botonesTabla(),
          ),
          args.schedule != null ?
            Container() :
            Expanded(flex: 2,child: actionsCreateOutfit(context))
        ]
      )
    );
  }

  Widget actionsCreateOutfit(BuildContext context){
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      /* minimumSize: Size(88, 36), */
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );
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
            child: Text('Generar aleatoriamente', style: TextStyle(fontSize: 12),),
          ),
          ElevatedButton(
            style: raisedButtonStyle.copyWith(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green) 
            ),
            onPressed: isCompleted ? () => submmitButton(context) : null,
            child: Text('Crear nueva Planificacion'),
          ),
        ],
      ),
    );
  }

  Widget _botonesTabla() {
    final initDate = DateTime.now();
    return SingleChildScrollView(
      child: Table(
        children: <TableRow>[
          TableRow(
            children: <Widget>[
              BotonTabla(
                keyId:"first_ou",
                outfit:schedule["first_ou"],
                updateOutfit:updateOutfit,
                outfitLayout:scheduleLayout["first_ou"],
                date:initDate
              ),
              BotonTabla(
                keyId:"second_ou",
                outfit:schedule["second_ou"],
                updateOutfit:updateOutfit,
                outfitLayout:scheduleLayout["second_ou"],
                date: initDate.add(const Duration(days: 1))
                ),
              BotonTabla(
                keyId:"third_ou",
                outfit:schedule["third_ou"],
                updateOutfit:updateOutfit,
                outfitLayout:scheduleLayout["third_ou"],
                date: initDate.add(const Duration(days: 2))), 
            ]
          ),
          TableRow(
            children: <Widget>[
              BotonTabla(
                keyId:"fourth_ou",
                outfit:schedule["fourth_ou"],
                updateOutfit:updateOutfit,
                outfitLayout:scheduleLayout["fourth_ou"],
                date: initDate.add(const Duration(days: 3))),
              BotonTabla(
                keyId:"fifth_ou",
                outfit:schedule["fifth_ou"],
                updateOutfit:updateOutfit,
                outfitLayout:scheduleLayout["fifth_ou"],
                date: initDate.add(const Duration(days: 4))),
              BotonTabla(
                keyId:"sixth_ou",
                outfit:schedule["sixth_ou"],
                updateOutfit:updateOutfit,
                outfitLayout:scheduleLayout["sixth_ou"],
                date: initDate.add(const Duration(days: 5))),
            ]
          ),
          TableRow(
            children: <Widget>[
              Spacer(),
              BotonTabla(
                keyId:"seventh_ou",
                outfit:schedule["seventh_ou"],
                updateOutfit:updateOutfit,
                outfitLayout:scheduleLayout["seventh_ou"],
                date: initDate.add(const Duration(days: 6))),
              Spacer(),
            ]
          ),
        ],
      ),
    );
  }
  Widget _botonesTablaFuture(String idSchedule) {
    return FutureBuilder(
      future: DBProvider.db.obtenerOutfitsFromSchedule(idSchedule),
      builder: (_, snapshot){
        if(snapshot.hasData){
          final data = snapshot.data as Map<String,dynamic>;
          final widgets = data['widgets'];
          final initDate = DateTime.fromMicrosecondsSinceEpoch(data['initDate'] as int);
          return SingleChildScrollView(
            child: Table(
              children: <TableRow>[
                TableRow(
                  children: <Widget>[
                    BotonTabla(
                      keyId: "first_ou",
                      outfit: schedule["first_ou"],
                      updateOutfit: updateOutfit,
                      outfitLayout: widgets["first_ou"],
                      date: initDate,
                      isNull: true
                    ),
                    BotonTabla(
                      keyId:"second_ou",
                      outfit:schedule["second_ou"],
                      updateOutfit:updateOutfit,
                      outfitLayout:widgets["second_ou"],
                      date: initDate.add(const Duration(days: 1)),
                      isNull: true
                    ),
                    BotonTabla(
                      keyId:"third_ou",
                      outfit:schedule["third_ou"],
                      updateOutfit:updateOutfit,
                      outfitLayout:widgets["third_ou"],
                      date:initDate.add(const Duration(days: 2)),
                      isNull: true
                    ), 
                  ]
                ),
                TableRow(
                  children: <Widget>[
                    BotonTabla(
                      keyId:"fourth_ou",
                      outfit:schedule["fourth_ou"],
                      updateOutfit:updateOutfit,
                      outfitLayout:widgets["fourth_ou"],
                      date:initDate.add(const Duration(days: 3)),
                      isNull: true
                    ),
                    BotonTabla(
                      keyId:"fifth_ou",
                      outfit:schedule["fifth_ou"],
                      updateOutfit:updateOutfit,
                      outfitLayout:widgets["fifth_ou"],
                      date:initDate.add(const Duration(days: 4)),
                      isNull: true
                    ),
                    BotonTabla(
                      keyId:"sixth_ou",
                      outfit:schedule["sixth_ou"],
                      updateOutfit:updateOutfit,
                      outfitLayout:widgets["sixth_ou"],
                      date:initDate.add(const Duration(days: 5)),
                      isNull: true
                    ),
                  ]
                ),
                TableRow(
                  children: <Widget>[
                    Spacer(),
                    BotonTabla(
                      keyId:"seventh_ou",
                      outfit:schedule["seventh_ou"],
                      updateOutfit:updateOutfit,
                      outfitLayout:widgets["seventh_ou"],
                      date:initDate.add(const Duration(days: 6)),
                      isNull: true
                      
                    ),
                    Spacer(),
                  ]
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}