import 'dart:convert';

import 'package:http/http.dart' as http;

class ChatCompletion {
  final String message;

  const ChatCompletion({required this.message});

  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}

class ChatCompletionResponse {
  final String answer;
  final int iterations;
  final String stoppedBy;

  const ChatCompletionResponse({
    required this.answer,
    required this.iterations,
    required this.stoppedBy,
  });

  factory ChatCompletionResponse.fromJson(Map<String, dynamic> json) {
    return ChatCompletionResponse(
      answer: _readString(json, const ['answer', 'text', 'content', 'message']),
      iterations: json['iterations'] is int ? json['iterations'] as int : 0,
      stoppedBy: _tryReadString(json, const ['stoppedBy', 'stopReason']) ?? '',
    );
  }
}

class ChatSessionResponse {
  final String sessionId;
  final String? title;
  final String? preview;
  final String? updatedLabel;

  const ChatSessionResponse({
    required this.sessionId,
    this.title,
    this.preview,
    this.updatedLabel,
  });

  factory ChatSessionResponse.fromJson(Map<String, dynamic> json) {
    return ChatSessionResponse(
      sessionId: _readString(json, const ['sessionId', 'id']),
      title: _tryReadString(json, const ['title', 'name']),
      preview: _tryReadString(json, const ['preview', 'lastMessage']),
      updatedLabel: _tryReadString(json, const ['updatedLabel', 'updatedAt']),
    );
  }
}

class ChatMessageResponse {
  final String role;
  final String text;

  const ChatMessageResponse({required this.role, required this.text});

  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) {
    return ChatMessageResponse(
      role: _readString(json, const ['role', 'sender']),
      text: _readString(json, const ['text', 'content', 'message']),
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

  Future<ChatCompletionResponse> sendMessage({
    required String sessionId,
    required String message,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/sessions/$sessionId/messages'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return _readCompletionResponse(jsonDecode(response.body));
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
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
        final sessionsJson = _readList(decoded, const ['sessions', 'data']);
        return sessionsJson
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
        final messagesJson = _readList(decoded, const ['messages', 'history']);
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

ChatCompletionResponse _readCompletionResponse(dynamic decoded) {
  if (decoded is Map<String, dynamic>) {
    final message = decoded['message'];
    if (message is Map<String, dynamic>) {
      return ChatCompletionResponse(
        answer: ChatMessageResponse.fromJson(message).text,
        iterations: 0,
        stoppedBy: '',
      );
    }

    final data = decoded['data'];
    if (data is Map<String, dynamic>) {
      return ChatCompletionResponse.fromJson(data);
    }

    return ChatCompletionResponse.fromJson(decoded);
  }

  throw const FormatException('Expected a chat completion response object');
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

List<dynamic> _readList(dynamic decoded, List<String> wrapperKeys) {
  if (decoded is List) return decoded;

  if (decoded is Map<String, dynamic>) {
    for (final key in wrapperKeys) {
      final value = decoded[key];
      if (value is List) return value;
    }
  }

  throw FormatException(
    'Expected a list or a response with ${wrapperKeys.join(', ')}',
  );
}
