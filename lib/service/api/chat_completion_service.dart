import 'dart:convert';

import 'package:http/http.dart' as http;

class ChatCompletion {
  final String? sessionId;
  final String? message;

  const ChatCompletion({this.sessionId, this.message});

  Map<String, dynamic> toJson() {
    return {
      if (sessionId != null) 'sessionId': sessionId,
      if (message != null) 'message': message,
    };
  }
}

class ChatCompletionResponse {
  final String sessionId;
  final String answer;
  final int iterations;
  final String stoppedBy;

  const ChatCompletionResponse({
    required this.sessionId,
    required this.answer,
    required this.iterations,
    required this.stoppedBy,
  });

  factory ChatCompletionResponse.fromJson(Map<String, dynamic> json) {
    return ChatCompletionResponse(
      sessionId: _readString(json, const ['sessionId']),
      answer: _readString(json, const ['answer']),
      iterations: json['iterations'] is int ? json['iterations'] as int : 0,
      stoppedBy: _readString(json, const ['stoppedBy']),
    );
  }
}

class ChatSessionResponse {
  final String id;
  final String sessionId;
  final String? createdAt;
  final String? updatedAt;
  final int messageCount;

  const ChatSessionResponse({
    required this.id,
    required this.sessionId,
    this.createdAt,
    this.updatedAt,
    this.messageCount = 0,
  });

  factory ChatSessionResponse.fromJson(Map<String, dynamic> json) {
    final id = _readString(json, const ['id', 'sessionId']);

    return ChatSessionResponse(
      id: id,
      sessionId: _tryReadString(json, const ['sessionId']) ?? id,
      createdAt: _tryReadString(json, const ['createdAt']),
      updatedAt: _tryReadString(json, const ['updatedAt']),
      messageCount: json['messageCount'] is int
          ? json['messageCount'] as int
          : 0,
    );
  }
}

class ChatMessageResponse {
  final String role;
  final String text;

  const ChatMessageResponse({required this.role, required this.text});

  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) {
    return ChatMessageResponse(
      role: _readString(json, const ['role']),
      text: _readString(json, const ['content', 'text']),
    );
  }
}

class ChatCompletionService {
  final String baseUrl;
  final http.Client _client;

  ChatCompletionService({
    this.baseUrl = 'http://127.0.0.1:8080',
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<ChatCompletionResponse> complete(ChatCompletion chatCompletion) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/chat/completion'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode(chatCompletion.toJson()),
      );
      if (response.statusCode == 200) {
        return ChatCompletionResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to complete chat: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to complete chat: $e');
    }
  }

  Future<ChatSessionResponse> createChat() async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/sessions'),
        headers: const {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChatSessionResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create chat: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create chat: $e');
    }
  }

  Future<List<ChatSessionResponse>> getSessions() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/sessions'),
        headers: const {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is! List) {
          throw const FormatException('Expected a sessions list');
        }

        return decoded
            .map(
              (session) =>
                  ChatSessionResponse.fromJson(session as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception('Failed to load sessions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load sessions: $e');
    }
  }

  Future<List<ChatMessageResponse>> getChatHistory(String sessionId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/sessions/$sessionId'),
        headers: const {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is! Map<String, dynamic>) {
          throw const FormatException('Expected a session object');
        }

        final messagesJson = decoded['messages'];
        if (messagesJson is! List) {
          throw const FormatException('Expected messages list');
        }

        return messagesJson
            .map(
              (message) =>
                  ChatMessageResponse.fromJson(message as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception('Failed to load chat history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load chat history: $e');
    }
  }
}

String _readString(Map<String, dynamic> json, List<String> keys) {
  final value = _tryReadString(json, keys);
  if (value == null) {
    throw FormatException('Missing string field. Tried: ${keys.join(', ')}');
  }

  return value;
}

String? _tryReadString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is String && value.isNotEmpty) return value;
  }

  return null;
}
