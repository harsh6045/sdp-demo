import 'package:flutter/material.dart';
import 'package:ytbot/homepage.dart';
import 'package:ytbot/screens/url_screen.dart';

import '../components/my_drawer.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("About Us"),
        backgroundColor: Color(0xff1c4072),
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UrlPage(),));
          return Future.value(false);
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height/7,
                width: MediaQuery.of(context).size.width/4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(21)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/images/20240130_111241.jpg",
              height: MediaQuery.of(context).size.height/7,
              width: MediaQuery.of(context).size.width/4,),
            )
          ],
        )
      ),
    );
  }
}
