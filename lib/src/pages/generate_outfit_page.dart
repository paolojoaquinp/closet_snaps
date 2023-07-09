import 'package:closet_snaps/src/models/arguments_model.dart';
import 'package:closet_snaps/src/models/outfit_model.dart';
import 'package:closet_snaps/src/providers/db_provider.dart';
import 'package:closet_snaps/src/widgets/custom_header.dart';
import 'package:closet_snaps/src/widgets/snakbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class GenerateOutfitPage extends StatefulWidget {
  const GenerateOutfitPage({Key? key}) : super(key: key);

  @override
  State<GenerateOutfitPage> createState() => _GenerateOutfitPageState();
}
enum SampleItem { itemOne, /* itemTwo, itemThree */ }

class _GenerateOutfitPageState extends State<GenerateOutfitPage> {
  ScheduleModel? firstSchedule;
  SampleItem? selectedMenu;
  @override


  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const CustomHeader(title:'Plan Semanal',),
          Expanded(child: _listItems(context,showPopUp))
        ],
      )
    );
  }

  void deleteRegister() {
    firstSchedule = null;
  }

  Widget showPopUp(String idSchedule) {
    return PopupMenuButton<SampleItem>(
      color: Colors.white,
      icon: const Icon(Icons.more_horiz,color: Colors.black,),
      initialValue: selectedMenu,
      onSelected: (SampleItem item) {
        setState(() {
          selectedMenu = item;
        });
        if(selectedMenu == SampleItem.itemOne) {
          DBProvider.db.deleteSchedule(idSchedule);
          deleteRegister();
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<SampleItem>>[
            const PopupMenuItem(
              value: SampleItem.itemOne,
              child: Text('Borrar'),
            ),
          ];
      }
    );
  }
  
  Widget _listItems(BuildContext context,showPopUp) {
    return Container(
      padding: const EdgeInsets.only(top: 16,left: 24, right: 24),
      child: Column(
        children: <Widget>[
          buttonCreateOutfit(context),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleView('Planificacion Actual'),
              FutureBuilder(
                future: DBProvider.db.obtenerUltimoScheduleActivo(),
                builder: (_, snapshot){
                  if(snapshot.hasData) {
                    final data = snapshot.data as ScheduleModel;
                    final initialDate = DateTime.fromMillisecondsSinceEpoch(data.initDate as int);
                    final limitDate = DateTime.fromMillisecondsSinceEpoch(data.endingDate as int);
                    final fechaInicio = DateFormat('EEEE dd', 'es').format(initialDate);
                    final fechaFin = DateFormat('EEEE dd', 'es').format(limitDate);
                    firstSchedule = data;
                    return _OutfitItem(
                      showPopUp,
                      data,
                      fechaInicio,
                      fechaFin
                    );
                  } else {
                    return const Center(child: Text(
                      'Sin datos'
                    ),);
                  }
                }
              ),
            ]
          ),
          titleView('Historial'),
          Expanded(
            flex: 6,
            child: FutureBuilder(
              future: DBProvider.db.obetenerHistorial(),
              builder: (_,snapshot) {
                if(snapshot.hasData) {
                  final data = snapshot.data as List<ScheduleModel>;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (_,int index) {
                      final elem = data[index] as ScheduleModel;
                      final initialDate = DateTime.fromMillisecondsSinceEpoch(elem.initDate as int);
                      final limitDate = DateTime.fromMillisecondsSinceEpoch(elem.endingDate as int);
                      final fechaInicio = DateFormat('dd/MM/yyyy').format(initialDate);
                      final fechaFin = DateFormat('dd/MM/yyyy').format(limitDate);
                      return _OutfitItem(
                        showPopUp,
                        elem,
                        fechaInicio,
                        fechaFin,
                      );
                    }
                  );
                } else {
                  return const Center(child: Text(
                    'Sin datos'
                  ),);
                }
              }
            ),
          )
        ],
      )
    );
  }

  Widget titleView(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(bottom: 25),
      child: Text(title,style: const TextStyle(fontSize: 28,fontWeight: FontWeight.w900),)
    );
  }

  Widget buttonCreateOutfit(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(2.0,5.0)
          )
        ]
      ),
      child: MaterialButton(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 24),
        onPressed: (){
          if(firstSchedule != null) {
            mostrarSnackbar(context, "No puede hacer la operacion:\nYa tienes una planificacion activa");
            return;
          } else {
            Navigator.pushNamed(context, 'create-outfit-page',arguments: ArgumentsGenerateOutfit(null, null));
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Nuevo',style: TextStyle(color: Colors.black),),
            FaIcon(FontAwesomeIcons.plus, color: Colors.black,)
          ],
        ),
      ),
    );
  }
}

class _OutfitItem extends StatelessWidget {
  final dynamic icon; 
  final ScheduleModel schedule;
  final String fechaInicio;
  final String fechaFin;
  const _OutfitItem(this.icon, this.schedule,this.fechaInicio,this.fechaFin);

  @override
  Widget build(BuildContext context) {
    final decorationBox = BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black,width: 1)
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      width: double.infinity,
      decoration: decorationBox,
      child: MaterialButton(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 24),
        onPressed: (){
          Navigator.pushNamed(context, 'create-outfit-page',arguments: ArgumentsGenerateOutfit(schedule, 'Mi Planificacion'));
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fecha Inicio: $fechaInicio.',style: TextStyle(color: Colors.black),),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fecha Fin: $fechaFin',style: TextStyle(color: Colors.black),),
                icon(schedule.id) as Widget
              ],
            ),
          ],
        ),
      ),
    );
  }
}