import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:postgres/postgres.dart';
import 'package:ui/main.dart';
import 'package:ui/pages/aboutUs.dart';
import 'package:ui/pages/sources.dart';
import 'package:ui/services/authService.dart';
import 'package:ui/models/chatHistory.dart';
import 'package:ui/widgets/chatWidgets.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
class CompleteChatPageUI extends StatefulWidget {
  String email;
  String name;
  String photoUrl;
  CompleteChatPageUI(this.email, this.name, this.photoUrl, {super.key});

  @override
  State<CompleteChatPageUI> createState() => _CompleteChatPageUIState();
}

class _CompleteChatPageUIState extends State<CompleteChatPageUI> {
  List<ChatHistory> chatHistory = [];
  String currentId = "About Us";
  bool searching = false;

  List<Widget> chattingHistory = [
    AiDAResponse("How may I help you today?")
  ];
  TextEditingController prompt = TextEditingController();
  TextEditingController searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool querying = false;

  void _scrollToBottom() {
    // Ensure the scroll position is set after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void changeSelectedChat(ChatObject data) {
    setState(() {
      currentId = data.chatId;

      chattingHistory = [];
      data.conversation.forEach((response){
        chattingHistory.add(response.src == Source.User ? StudentResponse(response.text) : AiDAResponse(response.text));
      });
    });
  }

  void switchPage(String chatId){
    setState(() {
      currentId = chatId;
    });
  }

  ChatObject? queryChatObject(String uuid){
    for(ChatHistory block in chatHistory){
      for(ChatObject chat in block.history){
        if(chat.chatId == uuid)
          return chat;
      }
    }

    return null;
  }

  int turnDateToWeight(String date){
    switch (date) {
      case "Today":
        return 0;
      case "Yesterday":
        return 1;
      case "This Week":
        return 2;
      case "Last Week":
        return 3;
      case "Last Month":
        return 4;
      case "Prior":
        return 5;
    }

    return -1;
  }

  int getSimilarityScore(String query, ChatObject chat){
    String title = chat.chatName;
    String contents = "";

    List<String> words = query.split(" ");

    int score = 0;

    for(String word in words){
      RegExp regExp = RegExp(RegExp.escape(word), caseSensitive: false);

      score += regExp.allMatches(title).length;
      score += regExp.allMatches(contents).length;
    }

    RegExp regExp = RegExp(RegExp.escape(query), caseSensitive: false);

    score += regExp.allMatches(title).length;
    score += regExp.allMatches(contents).length;

    return score;
  }

  @override
  void initState(){
    dbService.getChatData(widget.email).then((data) {
      setState(() {
        chatHistory = data;
        chatHistory.sort((a, b){
          int val1 = turnDateToWeight(a.dateName);
          int val2 = turnDateToWeight(b.dateName);
          
          return val1 - val2;
        });
        
        changeSelectedChat(chatHistory[0].history[0]);
      });
    });

    searchController.addListener((){
      print(searchController.text);
      setState((){});
    });

    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    searchController.removeListener((){});
  }

