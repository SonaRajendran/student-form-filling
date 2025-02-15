import 'package:flutter/material.dart';
import 'package:form/student_entry.dart';

 // Import the student details screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Data App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => StudentEntryScreen()));
    });
    
    return Scaffold(
      body: Center(child: Image.asset('assets/welcoming_logo.png')), // Your logo
    );
  }
}
