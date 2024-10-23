// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/services/authService.dart';
import 'package:ui/pages/completeChatPage.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Widget> chattingHistory = [
    AiDAResponse("Hello! I am AiDA, your Academic Information and Data Analyst. I am here to answer any questions you have regarding the school hand-book and course book. Please feel free to ask me any questions you want and I will do my best to answer them. If you are not pleased with my services, please reach out to : support@aida.com, and reach out to your counselor regarding your question.")
  ];
  TextEditingController prompt = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool querying = false;
  bool _isNavigating = false;
  String _email = "";
  String _name = "";
  String _pictureUrl = "";
  bool signUp = false;

  final AuthService _googleSignIn = AuthService();

  void _scrollToBottom() {
    // Ensure the scroll position is set after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void initState(){
    super.initState();
    _googleSignIn.handleCallback((token) {
      AuthService.getUserInfoFromAccessToken(token).then((data) async {
        setState(() {
          _email = data["email"];
          _name = data["name"];
          _pictureUrl = data["photoId"];
          _isNavigating = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (_isNavigating) {
      // Navigate when the state is updated
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompleteChatPageUI(_email, _name, _pictureUrl),
          ),
        );
      });
      // Reset the flag to prevent multiple navigations
      _isNavigating = false;
    }

    return Scaffold(
      backgroundColor:Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Container(
            width: width, 
            height: 60,
            color: Color(0xff333333),
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                const ImageIcon(
                  AssetImage("assets/bsd-logo.png"),
                  color: Color.fromARGB(255, 255, 255, 255),
                  size: 23,
                ), 
                const SizedBox(
                  width: 7.5,
                ), 
                Container(
                  margin: EdgeInsets.only(top: 1.5),
                  height: 30, 
                  width: 2, 
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                const SizedBox(
                  width: 7.5,
                ), 
                Text(
                  "AiDA", 
                  style: GoogleFonts.getFont(
                    "Roboto",
                    fontSize: 25,
                    letterSpacing: 1.5,
                    height: 1,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w600
                  ),
                ),
                Expanded(
                  child: SizedBox()
                ),
                InkWell(
                  onTap: () async {
                    try {
                      signUp = false;
                      _googleSignIn.signInWithGoogle();
                    } catch (error) {
                      print("Sign-in failed: $error");
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10, 
                      vertical: 10
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5), 
                      color: Colors.white.withOpacity(0.1)
                    ),
                    child: Text(
                      "Login", 
                      style: GoogleFonts.getFont("Roboto",
                        fontSize: 17,
                        height: 1,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10
                ),
                InkWell(
                  onTap: (){
                    try {
                      signUp = true;
                      print("signin in g");
                      print(signUp);
                      _googleSignIn.signInWithGoogle();
                    } catch (error) {
                      print("Sign-in failed: $error");
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white.withOpacity(0.1)),
                    child: Text(
                      "Signup",
                      style: GoogleFonts.getFont("Roboto",
                          fontSize: 17,
                          height: 1,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
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
              color: Color.fromARGB(255, 243, 243, 243),
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
                          color: Color.fromARGB(255, 243, 243, 243),
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
          padding: EdgeInsets.all(3),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: FittedBox(
              fit: BoxFit.fitHeight, 
              child: Image.asset("bsd-logo.webp"),
            ),
          ),
        ), 
        Container(
          constraints: BoxConstraints(
            maxWidth: 600
          ),
          decoration: BoxDecoration(
            color: Color.fromARGB(169, 243, 243, 243), 
            borderRadius: BorderRadius.circular(15)
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
        SizedBox(
          width: 40,
          height: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Image.asset("bsd-logo.webp"),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          constraints: BoxConstraints(maxWidth: 600),
          decoration: BoxDecoration(
              color: Color.fromARGB(169, 243, 243, 243),
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
              color: Color.fromARGB(169, 243, 243, 243),
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