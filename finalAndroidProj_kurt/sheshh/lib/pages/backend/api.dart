import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class AuthService {
  final String baseUrl = 'http://192.168.2.54:5000';

  Future<Map<String, dynamic>> sendVerificationCode(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/send-verification-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {'error': 'Failed to send verification code'};
    }
  }

  // .timeout(const Duration(seconds: 30));


  Future<Map<String, dynamic>> verifyCode(String email, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/verify-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );
    return jsonDecode(response.body);
  }


  Future<Map<String, dynamic>> register(String email, String password,
      String username) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'email': email, 'password': password, 'username': username}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateUserProfile({
    required String token,
    String? firstName,
    String? lastName,
    int? age,
    String? gender,
    String? image,
    String? username,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/users/update'),
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'age': age,
        'gender': gender,
        'image': image,
        'username': username,
      }),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Success
    } else {
      print('Error response: ${response.body}'); // Log the error response
      return {'error': 'Failed to update profile'}; // Handle error
    }
  }


  Future<Map<String, dynamic>> addBookmark(String token, String postId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bookmark/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'postId': postId}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add bookmark: ${response.body}');
    }
  }

  Future<List<dynamic>> getBookmarks(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bookmark/get'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to retrieve bookmarks: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> deleteBookmark(String token, String bookmarkId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/bookmark/delete'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'bookmarkId': bookmarkId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete bookmark: ${response.body}');
    }
  }
}





  Future<Map<String, dynamic>> getUserEmail(String userKey) async {
    final response = await http.get(
      Uri.parse('http://your-api-url/get-user-info/$userKey'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // Assuming the response body contains the email field in JSON format
    return jsonDecode(response.body);
  }


