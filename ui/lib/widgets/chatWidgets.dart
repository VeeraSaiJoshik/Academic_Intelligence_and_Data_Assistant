import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class AiDAResponse extends StatelessWidget {
  String content;
  AiDAResponse(this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          margin: EdgeInsets.only(
            top: 3
          ),
          padding: EdgeInsets.all(8),
          child: ClipRRect(
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Image.asset("bsd-logo.png"),
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          constraints: BoxConstraints(maxWidth: 600),
          decoration: BoxDecoration(
              color: Color.fromARGB(200, 243, 243, 243),
              borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(12),
          child: Text(
            content,
            style: GoogleFonts.getFont("Inter",
                fontSize: 16, height: 1.4, fontWeight: FontWeight.w600),
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
    return AiDAResponse("Hmmm, give me a second!");
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
            color: Color.fromARGB(200, 243, 243, 243),
            borderRadius: BorderRadius.circular(10)
          ),
          padding: EdgeInsets.all(12),
          child: Text(
            content,
            style: GoogleFonts.getFont("Inter",
                fontSize: 16, height: 1.3, fontWeight: FontWeight.w600),
            softWrap: true,
          ),
        ),
        SizedBox(
          width: 45,
        ),
      ],
    );
  }
}
