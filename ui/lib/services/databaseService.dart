import 'dart:convert';

import 'package:postgres/postgres.dart';
import 'package:ui/models/chatHistory.dart';
import "package:http/http.dart" as http;

class DatabaseService {
  final String baseUrl = "http://localhost:38866"; // Adjust for production

  Future<bool> createUser(String mailId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create-user'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': mailId}),
    );

    return response.statusCode == 200 && json.decode(response.body)['success'];
  }

  Future<List<ChatHistory>> getChatData(String mailId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get-chat-data'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': mailId}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)["data"];
      return _formatChatData(data);
    } else {
      throw Exception('Failed to load chat data');
    }
  }

  List<ChatHistory> _formatChatData(List data) {
    List<ChatObject> formattedData = [];
    List<String> chatIds = [];

    for (var row in data) {
      print(row);
      String chatId = row["chat_id"] as String;
      String chatName = row["chatName"] as String;
      String date = row["date"] as String;

      if (!chatIds.contains(chatId)) {
        chatIds.add(chatId);

        formattedData.add(ChatObject(chatId, chatName, [], date));
      }
      
      String? messageId = row["message_id"];
      String? message = row["message"];
      String? source = row["source"];

      if(messageId == null || message == null || source == null) {
        continue;
      }

      formattedData[chatIds.indexOf(chatId)]
          .conversation
          .add(Response(message, source == "AiDA" ? Source.AiDA : Source.User));
    }

    List<ChatHistory> result = [];

    for (ChatObject chat in formattedData) {
      if (!result.any((element) => element.dateName == chat.date)) {
        result.add(ChatHistory(chat.date, []));
      }

      result[result.indexWhere((element) => element.dateName == chat.date)]
          .history
          .add(chat);
    }

    return result;
  }
}
