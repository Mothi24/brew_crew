import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading ? const Loading() : Scaffold(
      backgroundColor: Colors.brown [100],
      appBar: AppBar(
        backgroundColor: Colors.brown [400],
        elevation: 0.0,
        title: Text(
          'Brew Crew',
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: <Widget>[
          TextButton.icon(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
            ),
            onPressed: () {
              widget.toggleView();
            },
            label: Text('Sign In',style: GoogleFonts.openSans(fontWeight: FontWeight.w600),),
            icon: const Icon(Icons.login),
          ),
        ],
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 50.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Register',
                      style: GoogleFonts.openSans(
                        fontSize: 60.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0,),
                TextFormField(
                  decoration: emailInputDecoration,
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                const SizedBox(height: 20.0,),
                TextFormField(
                  decoration: passwordInputDecoration,
                  validator: (val) => val!.length < 6 ? 'Password length should be greater than 6' : null,
                  onChanged: (val){
                    setState(() {
                      password = val;
                    });
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 20.0,),
                ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.brown[300]!),
                  ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if(_formKey.currentState!.validate()){
                      dynamic res = await _auth.registerWithEmailAndPassword(email, password);
                      if(res == null){
                        setState(() {
                          error = 'Provide a valid email';
                          isLoading = false;
                        });
                      }
                    }
                  },
                  child: const Text('Register'),
                ),
                const SizedBox(height: 12.0,),
                Text(
                  error,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14.0
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
