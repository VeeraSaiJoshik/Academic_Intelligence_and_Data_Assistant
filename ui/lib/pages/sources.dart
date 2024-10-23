import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Category{
  String sources;
  List<Document> documents;

  Category(this.sources, this.documents);
}

class Document {
  String Thumbnail;
  String documentTitle;
  String documentDescription;

  Document(this.Thumbnail, this.documentTitle, this.documentDescription);
}

class Sources extends StatefulWidget {
  const Sources({super.key});

  @override
  State<Sources> createState() => _SourcesState();
}

class _SourcesState extends State<Sources> {
  List<Category> docs = [
    Category(
      "Documents", 
      [
        Document(
          "district-cover.png",
          "Student Handbook",
          "The student handbook has a great deal of information about all school disciplinary actions. This document contains information about attendance policies, graduation reqiurments, and etc."
        ),
        Document(
          "course_catalog.png",
          "Course Catalog",
          "The course catalog contains information about all the different acadeic offerings at BHS and BWHS. Things such as classes, credits, and etc."
        ),
        Document(
          "tech_handbook.png",
          "Tech Handbook",
          "The technology handbook contains information about how to use and maintain the school issued chromebooks. It also contains information about submitting your chromebook for repair"
        )
      ]
    ),
    Category(
      "Websites", 
      [
        Document(
          "announcements.png",
          "Announcements",
          "The student announcements contain information about student life, school events, clubs, and other opportunities. We scrape the student annouceents website every night."
        ),
        Document(
          "calendar.png",
          "School Calendar",
          "The school calendar contains information about holidays, standardized testing events, school visits, field trips, and other school events. We scrape the BHS and BWHS calendar every month."
        ),
        Document(
          "lunch.png",
          "Lunch Menu",
          "The BWHS lunch menu consists of information about what food is offered from breakfast and lunch each day and how much it costs. The website also has data bout the nutritional value of each item."
        )
      ]
    ),
    Category(
      "College Information", 
      [
        Document(
          "uofa.png",
          "U of A Documents",
          "We scrape data from the common data set documents from the University of Arkansas. This allows us to extract data about the school admission statistics"
        ),
        Document(
          "atu.png",
          "ATU Documents",
          "We scrape data from the common data set documents from the Arkansas Tech University. This allows us to extract data about the school admission statistics"
        ),
        Document(
          "uca.png",
          "UCA Documents",
          "We scrape data from the common data set documents from the University of Central Arkansas. This allows us to extract data about the school admission statistics"
        )
      ]
    )
  ];
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height, 
      padding: EdgeInsets.only(
        left: 30,
        right: 30,
        top: 30
      ),
      child: ListView(
        children: [
          Text(
            "Sources", 
            style: GoogleFonts.getFont(
              "Roboto", 
              fontSize: 25,
              height: 1,
              color: const Color(0xff333333),
              fontWeight: FontWeight.w900
            ),
          ), 
          SizedBox(
            height: 6,
          ),
          Container(
            child: Text(
              "Here is a list of sources that our state-of-the-art Language Learning Model (LLM) uses to provide you with accurate answers. If you have documents or resources you'd like to add, please email them to aidaBentonville@gmail.com. Your contributions are greatly appreciated and help us enhance our knowledge base!", 
              style: GoogleFonts.getFont("Inter",
                fontSize: 15.5,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w500
              ),
            ),
          ), 
          Container(
            width: width, 
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...docs.map((data){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        data.sources, 
                        style: GoogleFonts.getFont(
                          "Roboto", 
                          fontSize: 22,
                          height: 1,
                          color: const Color(0xff333333),
                          fontWeight: FontWeight.w900
                        ),
                      ), 
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: data.documents.map((doc){
                          return Container(
                            height: 170,
                            width: 340,
                            margin: EdgeInsets.only(
                              right: 15
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.03), 
                              borderRadius: BorderRadius.circular(5)
                            ),
                            padding: EdgeInsets.all(9.5),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black.withOpacity(0.05),
                                      width: 0
                                    ),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  height: 180,
                                  child: ClipRRect(
                                    child: Image.asset("Assets/" + doc.Thumbnail),
                                    borderRadius: BorderRadius.circular(
                                      3.5
                                    ),
                                  )
                                ), 
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      doc.documentTitle,
                                      maxLines: 2,
                                      style: GoogleFonts.getFont("Roboto",
                                          fontSize: 18,
                                          height: 1,
                                          color: const Color(0xff333333),
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox(height: 2,),
                                    Container(
                                      width: 180,
                                      child: Text(
                                        doc.documentDescription,
                                        maxLines: 100,
                                        softWrap: true,
                                        style: GoogleFonts.getFont("Inter",
                                          fontSize: 13,
                                          height: 1.2,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                          );
                        }).toList(),
                      )
                    ],
                  );
                }).toList()
              ],
            ),
          )
        ]
      ),
    );
  }
}