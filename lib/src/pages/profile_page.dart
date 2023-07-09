import 'package:closet_snaps/src/widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const CustomHeader(title: 'Ajustes'),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20,),
              margin: const EdgeInsets.only(top: 20),
              child: const Column(
                children: <Widget>[
                  _ButtonPrimary(
                    FontAwesomeIcons.penToSquare,
                    'Editar Datos personales',
                    'edit'
                  ),
                  _ButtonPrimary(
                    FontAwesomeIcons.circleInfo,
                    'Acerca de',
                    'about'
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 34, left: 20, right: 20),
            child: const Text('Hecho por @paolojoaquin. Copyright 2023 - Todos los izquierdos reservados.',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            )
          ),
        ],
      )
    );
  }
}

class _ButtonPrimary extends StatelessWidget {
  final IconData icon;
  final String title;
  final String page;
  const _ButtonPrimary(this.icon,this.title, this.page,);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
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
          Navigator.pushNamed(context, page);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,style: TextStyle(color: Colors.black),),
            FaIcon(icon, color: Colors.black,)
          ],
        ),
      ),
    );
  }
}