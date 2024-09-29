// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Widget> chattingHistory = [
    AiDAResponse("Hey, I am AiDA, your Academic Information and Data Analyst. I am here to answer any questions you have regarding the school hand-book and course book. Please feel free to ask me any questions you want and I will do my best to answer them. If you are not pleased with my services, please reach out to : support@aida.com, and reach out to your counselor regarding your question.")
  ];
  TextEditingController prompt = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool querying = false;

  void _scrollToBottom() {
    // Ensure the scroll position is set after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xffECECEC),
      body: Column(
        children: [
          Container(
            width: width, 
            height: 70,
            color: Color(0xff333333),
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                const ImageIcon(
                  AssetImage("assets/bsd-logo.png"),
                  color: Color(0xffECECEC),
                  size: 28,
                ), 
                const SizedBox(
                  width:10,
                ), 
                Container(
                  margin: EdgeInsets.only(top: 1.5),
                  height: 30, 
                  width: 2, 
                  color: Color(0xffECECEC),
                ),
                const SizedBox(
                  width: 10,
                ), 
                Text(
                  "AiDA", 
                  style: GoogleFonts.getFont(
                    "Roboto",
                    fontSize: 30,
                    height: 1,
                    color: Color(0xffECECEC),
                    fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 15,),
          Expanded(
            child: Container(
              width: 780,
              child: ListView.builder(
                padding: EdgeInsets.only(
                  bottom: 10
                ),
                itemCount: chattingHistory.length,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: chattingHistory[index],
                  );
                },
              ),
            ),
          ),
          Container(
            width: 670,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Color(0xffD4D3D3),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 7.5,
                ),
                SizedBox(
                  width: 605,
                  child: TextField(
                    maxLines: null,
                    controller: prompt,
                    decoration: InputDecoration(border: InputBorder.none),
                    style: GoogleFonts.getFont(
                      "Roboto",
                      fontSize: 17,
                      height: 1.3,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ), 
                SizedBox(
                  width: 2,
                ),
                InkWell(
                  onTap: () async {
                    print(querying);
                    if(!querying){
                      String question = prompt.text;
                      chattingHistory.add(StudentResponse(question));
                      chattingHistory.add(AiDAThinking());
                      querying = true;
                      prompt.text = "";
                      _scrollToBottom();
                      setState(() {
                      });

                      final response = await http.post( 
                        Uri.http("localhost:3000", "get-answer"),
                        headers: {"Content-Type": "application/json"},
                        body: jsonEncode(<String, dynamic>{ 
                          'question': question
                        }), 
                      ); 

                      setState(() {
                        chattingHistory.removeLast();
                        chattingHistory.add(AiDAResponse(response.body));
                        querying = false;

                        _scrollToBottom();
                      });
                    }
                  },
                  child: Container(
                    width: 40, 
                    height: 40,
                    margin: EdgeInsets.only(top:3),
                    decoration: BoxDecoration(
                      color: Color(0xff333333),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: FittedBox(
                      fit: BoxFit.fitHeight, 
                      child: RotatedBox(
                        quarterTurns: 2,
                        child: ImageIcon(
                          AssetImage("assets/send.png"), 
                          color: Color(0xffD4D3D3),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ), 
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}

class AiDAResponse extends StatelessWidget {
  String content;
  AiDAResponse(this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50, 
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xff333333), 
            borderRadius: BorderRadius.circular(7.5)
          ),
          padding: EdgeInsets.all(3),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: FittedBox(
              fit: BoxFit.fitHeight, 
              child: Image.asset("assets/ai-councelor.webp"),
            ),
          ),
        ), 
        SizedBox(
          width: 5,
        ),
        Container(
          constraints: BoxConstraints(
            maxWidth: 600
          ),
          decoration: BoxDecoration(
            color: Color(0xffD4D3D3).withOpacity(0.4), 
            borderRadius: BorderRadius.circular(5)
          ),
          padding: EdgeInsets.all(12),
          child: Text(
            content,
            style: GoogleFonts.getFont("Roboto",
              fontSize: 17, height: 1.3, fontWeight: FontWeight.w500
            ),
            softWrap: true,
          ),
        )
      ],
    );
  }
}

class AiDAThinking extends StatelessWidget {
  AiDAThinking({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              color: Color(0xff333333),
              borderRadius: BorderRadius.circular(7.5)),
          padding: EdgeInsets.all(3),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Image.asset("assets/ai-councelor.webp"),
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          constraints: BoxConstraints(maxWidth: 600),
          decoration: BoxDecoration(
              color: Color(0xffD4D3D3).withOpacity(0.4),
              borderRadius: BorderRadius.circular(5)),
          padding: EdgeInsets.all(12),
          child: Text(
            "Hmm, Give me a second...",
            style: GoogleFonts.getFont("Roboto",
                fontSize: 17, height: 1.3, fontWeight: FontWeight.w500),
            softWrap: true,
          ),
        )
      ],
    );
  }
}

class StudentResponse extends StatelessWidget {
  String content;
  StudentResponse(this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: 600),
          decoration: BoxDecoration(
              color: Color(0xffD4D3D3).withOpacity(0.4),
              borderRadius: BorderRadius.circular(5)),
          padding: EdgeInsets.all(12),
          child: Text(
            content,
            style: GoogleFonts.getFont("Roboto",
                fontSize: 17, height: 1.3, fontWeight: FontWeight.w500),
            softWrap: true,
          ),
        ),
        SizedBox(
          width: 55,
        ),
      ],
    );
  }
}