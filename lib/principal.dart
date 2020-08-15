import 'package:flutter/material.dart';
import 'package:SSI/listaregistros.dart';
import 'constantes.dart';

class Principal extends StatelessWidget {
  final appTitle = 'Menu Principal SSI';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: PrincipalState(title: appTitle),
    );
  }
}

class PrincipalState extends StatelessWidget {
  final String title;

  PrincipalState({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Constantes.colorPrimario,),
      body: Center(child: Image(image: AssetImage('images/logo.png'),) ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                accountName: Text('Jonathan'),
                accountEmail: Text('jmartinez@applicartecr.com'),
                decoration: BoxDecoration(
                  color: Colors.black,
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image:  AssetImage('images/background.jpg'))),
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.art_track),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Registros'),
                  )
                ],
              ),
              onTap: () =>
              {
                Navigator.pop(context),
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ListaRegistros()),
                )
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}