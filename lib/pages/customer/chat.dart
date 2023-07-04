import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String txt = '';
  List<dynamic> organicResults = [];

  Future<void> processData(String query) async {
    var url =
        "https://serpapi.com/search.json?q=$query&location=Austin%2C+Texas%2C+United+States&hl=en&gl=us&google_domain=google.com&api_key=1459fd03facefa49b5a3b5d6a58ab84806527e65514a66c75e12d7cf0ddf8158";

    var result = await http.get(Uri.parse(url));

    if (kDebugMode) {
      print(result.body);
    }

    if (result.statusCode == 200) {
      var decodedResult = jsonDecode(utf8.decode(result.bodyBytes));
      if (decodedResult.containsKey('organic_results')) {
        setState(() {
          organicResults = decodedResult['organic_results'];
        });
      } else {
        setState(() {
          organicResults = [];
        });
      }
    } else {
      setState(() {
        organicResults = [];
      });
    }
  }

  final queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: organicResults.length,
              itemBuilder: (context, index) {
                var result = organicResults[index];
                return ListTile(
                  title: Text(result['title']),
                  subtitle: Text(result['snippet']),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: queryController,
                    decoration: const InputDecoration(
                      hintText: 'Enter text',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                IconButton(
                    onPressed: () {
                      processData(queryController.text);
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.black,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
