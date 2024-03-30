import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ytbot/homepage.dart';
import 'package:ytbot/screens/url_screen.dart';
import 'package:ytbot/tabs/about_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  navigateTo(String route, BuildContext context) {
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
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
                BorderRadius.only(),
                gradient: LinearGradient(
                    colors:  [
                      const Color(0xff205194),
                      const Color(0xff122f56)
                    ]
                )
            ),
            child: Text("YT BOT",
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}