import 'package:closet_snaps/src/models/arguments_model.dart';
import 'package:closet_snaps/src/widgets/switch_theme_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class DrawerHome extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const DrawerHome({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final colorIcon = Theme.of(context).colorScheme;
    return _buildDrawer(context,colorIcon);
  }

  Widget _buildDrawer(BuildContext context, ColorScheme colorScheme) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple,
            ),
            child: Text(
              'Mi Menú',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          Column(
            children: [
              ListTile(
                title: const Text('Mi Closet'),
                onTap: () {},
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.shirt,color: colorScheme.tertiary,size: 25,),
                title: const Text('Poleras'),
                onTap: () {
                  Navigator.pushNamed(context, 'closet-page',arguments: ArgumentsClosetModel('shirt','Poleras'));
                },
              ),
              ListTile(
                leading: 
                SvgPicture.asset(
                  'assets/pants-icon.svg',
                  color: colorScheme.tertiary,
                  width: 35,
                ),
                title: const Text('Pantalones'),
                onTap: () {
                  Navigator.pushNamed(context, 'closet-page',arguments: ArgumentsClosetModel('pants','Pantalones'));
                  /* scaffoldKey.currentState!.openDrawer(); */
                },
              ),
              ListTile(
                leading: Icon(Icons.settings,color: colorScheme.tertiary,),
                title: const Text('Sudaderas'),
                onTap: () {
                  Navigator.pushNamed(context, 'closet-page',arguments: ArgumentsClosetModel('hoodie','Sudaderas'));
                },
              ),
              ListTile(
                leading: SvgPicture.asset('assets/shoes-icon.svg',color: colorScheme.tertiary,width: 35,),
                title: const Text('Zapatos'),
                onTap: () {
                  Navigator.pushNamed(context, 'closet-page',arguments: ArgumentsClosetModel('shoes','Zapatos'));
                },
              ),
              const SwitchThemeWidget(),
            ],
          ),
          const SizedBox(height: 50,),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[300],
            child: Text(
              'Sigueme: @paolojoaquinp',
              style: TextStyle(fontSize: 16,color: Colors.black),
              
            ),
          ),
        ],
      ),
    );
  }

}