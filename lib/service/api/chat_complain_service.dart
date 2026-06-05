import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatCompletion {
  final String message;

  ChatCompletion({required this.message});

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}

class ChatCompletionRespons {
  final String answer;
  final int iterations;
  final String stoppedBy;

  ChatCompletionRespons({required this.answer, required this.iterations, required this.stoppedBy});

  factory ChatCompletionRespons.fromJson(Map<String, dynamic> json) {
    return ChatCompletionRespons(
      answer: json['answer'],
      iterations: json['iterations'],
      stoppedBy: json['stoppedBy'],
    );
  }
}


class ChatComplainService {
  Future<ChatCompletionRespons> complain(ChatCompletion chatComlain) async {
    try {
      final response = await http.post(
        Uri.parse(''),
        body: chatComlain.toJson(),
      );
      if (response.statusCode == 200) {
        return ChatCompletionRespons.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to complain');
      }
    } catch (e) {
      throw Exception('Failed to complain: $e');
    }
  }
}
