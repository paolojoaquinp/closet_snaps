import 'package:closet_snaps/src/models/user_preferences_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      /* minimumSize: Size(88, 36), */
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          const Text(
            "No tienes Planificación!",
            style: TextStyle(color: Colors.black,fontSize: 16),
          ),
          ElevatedButton(
              style: raisedButtonStyle.copyWith(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.purple) 
              ),
              onPressed: (){
                final appState = Provider.of<UserPreferencesModel>(context,listen: false);
                if(appState.changeTab != null) {
                  appState.changeTab!(2);
                }
              },
              child: const Text('Crear mi planificaion'),
          ),
        ]
      ),
    );
  }
}