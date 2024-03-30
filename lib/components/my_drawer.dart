import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ytbot/homepage.dart';
import 'package:ytbot/screens/url_screen.dart';
import 'package:ytbot/tabs/about_page.dart';

import '../login/login_or_register.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});


  navigateTo(String route, BuildContext context) {
    Navigator.of(context).pushReplacementNamed(route);
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginOrRegisterPage()),
      );
    } catch (e) {
      print(e); // Handle any errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(
                top: 70, bottom: 17, left: 25, right: 20),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius:
                const BorderRadius.only(),
                gradient: const LinearGradient(
                    colors:  [
                      Color(0xff205194),
                      Color(0xff122f56),
                    ]
                )
            ),
            child: const Text("YT BOT",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: 'OverpassRegular',
                  fontWeight: FontWeight.bold,
                ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UrlPage(),));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('About'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage(),));
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    signOut(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}