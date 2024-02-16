import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ytbot/components/my_drawer.dart';
import 'package:http/http.dart' as http;


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String url = 'https://retoolapi.dev/VT22Rn/flaskdata';
  String fetcheddata = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
    print("fetch doneeeeeeeeee");
  }

  void writeToApi(String data) async {
    final apiUrl = 'https://retoolapi.dev/VT22Rn/flaskdata';  // Replace with your API endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({'new data': data}),
      );

      if (response.statusCode == 201) {
        print('Data written to API successfully!');
      } else {
        print('Failed to write data to API. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
  void _fetchData() async {
    try {
      http.Response response = await http.get(
        Uri.parse(url), // Use correct API endpoint
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          print("settttttt dataaaaaaaaa");
          fetcheddata = jsonData.toString();
          print(fetcheddata);// Convert JSON to String
        });
      } else {
        // Handle API error gracefully
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
    }
  }

  final TextEditingController _textFieldController = TextEditingController();
  String _displayText = "data"; // Initial value for the body text

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title: Text("Chat here"),
          backgroundColor: Colors.orangeAccent,
        ),
        body: Text(_displayText), // Display the text here
        bottomSheet: Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _textFieldController, // Connect the controller
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
                  writeToApi(_textFieldController.text);
                  print("write cap doneeeeeee");
                  print(_textFieldController.text);
                  _displayText = fetcheddata;
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

Map<String, String> buildRequest(String apiUrl, String apiKey, String videoId) {
  return {
    'url': '$apiUrl?api_key=$apiKey&video_id=$videoId',
    // Add other parameters as needed
  };
}


/*
Future<String> fetchYouTubeCaptions(String videoId) async {
  final apiUrl = 'https://www.youtube.com/watch?v=JeU_EYFH1Jk';
  final apiKey = 'YOUR_YOUTUBE_API_KEY';

  final request = buildRequest(apiUrl, apiKey, videoId);

  final response = await performApiRequest(request);

  var captions = "";

  if (response.length > 0) {
    final firstObject = response[0];
    final baseUrl = firstObject['baseUrl'];
    print('Base url: $baseUrl');
    captions = await fetchAndProcessCaptionsFromBaseUrl(baseUrl);
  } else {
    captions = 'Invalid Video link or No English subtitle found!';
  }

  return captions;
}


Future<List<Map<String, dynamic>>> performApiRequest(Map<String, String> request) async {
  // Implement your logic to perform the API request here
  // Example using http package:
  final response = await http.get(Uri.parse(request['url']!));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return List<Map<String, dynamic>>.from(jsonResponse);
  } else {
    throw Exception('Failed to load captions');
  }
}

Future<String> fetchAndProcessCaptionsFromBaseUrl(String baseUrl) async {
  // Implement your logic to fetch and process captions from the base URL
  // Example:
  final response = await http.get(Uri.parse(baseUrl));

  if (response.statusCode == 200) {
    // Process the captions
    return response.body;
  } else {
    throw Exception('Failed to fetch captions from base URL');
  }
}

void main() async {
  // Example usage:
  final videoId = 'YOUR_YOUTUBE_VIDEO_ID';
  final captions = await fetchYouTubeCaptions(videoId);
  print(captions);
}*/
