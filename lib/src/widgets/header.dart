import 'package:closet_snaps/src/user_preferences/user_preferences.dart';
import 'package:closet_snaps/src/utils/utils.dart';
import 'package:flutter/material.dart';

class HeaderHome extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HeaderHome({super.key,required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final prefs = UserPreferences();
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.12,
      padding: EdgeInsets.only(bottom: 12.0, left: 12.0,right: 12.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              'ClosetSnaps',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: const Color.fromRGBO(74, 20, 140, 1),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
                scaffoldKey.currentState?.openEndDrawer();
            },
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(getFirstCharacterUpperCase(prefs.nombre),
                style: const TextStyle(
                color: Colors.white
              )),
            ),
          ),
        ],
      ),
    );
  }
}


class HeaderWave extends StatelessWidget {
  final Color color;
  const HeaderWave({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      /* color: Color(0xff615AAB), */
      child: CustomPaint(
        painter: _HeaderWavePainter(this.color),
      ),
    );
  }
}

class _HeaderWavePainter extends CustomPainter {
  final Color color;

  _HeaderWavePainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint(); // tambien se puede llamar lapiz
    // Propiesdades
    paint.color = this.color;//Color(0xff615AAB);
    paint.style = PaintingStyle.fill; // .fill .stroke
    paint.strokeWidth = 20;

    final path = new Path();

    // Dibujar con el path y el lapiz
    /* path.moveTo(0, size.height * 0.50); */ // mover
    path.lineTo(0, size.height * 0.85);
    path.quadraticBezierTo(size.width * 0.25, size.height * 1.1, size.width * 0.5, size.height * 0.85);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.65, size.width, size.height * 0.85);
    /* path.lineTo(size.width, size.height * 0.25); */
    path.lineTo(size.width, 0);


/*     path.lineTo(size.width, 0); */
/*     path.lineTo(0, 0); // no es necesario porque lo va a pintar(superponer) */

    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}