  @override
  Widget build(BuildContext context) {
    double Width = MediaQuery.of(context).size.width;
    double Height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: Width,
            height: Height,
            color: Color(0xff333333),
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5,),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              const SizedBox(
                                height: 20,
                                width: 20,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: ImageIcon(AssetImage("assets/bsd-logo.png"),
                                      color: const Color.fromARGB(255, 234, 234, 234)),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Container(
                                child: Text(
                                  "AiDA",
                                  style: GoogleFonts.getFont("Mukta",
                                      fontSize: 26,
                                      height: 1,
                                      decoration: TextDecoration.none,
                                      color: const Color.fromARGB(255, 234, 234, 234),
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    searching = true;
                                  });
                                },
                                child: const SizedBox(
                                  height: 19,
                                  child: const FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: ImageIcon(
                                      AssetImage("assets/search.png"),
                                      color: const Color.fromARGB(255, 234, 234, 234),
                                    ),
                                  )
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        InkWell(
                          onTap: (){
                            String chatId = Uuid().v4();
                            chatHistory[0].history.insert(0, ChatObject(
                                chatId,
                                "New Chat",
                                [
                                  Response(
                                    "How many I help you today?", 
                                    Source.AiDA
                                  )
                                ],
                                "Today"
                              )
                            );
          
                            changeSelectedChat(chatHistory[0].history.first);
                          },
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.115),
                              borderRadius: BorderRadius.circular(7.5)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 14.5, 
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: ImageIcon(
                                      AssetImage("assets/add.png"), 
                                      color: const Color.fromARGB(
                                              255, 234, 234, 234)
                                    )
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "New Chat", 
                                  style: GoogleFonts.getFont(
                                    "Inter", 
                                    fontSize: 17, 
                                    decoration: TextDecoration.none,
                                    color: const Color.fromARGB(255, 234, 234, 234),
                                    fontWeight: FontWeight.w600
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: Container(
                            width: Width,
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: chatHistory.map((timeFrame){
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 5, 
                                        bottom: 5
                                      ),
                                      child: Text(
                                        timeFrame.dateName,
                                        style: GoogleFonts.getFont(
                                          "Inter",
                                          fontSize: 12.5,
                                          decoration: TextDecoration.none,
                                          color: const Color.fromARGB(
                                                255, 234, 234, 234),
                                          fontWeight: FontWeight.w700
                                        ),
                                      ),
                                    ),
                                    ...timeFrame.history.map((chatInstance){
                                      return ChatInstanceThumbnail(Width, currentId, chatInstance, changeSelectedChat);
                                    }),
                                    SizedBox(height: 25)
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: 17),
                        Container(
                          width: Width * 0.19, 
                          height: 3, 
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15), 
                            borderRadius: BorderRadius.circular(5)
                          ),
                        ),
                        SizedBox(height: 10,),
                        ExtraOptionWidget("About Us", currentId, "assets/about-us.png", switchPage),
                        SizedBox(height: 5),
                        ExtraOptionWidget("Sources", currentId, "assets/document.png", switchPage),
                        SizedBox(height: 30,),
                        Container(
                          padding: EdgeInsets.only(top: 15, bottom: 9.5),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: Image.network(widget.photoUrl),
                                  ),
                                ),
                              ), 
                              SizedBox(
                                width: 8,
                              ), 
                              Container(
                                height: 35, 
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Veera Unnam",
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.getFont("Mukta",
                                        decoration: TextDecoration.none,
                                        fontSize: 19,
                                        height: 1,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromARGB(255, 234, 234, 234)
                                      ),
                                    ), 
                                    SizedBox(
                                      height: 2.5
                                    ),
                                    Text(
                                      widget.email,
                                      style: GoogleFonts.getFont("Roboto",
                                        decoration: TextDecoration.none,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        height: 1,
                                        color: const Color.fromARGB(255, 234, 234, 234)
                                      ),
                                    )
                                  ],
                                )
                              ), 
                              const Expanded(child: SizedBox()), 
                              Container(
                                height: 23, 
                                child: FittedBox(
                                  fit: BoxFit.fitHeight, 
                                  child: ImageIcon(
                                    AssetImage("assets/logout.png"), 
                                    color: Colors.red.shade400,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 25),
                Container(
                  width: Width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Stack(
                    children: [
                      currentId == "About Us" ? AboutUs() : currentId == "Sources" ? Sources() :
                      SizedBox(
                        width: Width * 0.8,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
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
                                      style: GoogleFonts.getFont("Inter",
                                        fontSize: 16,
                                        height: 1.3,
                                        fontWeight: FontWeight.w600
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
                                        setState(() {
                                          _scrollToBottom();
                                        });

                                        final response = await http.post( 
                                          Uri.http("localhost:38866", "get-answer"),
                                          headers: {"Content-Type": "application/json"},
                                          body: jsonEncode(<String, dynamic>{ 
                                            'question': question
                                          }), 
                                        ); 
                                        await Future.delayed(
                                                          Duration(milliseconds: 1500));
          
                                        setState(() {
                                          chattingHistory.removeLast();
                                          chattingHistory
                                              .add(AiDAResponse(response.body));
                                          querying = false;
          
                                          _scrollToBottom();
                                        });
          
                                        if(queryChatObject(currentId)!.chatName == "New Chat"){
                                          final chatTitle = await http.post(
                                            Uri.http("localhost:38866", "get-chat-title"),
                                            headers: {
                                              "Content-Type": "application/json"
                                            },
                                            body: jsonEncode(<String, dynamic>{
                                              'message': question
                                            }),
                                          );
          
                                          queryChatObject(currentId)!.chatName = jsonDecode(chatTitle.body)["title"];
                                        }                
          
                                        setState((){});
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
                                      child: const FittedBox(
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
                            const SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                      ),
                      const Positioned(
                        bottom: 15, 
                        right: 15,
                        child: Tooltip(
                          message: "AiDA is your personal AI councelor that is able to answer any questions related to \nschool policy, school events, classes, clubs, and etc. To see what AiDA can do\nlook at the 'about us' page, and to see what AiDA knows look at the 'Sources' page!",
                          child: ImageIcon(
                            AssetImage("assets/question.png"), 
                            color: Color(0xff333333),
                            size: 25,
                          ),
                        ),
                      )
                    ],
                  )
                )
              ],
            ),
          ),
          !searching ? Container() : 
          InkWell(
            onTap: (){
              setState((){
                searching = false;
              });
            },
            child: Container(
              width: Width, 
              height: Height, 
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(left: Width * 0.15),
                  height: 400, 
                  width: 700,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15), 
                    color: Color(0xff333333)
                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05), 
                          borderRadius: BorderRadius.circular(5)
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 5, 
                          horizontal: 13
                        ),
                        child: TextField(
                          controller: searchController,
                          style: GoogleFonts.getFont("Inter",
                            fontSize: 20,
                            height: 1.3,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 234, 234, 234)
                          ),
                          cursorColor: const Color.fromARGB(255, 234, 234, 234),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "What are you searching for?", 
                            hintStyle: GoogleFonts.getFont("Inter",
                              fontSize: 20,
                              height: 1.3,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(
                                  150, 234, 234, 234)
                            ),
                          ),
                        ),
                      ), 
                      const SizedBox(height: 10), 
                      Expanded(
                        child: Container(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: chatHistory.expand((data) {
                              return data.history.map((chat){
                                return InkWell(
                                  onTap: (){
                                    setState(() {
                                      changeSelectedChat(chat);
                                      searching = false;
                                    });
                                  },
                                  child: SearchObject(chat)
                                );
                              });
                            }).where((obj){
                              print((obj.child as SearchObject).data.chatId);
                              print(!(searchController.text.isEmpty && (obj.child as SearchObject).data.chatId == "otherId2"));
                              return getSimilarityScore(searchController.text, (obj.child as SearchObject).data) != 0 || !(searchController.text.isEmpty && (obj.child as SearchObject).data.chatId == "otherId2");
                            }).toList()..sort((a, b){
                              return getSimilarityScore(searchController.text, (b.child as SearchObject).data) - getSimilarityScore(searchController.text, (a.child as SearchObject).data);
                            }),
                          )
                        )
                      )
                    ],
                  )
                )
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ChatInstanceThumbnail extends StatefulWidget {
  double width;
  ChatObject chatInstance;
  String currentId;
  Function onTap;
  ChatInstanceThumbnail(this.width, this.currentId, this.chatInstance, this.onTap, {super.key});

  @override
  State<ChatInstanceThumbnail> createState() => _ChatInstanceThumbnailState();
}

