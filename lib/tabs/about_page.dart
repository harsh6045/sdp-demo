import 'package:flutter/material.dart';

import '../components/my_drawer.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("About Us"),
        backgroundColor: Color(0xff7eb5e1),
      ),
      body: Center(
        child: Text('This is the About page.'),
      ),
    );
  }
}
