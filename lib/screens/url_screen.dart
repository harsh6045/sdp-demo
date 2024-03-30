import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ytbot/components/my_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:ytbot/homepage.dart';

import '../chat_helper/message_tile.dart';
import '../components/toast.dart';


class UrlPage extends StatefulWidget {
  const UrlPage({Key? key}) : super(key: key);

  @override
  State<UrlPage> createState() => _UrlPageState();
}

class _UrlPageState extends State<UrlPage> {
  final TextEditingController videoIdController = TextEditingController();
  List<Map<String, dynamic>> chatHistory = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> processVideoCap(String mssg) async {
    try {
      const String apiUrl = 'https://ytbot-captions.vercel.app/process_video';
      final Map<String, dynamic> requestData = {'video_id': mssg};

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );
      print("postttt done");

      if (response.statusCode == 200) {
        final Map<String, dynamic>? responseData = jsonDecode(response.body);
        if (responseData != null && responseData.containsKey('message')) {
          setState(() {
            chatHistory.add({'message': responseData['message'], 'sendByMe': false});
          });
          print(responseData['message']);
        } else {
          print("Response data is null or does not contain 'message' key");
        }
      } else {
        setState(() {
          chatHistory.add({'message': 'Request failed with status: ${response.statusCode}', 'sendByMe': false});
        });
      }
    } catch (error, stackTrace) {
      print("Error: $error");
      print("Stack trace: $stackTrace");
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
          backgroundColor: Color(0xff1c4072),
        ),
        drawer: MyDrawer(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height/3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                color: Colors.black45
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: videoIdController, // Connect the controller
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orangeAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          fillColor: Colors.grey.shade900,
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        String message = videoIdController.text;
                        if (message.isEmpty) {
                          showToast(message: "Please enter a valid message...!");
                        } else {
                          // Define a regex pattern to match YouTube URLs
                          final RegExp youtubeUrlPattern = RegExp(
                            r'^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.?be)\/.+$',
                            caseSensitive: false,
                          );

                          // Check if the message matches the YouTube URL pattern
                          if (youtubeUrlPattern.hasMatch(message)) {
                            // If it's a YouTube URL, call the function to process the video
                            chatHistory.add({'message': message, 'sendByMe': true});
                            processVideoCap(message);
                            print(message);// Assuming this function is defined elsewhere
                            videoIdController.text = "";
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage( videourl: message,),));
                          } else {
                            showToast(message: "Enter Valid Url");
                          }
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
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
                            BorderRadius.all(Radius.circular(21)),
                            gradient: LinearGradient(
                                colors:  [
                                  const Color(0xff3167b0),
                                  const Color(0xff1c4072)
                                ]
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Submit URL",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25
                          ),),
                        ),
                      )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      ),
    );
  }
}