class _ChatInstanceThumbnailState extends State<ChatInstanceThumbnail> {
  bool hoverRegion = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (hover){
        hoverRegion = hover;
        setState(() {
          print("Here is the thing");
        });
      },
      onTap: (){
        widget.onTap(widget.chatInstance);
      },
      child: Container(
        width: widget.width, 
        decoration: BoxDecoration(
          color: widget.currentId == widget.chatInstance.chatId || hoverRegion ?
            Colors.black.withOpacity(0.115) : 
            Colors.transparent, 
          borderRadius: BorderRadius.circular(5)
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 7.5, 
          vertical: 11
        ),
        child: Text(
         widget.chatInstance.chatName, 
          overflow: TextOverflow.ellipsis, 
          style: GoogleFonts.getFont("Inter",
            fontSize: hoverRegion ? 14 : 13.5,
            decoration: TextDecoration.none,
            color: const Color.fromARGB(
                  255, 234, 234, 234),
            fontWeight: FontWeight.w500
          ),
        ),
      ),
    );
  }
}

class SearchObject extends StatefulWidget {
  ChatObject data;
  SearchObject(this.data, {super.key});

  @override
  State<SearchObject> createState() => _SearchObjectState();
}

class _SearchObjectState extends State<SearchObject> {
  @override
  bool isSelected = false;
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isSelected = true;
        });
      },
      onExit: (_) {
        setState(() {
          isSelected = false;
        });
      },
      child: Container(
        width: width,
        margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(!isSelected ? 0.08 : 0.15),
            borderRadius: BorderRadius.circular(5)),
        padding: EdgeInsets.all(15),
        child: Text(
          widget.data.chatName,
          style: GoogleFonts.getFont(
            "Inter",
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: const Color.fromARGB(255, 234, 234, 234),
          ),
        )
      )
    );
  }
}

class ExtraOptionWidget extends StatefulWidget {
  String label;
  String currentId;
  String address;
  Function switchPage;
  ExtraOptionWidget(this.label, this.currentId, this.address, this.switchPage, {super.key});

  @override
  State<ExtraOptionWidget> createState() => _ExtraOptionWidgetState();
}

class _ExtraOptionWidgetState extends State<ExtraOptionWidget> {
  bool hoverRegion = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        widget.switchPage(widget.label);
      },
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            hoverRegion = true;
          });
        },
        onExit: (_) {
          setState(() {
            hoverRegion = false;
          });
        },
        child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: hoverRegion || widget.currentId == widget.label ? Colors.black.withOpacity(0.115) : Colors.transparent, 
            borderRadius: BorderRadius.circular(5)
          ),
          child: Row(children: [
            SizedBox(
              height: 18,
              child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: ImageIcon(
                    AssetImage(widget.address),
                    color: Color.fromARGB(255, 234, 234, 234),
                  )),
            ),
            SizedBox(width: 10),
            Text(
              widget.label,
              textAlign: TextAlign.start,
              style: GoogleFonts.getFont("Mukta",
                  decoration: TextDecoration.none,
                  fontSize: 19,
                  height: 1,
                  fontWeight: FontWeight.w600,
                  color:
                      const Color.fromARGB(255, 234, 234, 234)),
            )
          ]),
        ),
      ),
    );
  }
}