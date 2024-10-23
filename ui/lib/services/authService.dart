import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String clientId = '679991979782-clj7fh9h98907lhmpvac7ila20k6qajc.apps.googleusercontent.com';
  final String redirectUri = 'http://localhost:49440/callback';
  final String scope = 'email profile';
  
  void signInWithGoogle() {
    final String url =
        'https://accounts.google.com/o/oauth2/v2/auth?'
        'scope=$scope&'
        'redirect_uri=$redirectUri&'
        'response_type=token&'
        'client_id=$clientId';
        
    html.window.open(url, '_self'); // Redirect to the Google OAuth UI
  }

  void handleCallback(Function onSuccess) {
    final uri = html.window.location.href;
    if (uri.contains('access_token')) {
      final token = uri.split('access_token=')[1].split('&')[0];
      onSuccess(token);
    }
  }

  static Future<Map<String, dynamic>> getUserInfoFromAccessToken(
      String accessToken) async {
    final response = await http.get(
      Uri.parse('https://www.googleapis.com/oauth2/v1/userinfo?alt=json'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      // Decode the JSON response
      final Map<String, dynamic> userInfo = jsonDecode(response.body);

      // Extract the email, name, and picture
      String email = userInfo['email'] ?? 'No email found';
      String name = userInfo['name'] ?? 'No name found';
      String photoId = userInfo['picture'] ?? 'No picture found';

      return {
        'email': email,
        'name': name,
        'photoId': photoId,
      };
    } else {
      throw Exception('Failed to fetch user info: ${response.body}');
    }
  }
}
