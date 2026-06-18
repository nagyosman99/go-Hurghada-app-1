import 'package:flutter/material.dart';
import 'package:go_hurghada/features/ai_assistant/domain/chat_bot_logic.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<dynamic> attachments;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.attachments = const [],
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class AIChatViewModel extends ChangeNotifier {
  final ChatBotLogic _logic;
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  AIChatViewModel({required ChatBotLogic logic}) : _logic = logic {
    // Initial greeting
    _messages.add(
      ChatMessage(
        text:
            "أهلاً بك! أنا مساعدك الذكي لرحلات الغردقة. كيف يمكنني مساعدتك اليوم؟\n\nHello! I am your Hurghada travel assistant. How can I help you today?",
        isUser: false,
      ),
    );
  }

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  bool get isGeminiReady => _logic.isGeminiReady;
  String get initStatusMessage => _logic.initStatusMessage;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    _messages.add(ChatMessage(text: text, isUser: true));
    notifyListeners();

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network delay for natural feel
      await Future.delayed(const Duration(milliseconds: 500));

      final response = await _logic.processMessage(text);
      _messages.add(
        ChatMessage(
          text: response.text,
          isUser: false,
          attachments: response.attachments,
        ),
      );
    } catch (e) {
      _messages.add(
        ChatMessage(text: "Sorry, something went wrong.", isUser: false),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _messages.clear();
    _logic.clearHistory();
    // Add greeting back
    _messages.add(
      ChatMessage(
        text:
            "أهلاً بك! أنا مساعدك الذكي لرحلات الغردقة. كيف يمكنني مساعدتك اليوم؟\n\nHello! I am your Hurghada travel assistant. How can I help you today?",
        isUser: false,
      ),
    );
    notifyListeners();
  }
}
