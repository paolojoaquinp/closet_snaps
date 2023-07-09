import 'package:closet_snaps/src/models/outfit_model.dart';
import 'package:closet_snaps/src/models/user_preferences_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Shirt extends StatelessWidget {
  Color color = Colors.red;
  Shirt(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      /* color: Color(0xff615AAB), */
      child: CustomPaint(
        painter: _ShirtPainter(color),
      ),
    );
  }
}

class _ShirtPainter extends CustomPainter {
  final Color color;
  _ShirtPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint() // tambien se puede llamar lapiz
    // Propiesdades
    ..color = color
    ..style = PaintingStyle.fill // .fill .stroke
    ..strokeWidth = 2;

    final paintBorder = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke // .fill .stroke
    ..strokeWidth = 1.5;


    final path = new Path();
    // Dibujar con el path y el lapiz
    path.moveTo(size.width * 0.3, 0);
    path.lineTo(0, size.height * 0.30);
    path.lineTo(size.width * 0.15, size.height * 0.45);
    path.lineTo(size.width * 0.3, size.height * 0.3);
    path.lineTo(size.width * 0.30, size.height);
    path.quadraticBezierTo(size.width * 0.5, size.height*1.05, size.width * .70, size.height );
    /* path.lineTo(size.width * 0.75, size.height); */
    path.lineTo(size.width * 0.70, size.height * 0.3);
    path.lineTo(size.width * 0.85, size.height * 0.45);
    path.lineTo(size.width, size.height * 0.30);
    path.lineTo(size.width * 0.7, 0);
    path.lineTo(size.width * 0.3, 0);

    canvas.drawPath(path, paintFill);
    canvas.drawPath(path, paintBorder);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Hoodie extends StatelessWidget {
  final Color color;

  Hoodie(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: .000001),
      alignment: Alignment.bottomCenter,
      child: SvgPicture.asset(
        'assets/hoodie.svg',
        color: color,
        matchTextDirection: true,
        semanticsLabel: 'Hoodie',
        fit: BoxFit.fill,
      ),
    );
  }
}

class ShoesWidget extends StatelessWidget {
  final Color color;
  final bool isStreet;
  ShoesWidget({
    this.color = Colors.black,
    this.isStreet = false
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: ShoeLeft(color),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isStreet ? Colors.white : color,
                    border: Border.all(color: isStreet ? Colors.black : color, width: 1)
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(flex: 2,child: Container(),),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: ShoeRight(color),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: isStreet ? Colors.white : color,
                    border: Border.all(color: isStreet ? Colors.black : color, width: 1)
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class Pants extends StatelessWidget {
  Color color = Colors.red;
  Pants(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      /* color: Color(0xff615AAB), */
      child: CustomPaint(
        painter: _PantsPainter(color),
      ),
    );
  }
}

class _PantsPainter extends CustomPainter {
  final Color color;
  _PantsPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint(); // tambien se puede llamar lapiz
    // Propiesdades
    paint.color = color;
    paint.style = PaintingStyle.fill; // .fill .stroke
    paint.strokeWidth = 2;

    final paintBorder = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke // .fill .stroke
      ..strokeWidth = 1.5;


    final path = new Path();

    // Dibujar con el path y el lapiz
    path.moveTo(size.width * 0.30, 0);
    path.lineTo(size.width * 0.25, size.height);
    path.lineTo(size.width * 0.4, size.height);
    path.lineTo(size.width * 0.5, size.height * 0.3);
    path.lineTo(size.width * 0.6, size.height);
    path.lineTo(size.width * 0.75, size.height);
    path.lineTo(size.width * 0.70, 0);
    path.quadraticBezierTo(size.width * 0.5, size.height* 0.01, size.width * .30, size.height * 0);

    canvas.drawPath(path, paint);
    canvas.drawPath(path, paintBorder);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
class ShoeLeft extends StatelessWidget {
  Color color = Colors.black;
  ShoeLeft(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      /* color: Color(0xff615AAB), */
      child: CustomPaint(
        painter: _ShoeLeftPainter(color),
      ),
    );
  }
}

class _ShoeLeftPainter extends CustomPainter {
  final Color color;
  _ShoeLeftPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint(); // tambien se puede llamar lapiz
    // Propiesdades
    paint.color = color;
    paint.style = PaintingStyle.fill; // .fill .stroke
    paint.strokeWidth = 20;

    final paintBorder = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke // .fill .stroke
      ..strokeWidth = .5;

    final path = new Path();

    // Dibujar con el path y el lapiz
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.01, size.height * 0.3, size.width, size.height * 0);
    canvas.drawPath(path, paint);
    canvas.drawPath(path, paintBorder);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
class ShoeRight extends StatelessWidget {
  Color color = Colors.black;
  ShoeRight(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      /* color: Color(0xff615AAB), */
      child: CustomPaint(
        painter: _ShoeRightPainter(color),
      ),
    );
  }
}

class _ShoeRightPainter extends CustomPainter {
  final Color color;
  _ShoeRightPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint(); // tambien se puede llamar lapiz
    // Propiesdades
    paint.color = color;
    paint.style = PaintingStyle.fill; // .fill .stroke
    paint.strokeWidth = 20;

    final paintBorder = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke // .fill .stroke
      ..strokeWidth = .5;

    final path = new Path();

    // Dibujar con el path y el lapiz
    /* path.moveTo(size.width, 0); */
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(size.width , size.height * 0.2, size.width * 0, size.height * 0);
    canvas.drawPath(path, paint);
    canvas.drawPath(path, paintBorder);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}