import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_3/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //Intialize Firebase App
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState .done){
            return LoginScreen();
          }
          return const Center(
            child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }

}
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

 //Login function
 static Future<User?> loginUsingEmailPassword(
  {required String email,
   required String Password,
    required BuildContext context})async{
 FirebaseAuth auth = FirebaseAuth.instance;
 User? user;
 try{
  UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: Password);
  user = userCredential.user;
   }on FirebaseAuthException catch (e){
    if(e.code == "user-not-found"){
      print("No User found for that email");
    }
   }

   return user;
 }
  @override
  Widget build(BuildContext context) {
    //create the textfiled controller 
    TextEditingController _emailcontroller = TextEditingController();
    TextEditingController _passwordController =TextEditingController();
    return Padding(
      padding:  const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
           const Text(
            "MyApp Title",
          style: TextStyle(
            color: Colors.black,
            fontSize:28.0,
            fontWeight: FontWeight.bold,
            ),
            ),
             const Text("Login to your App",
            style: TextStyle(
              color: Colors.black,
               fontSize: 44.0,
               fontWeight: FontWeight.bold,
               ),
            ),
             const SizedBox(
              height: 44.0,
            ),
             TextField(
              controller: _emailcontroller,
              keyboardType: TextInputType.emailAddress,
              decoration:  const InputDecoration(
                hintText: "User Email",
                prefixIcon: Icon(Icons.mail,color: Colors.black),
              ),
            ),
             const SizedBox(
              height: 26.0,
            ),
             TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "User Password",
                prefixIcon: Icon(Icons.lock,color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
             const Text(
              "Don't Remember your Password?",
              style: TextStyle(color: Colors.blue),
            ),
             const SizedBox(
              height: 88.0,
            ),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: const  Color(0xFF0069FE),
                elevation: 0.0,
                padding: const  EdgeInsets.symmetric(vertical: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
                onPressed: ()async {
                  //let's test the app
                  User? user = await loginUsingEmailPassword(email: _emailcontroller.text, Password: _passwordController, context: context);
                  print(user);
                  if(user !=null){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ProfileScreen()));
                  }
                },
                child: const  Text("Login",
                style: TextStyle(
                  color: Colors.white,
                fontSize: 18.0,
                )),
                ),
            )
        ],
      ),
    );
  }
}


