
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testnura/ui/Authantication/logi.dart';
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // String? name,phone,address,username, password;
  bool processing = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print("registration successfully completed");
            Navigator.push(context, MaterialPageRoute(builder:(ctx)=>LoginPage()));
      // User signed up successfully, navigate to the next screen or perform other actions
      print('User signed up: ${userCredential.user!.uid}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print('Error: ${e.message}');
      }
    } catch (e) {
      print('Error: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
            children: [
               SizedBox(
                  height: 50,
                ),
                Text(
                  "Register Account",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "complete you details",
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 28,
                ),
              Form(
        key: _formkey,
        child: Column(
              children: [  

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          decoration:
                              InputDecoration.collapsed(hintText: "Email"),
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter your Email text";
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          decoration:
                              InputDecoration.collapsed(hintText: "Password"),
                          controller: _passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter your password text";
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width ,
                    child: TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            primary: Colors.white,
                            backgroundColor: Colors.black),
                        onPressed: _signUp,
                        child: Text(
                          "Register",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )),
                  ),
                ),
                SizedBox(height: 20,),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Do you have an account?",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder:(ctx)=>LoginPage()));
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
        ),
      ),
            ],
          )),
    );
  }

}
