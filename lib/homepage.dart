import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ytbot/components/my_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:ytbot/screens/url_screen.dart';
import 'chat_helper/message_tile.dart';
import 'components/toast.dart';
import 'login/login_or_register.dart';

class HomePage extends StatefulWidget {
  final String videourl;

  const HomePage({Key? key, required this.videourl}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  final TextEditingController videoIdController = TextEditingController();
  List<Map<String, dynamic>> chatHistory = [];
  String message = '';

  @override
  void initState() {
    super.initState();
    processVideoCap(widget.videourl);
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


  Future<void> processQuestion(String ques) async {
    try {
      final String apiUrl = 'https://ytbot-captions.vercel.app/process_output';
      final Map<String, dynamic> requestData = {'question': ques};

      print(videoIdController.text+"----------");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      ).timeout(Duration(seconds: 10), onTimeout: () {
        // This block will be executed if the request takes more than 10 seconds
        throw TimeoutException('The request took longer than 10 seconds');
      });

      print("request sent");

      if (response.statusCode == 200) {
        final Map<String, dynamic>? responseData = jsonDecode(response.body);
        print("status 200");
        if (responseData != null && responseData.containsKey('answer')) {
          setState(() {
            print("response came ");
            chatHistory.add({'message': responseData['answer'], 'sendByMe': false});
            print(responseData['answer']);
          });
        } else {
          print("Response data is null or does not contain 'response' key");
        }
      } else {
        setState(() {
          chatHistory.add({'message': 'Request failed with status: ${response.statusCode}', 'sendByMe': false});
        });
      }
    } catch (error, stackTrace) {
      if (error is TimeoutException) {
        // Handle the timeout exception
        setState(() {
          chatHistory.add({'message': 'Question Unrelated..! Please try asking a different question', 'sendByMe': false});
        });
      } else {
        print("Error: $error");
        print("Stack trace: $stackTrace");
      }
    }
  }






  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Chat here"),
          backgroundColor: Color(0xff1c4072),
          actions: <Widget>[

          ],
        ),

        body: WillPopScope(
          onWillPop: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UrlPage(),));
            return Future.value(false);},
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (chatHistory.isEmpty)
                  CircularProgressIndicator(),
                // Show chat history if available
                if (chatHistory.isNotEmpty)
                  Column(
                    children: chatHistory.map((messageData) {
                      return MessageTile(
                        message: messageData['message'],
                        sendByMe: messageData['sendByMe'],
                      );
                    }).toList(),
                  ),
                // Display "Enter the URL" text if no messages exist
                if (chatHistory.isEmpty)
                  Center(
                    child: Text("Enter the URL"),
                  ),
                SizedBox(height: 100,),
              ],
            ),
          ),
        ),


        bottomSheet: Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10),
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
                  message = videoIdController.text;
                  print(message);
                  print(videoIdController.text);
                  if (message.isEmpty) {
                    showToast(message: "Please enter a valid message...!");
                  } else {
                      // If it's not a YouTube URL, call another function or handle it differently
                      // For example, you might want to show a toast message or handle the message differently
                      chatHistory.add({'message': message, 'sendByMe': true});
                      processQuestion(message);
                      videoIdController.text = "";
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.send_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

