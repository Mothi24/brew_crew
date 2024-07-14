import 'package:brew_crew/models/fb_user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0','1','2','3','4'];

  String? _currName;
  String? _currSugars;
  int? _currStrength ;

  @override
  Widget build(BuildContext context) {
    
    final fbUser = Provider.of<FbUser?>(context);
    
    return StreamBuilder<FbUserData>(
      stream: DatabaseService(uid: fbUser!.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){

          FbUserData? fbUserData = snapshot.data;

          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const Text(
                  'Update your brew settings',
                  style: TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 28.0,),
                TextFormField(
                  initialValue: fbUserData!.name,
                  decoration: textInputDecoration.copyWith(hintText: 'Name'),
                  validator: (val) => val!.isEmpty ? 'Enter a name' : null,
                  onChanged: (val) {setState(() {
                    _currName = val;
                  });},
                ),
                const SizedBox(height: 25.0,),
                //dropdown goes here
                DropdownButtonFormField(
                  value: _currSugars ?? fbUserData.sugars,
                    decoration: textInputDecoration.copyWith(hintText: 'Select Sugars'),
                    items: sugars.map((sugar){
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar Sugars'),
                      );
                    }).toList(),
                    onChanged: (val){
                      setState(() {
                        _currSugars = val!;
                      });
                    }
                ),
                const SizedBox(height: 25.0,),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 10.0,),
                    Text(
                      'Strength',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0,),
                //slider
                Slider(
                  value: (_currStrength ?? fbUserData.strength)!.toDouble(),
                  min: 100.0,
                  max: 900.0,
                  divisions: 8,
                  activeColor: Colors.brown[_currStrength ?? fbUserData.strength!],
                  inactiveColor: Colors.brown[_currStrength ?? fbUserData.strength!],
                  onChanged: (val) {
                    setState(() {
                      _currStrength = val.round();
                    });
                  },
                ),
                const SizedBox(height: 20.0,),
                ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.brown),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      await DatabaseService(uid: fbUserData.uid).updateUserData(
                          _currSugars ?? fbUserData.sugars!,
                          _currName ?? fbUserData.name!,
                          _currStrength ?? fbUserData.strength!
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          );
        }
        else{
          return const Loading();
        }

      }
    );
  }
}
