import 'package:brew_crew/models/fb_user.dart';
import 'package:brew_crew/screens/authenticate/authenticate.dart';
import 'package:brew_crew/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final fbUser = Provider.of<FbUser?>(context);

    // Return Home or Authenticate based on the login status
    if(fbUser == null) {
      return const Authenticate();
    }
    else{
      return Home();
    }

  }
}
