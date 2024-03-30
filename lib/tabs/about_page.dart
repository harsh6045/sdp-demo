import 'package:flutter/material.dart';
import 'package:ytbot/homepage.dart';
import 'package:ytbot/screens/url_screen.dart';

import '../components/my_drawer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(child: Text("Developer's Information",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white
                  ),)),
                SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height/6,
                            width: MediaQuery.of(context).size.width/4,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white, width: 2), // Add border here
                                borderRadius: BorderRadius.circular(21)
                            ),
                            child: Image.asset("assets/images/20240130_111241.jpg",
                              height: MediaQuery.of(context).size.height/7,
                              width: MediaQuery.of(context).size.width/4.9,),
                          ),
                        )
                      ],
                    ),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height/6,
                            width: MediaQuery.of(context).size.width/4,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white, width: 2), // Add border here
                                borderRadius: BorderRadius.circular(21)
                            ),
                            child: Image.asset("assets/images/20240130_112931.jpg",
                              height: MediaQuery.of(context).size.height/7,
                              width: MediaQuery.of(context).size.width/4.9,),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Text("Meet the Creators",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),),
            
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Hello there! We're a dynamic duo of developers explored the power of Flutter and decided to bring our ideas to life. Our journey began with a simple idea: to create an app that makes life easier for everyone. We're passionate about technology, innovation, and the endless possibilities it offers.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),),
                ),
            
                Text("Our Project",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),),
            
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Our project, YouTube ChatBot App, is a culmination of our shared vision and relentless pursuit of excellence. We've poured our hearts and minds into this app, aiming to solve real-world problems and enhance user experience. We believe in the transformative power of technology, and we're excited to share our creation with you.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),),
                ),

                Text("Why Choose Us?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),),


                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Innovation: We're always pushing the boundaries of what's possible with Flutter. Our app is a testament to our commitment to innovation.\nQuality: We strive for perfection in every aspect of our project. From the user interface to the underlying code, we ensure that our app is not just functional but also beautiful and intuitive.\nCommunity: We're part of the Flutter community, and we're proud to contribute to its growth. We're always open to feedback and eager to learn from others.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),),
                ),

                Text("Thank You",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Thank you for taking the time to learn more about us and our project. We hope you enjoy using YtBot Chat App as much as we enjoyed creating it.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),),
                ),

              ],
            ),
          )
      ),
    );
  }
}
