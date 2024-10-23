class ChatHistory {
  String dateName;
  List<ChatObject> history;

  ChatHistory(
    this.dateName, 
    this.history
  );
}

class ChatObject {
  String chatId;
  String chatName;
  String date;
  List<Response> conversation;
  
  ChatObject(
    this.chatId, 
    this.chatName, 
    this.conversation, 
    this.date
  );
}

enum Source {
  AiDA, 
  User
}

class Response {
  String text;
  Source src;

  Response(this.text, this.src);

  static fromJsonRaw(jsonData){
    String text = jsonData["message"];
    Source src = jsonData["source"] == "AiDA" ? Source.AiDA : Source.User;

    return Response(text, src);
  }

  static fromJson(message, source) {
    String text = message;
    Source src = source == "AiDA" ? Source.AiDA : Source.User;

    return Response(text, src);
  }
}