import 'package:closet_snaps/src/models/arguments_model.dart';
import 'package:closet_snaps/src/widgets/clothes.dart';
import 'package:closet_snaps/src/widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class ClosetPage extends StatelessWidget {
  const ClosetPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const CustomHeader(title: 'Smart Closet'),
            SingleChildScrollView(child: _botonesRedondos())
          ],
        ),
      )
    );
  }
  
  Widget _botonesRedondos() {
    return Table(
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            const _buttonCell(
              child: FaIcon(FontAwesomeIcons.shirt,color: Colors.white, size: 30.0,),
              titleCard: 'Poleras',
              route:'shirt'
            ),
            _buttonCell(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset('assets/pants-icon.svg',color: Colors.white,)),
              titleCard: 'Pantalones',
              route:'pants'
            ),
          ]
        ),
         TableRow(
          children: <Widget>[
            _buttonCell(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: SvgPicture.asset('assets/shoes-icon.svg',color: Colors.white,)),
              titleCard: 'Zapatos',
              route:'shoes'
            ),
            _buttonCell(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Hoodie(Colors.white,)),
              titleCard: 'Sudaderas',
              route:'hoodie'
            ),

          ]
        ),
         TableRow(
          children: <Widget>[
/*             _buttonCell(
              child: FaIcon(FontAwesomeIcons.listUl, color: Colors.white,),
              titleCard: 'Ver Todo',
              route: 'all'
            ), */
            Spacer(),
            Spacer()
          ]
        ),
      ],
    );
  }
}

class _buttonCell extends StatelessWidget {
  final Widget child;
  final String titleCard;
  final String route;
  const _buttonCell({
    required this.child,
    this.titleCard = 'Sin titulo',
    required this.route
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      height: 180.0,
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: theme.primary.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: MaterialButton(
        onPressed: () {
          Navigator.pushNamed(context, 'closet-page',arguments: ArgumentsClosetModel(route,titleCard));
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: theme.secondary,
                radius: 35.0,
                child: child,
              ),
              Text(titleCard,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}