import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ytbot/components/my_drawer.dart';
import 'package:http/http.dart' as http;
import 'chat_helper/message_tile.dart';
import 'components/toast.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController videoIdController = TextEditingController();
  List<Map<String, dynamic>> chatHistory = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> processVideoCap() async {

    final String apiUrl = 'http://192.168.99.2:5000/process_video';
    final Map<String, dynamic> requestData = {'video_id': videoIdController.text};

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      setState(() {
        chatHistory.add({'message': responseData['message'], 'sendByMe': false});
      });
    } else {
      setState(() {
        chatHistory.add({'message': 'Request failed with status: ${response.statusCode}', 'sendByMe': false});
      });
    }
  }

  Future<void> processQuestion() async {
    final String apiUrl = 'http://192.168.99.2:5000/answer_question';
    final Map<String, dynamic> requestData = {'question': videoIdController.text};

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'question': 'application/json'},
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      setState(() {
        chatHistory.add({'response': responseData['response'], 'sendByMe': false});
      });
    } else {
      setState(() {
        chatHistory.add({'message': 'Request failed with status: ${response.statusCode}', 'sendByMe': false});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title: Text("Chat here"),
          backgroundColor: Color(0xff7eb5e1),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
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
                    fillColor: Colors.grey.shade200,
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
                      processVideoCap(); // Assuming this function is defined elsewhere
                      videoIdController.text = "";
                    } else {
                      // If it's not a YouTube URL, call another function or handle it differently
                      // For example, you might want to show a toast message or handle the message differently
                      chatHistory.add({'message': message, 'sendByMe': true});
                      processQuestion();
                      videoIdController.text = "";

                    }
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

