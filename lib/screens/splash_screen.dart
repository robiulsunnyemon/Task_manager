import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    goToHomeScreen();
  }




  void goToHomeScreen()async{
    await Future.delayed(Duration(seconds: 3));
    if(mounted){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task,size: 200,color:Color(0xff6a5ae0),),
            Text("Version: 1.1.0",style: TextStyle(color: Colors.grey),),
            SizedBox(height: 10,),
            CircularProgressIndicator(color: Color(0xff6a5ae0),),
          ],
        )
      ),
    );
  }
}
