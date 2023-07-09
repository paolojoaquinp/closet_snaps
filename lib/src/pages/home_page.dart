import 'package:closet_snaps/src/models/arguments_model.dart';
import 'package:closet_snaps/src/models/outfit_model.dart';
import 'package:closet_snaps/src/models/user_preferences_model.dart';
import 'package:closet_snaps/src/pages/closet_page.dart';
import 'package:closet_snaps/src/pages/generate_outfit_page.dart';
import 'package:closet_snaps/src/pages/profile_page.dart';
import 'package:closet_snaps/src/providers/db_provider.dart';
import 'package:closet_snaps/src/user_preferences/user_preferences.dart';
import 'package:closet_snaps/src/utils/utils.dart';
import 'package:closet_snaps/src/widgets/drawer_home.dart';
import 'package:closet_snaps/src/widgets/header.dart';
import 'package:closet_snaps/src/widgets/no_data.dart';
import 'package:closet_snaps/src/widgets/outfit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  void changeTab(int? newTab) {
    setState(() {
      currentIndex = newTab as int;
    });
  }

  @override
  Widget build(BuildContext context) {
/*     final sizePage = MediaQuery.of(context).size; */
    final appState = Provider.of<UserPreferencesModel>(context);
    appState.changeTab = changeTab;
    return Scaffold(
      key: _scaffoldKey,
      body: _callPage(
        currentIndex,
        _scaffoldKey,
      ),
      bottomNavigationBar: _BottomNavigationBar(changeTab, currentIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, 'outfit-page'),
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
      // Just for Home Page
      endDrawer: DrawerHome(scaffoldKey: _scaffoldKey),
    );
  }
}

Widget _callPage(int currentIndex,GlobalKey<ScaffoldState> keyScaffold) {
  switch (currentIndex) {
    case 0:
      return _HomePage(scaffoldKey: keyScaffold);
    case 1:
      return const ClosetPage();
    case 2:
      return const GenerateOutfitPage();
    case 3:
      return const ProfilePage();
    default:
      return _HomePage(scaffoldKey: keyScaffold,);
  }
}

class _HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const _HomePage({super.key,required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
       HeaderHome(scaffoldKey: scaffoldKey),
       const _InfoHome(),
       const _ActionsHome(),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 25),
            padding: const EdgeInsets.only(top: 10,bottom: 20,left: 5,right: 5),
            width: size.width * 0.6,
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(20)
            ),
            child: FutureBuilder(
              future: DBProvider.db.obtenerOutfitDay(),
              builder:(_,snapshot){
                if(snapshot.hasData) {
                  final data = snapshot.data!['outfit'] as Outfit;
                  return Column(
                    children: [
                      Expanded(child: data),
                      SizedBox(height: 10,),
                      Text(obtenerDateFormatedInline(DateTime.now()),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )                        
                    ]
                  );
                } else {
                  return const NoDataWidget();
                }
              }
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoHome extends StatefulWidget {
  const _InfoHome({
    Key? key,
  }) : super(key: key);

  @override
  State<_InfoHome> createState() => _InfoHomeState();
}

class _InfoHomeState extends State<_InfoHome> {
  String _nombre = '';
  late UserPreferences _prefs;

  @override
  Widget build(BuildContext context) {
    _prefs = UserPreferences();
    _nombre = obtenerFirstWord(_prefs.nombre);
    return FutureBuilder(
      future: DBProvider.db.obtenerUltimoScheduleActivo(),
      builder: (_,snapshot) {
        if(snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20,),
            margin: const EdgeInsets.only(bottom: 10, top: 18),
            width: double.infinity,
            child: 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hola $_nombre!', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
                  const Text('Hoy tienes programado vestirte:',style: TextStyle(fontSize: 16))        
                ],
              )
          );
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20,),
            margin: const EdgeInsets.only(bottom: 10, top: 18),
            width: double.infinity,
            child: Text('Hola $_nombre!', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
          );
        }
      }
    );
  }
}

class _ActionsHome extends StatelessWidget {
  const _ActionsHome();

  void updateOutfitFromSchedule(String keyIdOldModel, OutfitModel newModel, Outfit layout) async {
    try {
      await DBProvider.db.actualizarOutfitPorId(keyIdOldModel, newModel);
    } catch (e){
      rethrow;
    }
  }

  void _handleButtonPress(BuildContext context, ScheduleModel data) async {
      final schedule = data.toJson();
      final outfitDay = await DBProvider.db.obtenerOutfitDay();
      final keyId = outfitDay?['key_id'];
      final outfit = await DBProvider.db.getOutfitById(schedule[keyId]) as OutfitModel;
      ArgumentsCreateOutfit args = ArgumentsCreateOutfit(
        outfit.id as String,
        outfit,
        updateOutfitFromSchedule,
        outfitDay?['outfit'],
        null,
      );
      Navigator.pushNamed(context, 'pick-outfit-page', arguments: args);
  }
  @override
  Widget build(BuildContext context) {
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
      child: FutureBuilder(
        future: DBProvider.db.obtenerUltimoScheduleActivo(),
        builder:(_,snapshot) {
          if(snapshot.hasData) {
            final data = snapshot.data as ScheduleModel;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  style: raisedButtonStyle.copyWith(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green) 
                  ),
                  onPressed: () => _handleButtonPress(context, data),
                  child: Text('Generar nuevo Outfit'),
              ),
              ElevatedButton(
              style: raisedButtonStyle, 
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  'create-outfit-page',
                  arguments: ArgumentsGenerateOutfit(data, 'Mi Planificacion')
                );
              },
              child: const Text('Ver mi planificacion semanal', style: TextStyle(fontSize: 12),),
            )]);
          } else {
            return Container();
          }
        }
      ),
    );
  }
}

typedef void handleTabs(int? newTab);

class _BottomNavigationBar extends StatefulWidget {
  final handleTabs changeTab;
  final int currentIndex;
  _BottomNavigationBar(this.changeTab, this.currentIndex);

  
  @override
  State<_BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<_BottomNavigationBar> {
  
  @override
  Widget build(BuildContext context) {
    final sizePage = MediaQuery.of(context).size;
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: sizePage.width * 0.45,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  bottomAppBarItem(0,FontAwesomeIcons.house, 'Home', widget.changeTab),
                  bottomAppBarItem(1,FontAwesomeIcons.shirt, 'Mi Closet',widget.changeTab),
                ],
              ),
            ),
            Container(
              width: sizePage.width * 0.45,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  bottomAppBarItem(2,FontAwesomeIcons.wandMagicSparkles, 'Generar',widget.changeTab),
                  bottomAppBarItem(3,FontAwesomeIcons.bars, 'Mis Datos',widget.changeTab),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget bottomAppBarItem(int nroTab, IconData icon, String texto, handleTabs changeTab) {
    final colorActive = Theme.of(context).colorScheme;
    return MaterialButton(
      minWidth: 30,
      onPressed: (){
        changeTab(nroTab);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FaIcon(icon, color: widget.currentIndex == nroTab ? colorActive.primary : colorActive.tertiary,),
          Text(texto, style: TextStyle(color: widget.currentIndex == nroTab ? colorActive.primary : colorActive.tertiary ),)
        ],
      ),              
    );
  }
}