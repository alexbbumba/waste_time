import 'package:flutter/material.dart';
import 'package:waste_time/pages/customer/chatbot_service/questions_bank.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<FAQ> searchResults = [];

  void searchFAQs(String query) {
    setState(() {
      searchResults = faqs
          .where(
              (faq) => faq.question.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Chat"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => searchFAQs(value),
              decoration: const InputDecoration(
                labelText: 'Enter your question',
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),

          searchResults.isNotEmpty
              ? const Center(
                  child: Text(
                    "Your Answer",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 17),
                  ),
                )
              : const SizedBox(),

          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchResults[index].question),
                  subtitle: Text(searchResults[index].answer),
                );
              },
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: TextField(
          //           controller: queryController,
          //           decoration: const InputDecoration(
          //             hintText: 'Enter text',
          //             border: OutlineInputBorder(),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(width: 16.0),
          //       IconButton(
          //           onPressed: () {
          //             processData(queryController.text);
          //           },
          //           icon: const Icon(
          //             Icons.send,
          //             color: Colors.black,
          //           ))
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
