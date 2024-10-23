import 'package:flutter/material.dart';
import 'package:ui/pages/chatPage.dart';
import 'package:ui/pages/completeChatPage.dart';
import 'package:ui/services/databaseService.dart';

DatabaseService dbService = DatabaseService();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChatPage(),
    );
  }
}