import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/screens/home/brew_list.dart';
import 'package:brew_crew/screens/home/settings_form.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    showSettingsPanel(){
      showModalBottomSheet(
          context: context,
          builder: (context){
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 60.0),
              child: const SettingsForm(),
            );
          }
      );
    }

    return StreamProvider<List<Brew>>.value(
      value: DatabaseService().brews,
      initialData: const [],
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Brew Crew',
          style: GoogleFonts.openSans(fontWeight: FontWeight.w600),),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
              ),
              icon: const Icon(Icons.settings),
              onPressed:() {
                showSettingsPanel();
              },
            ),
            TextButton.icon(
              style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.black)
              ),
              onPressed: () async {
                await _auth.signOut();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/coffee_bg.png',),
              fit: BoxFit.cover
            ),
          ),
            child: BrewList(),
        ),
      ),
    );
  }
}
