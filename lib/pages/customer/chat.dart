import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String txt = '';
  // initialize WebScraper by passing base url of website

  Future dataProccessed(String query) async {
    var url =
        "https://serpapi.com/search.json?q=$query&location=Austin%2C+Texas%2C+United+States&hl=en&gl=us&google_domain=google.com&api_key=1459fd03facefa49b5a3b5d6a58ab84806527e65514a66c75e12d7cf0ddf8158";

    var result = await http.get(
      Uri.parse(url),
    );
    if (kDebugMode) {
      print(result.body);
    }
    return result.statusCode == 200
        ? jsonDecode(utf8.decode(result.bodyBytes)) as Map
        : "Nothing yet";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Chat"),
        ),
        body: ListView(),
        bottomNavigationBar: Container(
          height: size.height * 0.08,
          width: size.width * 0.09,
          decoration: BoxDecoration(color: Colors.blue[50]),
          child: Center(
            child: Row(
              children: [
                TextFormField(),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.send,
                      color: Colors.black,
                    ))
              ],
            ),
          ),
        ));
  }
}
