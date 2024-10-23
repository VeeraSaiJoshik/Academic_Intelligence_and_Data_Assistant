import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;


    return Container(
      width: width, 
      height: height, 
      padding: const EdgeInsets.only(
        left: 30,
        right: 30,
        top: 30
      ),
      child: ListView(
        padding: EdgeInsets.only(bottom: 30),
        children: [
          Text(
            "About Us",
            style: GoogleFonts.getFont("Roboto",
                fontSize: 25,
                height: 1,
                color: const Color(0xff333333),
                fontWeight: FontWeight.w900),
          ),
          SizedBox(
            height: 6,
          ),
          Container(
            child: Text(
              "AiDA, or the Academic Information and Data Analysis, is your person AI counselor that aims to answer any questions that you have about a wide variety of topics relating to school. AiDA is a smart Large Language Model, like ChatGPT, that is specifically trained on documents, websites, and other information pretaining to Bentonville High School and Bentonville West High School. You can ask AiDA about things such as : \n     - Available Courses that match your passion \n     - School event and club related questions \n     - College admission and statistics",
              style: GoogleFonts.getFont("Inter",
                  fontSize: 15.5,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "How does it work?",
            style: GoogleFonts.getFont("Roboto",
                fontSize: 25,
                height: 1,
                color: const Color(0xff333333),
                fontWeight: FontWeight.w900),
          ),
          SizedBox(
            height: 6,
          ),
          Container(
            child: Text(
              "So how does AiDA work? Is it magic? Nope, it is just math. AiDA first scrapes all the important textual information from the Bentonville Public School District Website, College Websites, Common Datasets, and several other sources that are of importance to students. AiDA then uses a custom-made chunking algorithm in order to turn all the text into smaller parts, and turns the text into numbers. Whenever you ask AiDA a question, it uses some fancy math to identify the top 5 most important chunks of text that may answer your question. It then passes that data along with your question and a proprietary prompt to LLama (A open-source Chat-GPT alternative by Meta), give you your answer in under 3 seconds! The bottom line is that all of AiDA's inner technologies are owned by the Bentonville School Distrct, so any questions you ask are completly anonymous and will not be sent to any big tech companies!",
              style: GoogleFonts.getFont("Inter",
                  fontSize: 15.5,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "The Creators",
            style: GoogleFonts.getFont("Roboto",
                fontSize: 25,
                height: 1,
                color: const Color(0xff333333),
                fontWeight: FontWeight.w900),
          ),
          SizedBox(
            height: 6,
          ),
          Container(
            child: Text(
              "AiDA was made from ground up by high school students for high school students. After realizing how hard it is for students to get answers to their questions and how over-worked conselors are, 2 high school students, Harshith Guduru and Veera Unnam, set off to create a chatbot whosem main purpose is to help teachers, students, and councelors find answers to any questions they have regarding the Bentonville Public School system.",
              style: GoogleFonts.getFont("Inter",
                  fontSize: 15.5,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      )
    );
  }
}