import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ytbot/components/my_button.dart';
import 'package:ytbot/components/my_textfield.dart';
import 'package:ytbot/components/square_tile.dart';
import 'package:ytbot/firebase/firebase_auth_services.dart';
import 'package:ytbot/components/toast.dart';
import 'package:ytbot/homepage.dart';
import 'package:ytbot/screens/url_screen.dart';

import '../components/validation_helper.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

   bool _isSigning = false;
   final FirebaseAuthService _auth = FirebaseAuthService();

  FirebaseAuth _auth1 = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  void _signUpWithGoogle() async {
    setState(() {
      _isSigning = true;
    });

    User? user = await signInWithGoogle();

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      try{
        showToast(message: "Welcome to the app.");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UrlPage()),
        );
        showToast(message: "User is successfully signed in");
      }
      catch(e) {
        print(e);
      }
    } else {
   // else ma pn jai che
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      // Trigger Google Sign In
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        // User canceled Google Sign In
        return null;
      }

      // Obtain GoogleSignInAuthentication object
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      // Create GoogleSignInCredential using the obtained authentication
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // Sign in with Google credential
      UserCredential authResult = await _auth1.signInWithCredential(credential);

      // Return the user
      return authResult.user;
    } catch (e) {
      print('Error signing in with Google: $e');
      // Handle the error as needed
      return null;
    }
  }



  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(height: 20,),
                  // logo
                  Image.asset(
                    "assets/images/ytbot logo.png",
                    height: 130,
                  ),

                  const SizedBox(height: 50),

                  // welcome back, you've been missed!
                  Text(
                    'Welcome back',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // username textfield
                  MyTextField(
                    controller: _emailController,
                    obscureText: false, labelText: 'Username',
                    validator: ValidationHelper.validateEmail,
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: _passwordController,
                    obscureText: true,
                      labelText: 'Password',
                    validator: ValidationHelper.validatePassword,
                  ),

                  const SizedBox(height: 10),

                  // forgot password?
                  /*Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),*/

                  const SizedBox(height: 25),

                  // sign in button
                  MyButton(
                    onTap: _signIn,
                    txt: "Sign In",
                  ),

                  const SizedBox(height: 30),

                  // or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // google + apple sign in buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // google button
                      SquareTile(
                          onTap: (){
                            _signUpWithGoogle();
                          },
                          imagePath: 'assets/images/google.png'),

                      SizedBox(width: 25),

                      // apple button
                    ],
                  ),

                  const SizedBox(height: 30),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      showToast(message: "User is successfully signed in");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UrlPage(),));
    } else {
      showToast(message: "some error occured");
    }
  }
}


