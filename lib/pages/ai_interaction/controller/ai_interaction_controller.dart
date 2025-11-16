import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../models/chat_message.dart';

class AIInteractionController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;

  static const String apiKey = 'AIzaSyB1uZSzuVhkRoXsbp2s5JYxTkLx2sm1d2E';

  late final GenerativeModel _model;

  ChatSession? _chatSession;

  @override
  void onInit() {
    super.onInit();
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  Future<void> sendMessage() async {
    final messageText = messageController.text.trim();
    if (messageText.isEmpty) return;

    final userMessage = ChatMessage(
      message: messageText,
      isUser: true,
      timestamp: DateTime.now(),
    );
    messages.add(userMessage);
    messageController.clear();

    isLoading.value = true;

    try {
      final aiResponse = await _callGeminiAPI(messageText);

      final aiMessage = ChatMessage(
        message: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(aiMessage);
    } catch (e) {
      final errorMessage = ChatMessage(
        message:
            'Sorry, I encountered an error. Please try again. ${e.toString()}',
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(errorMessage);
      debugPrint('Error calling Gemini API: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> _callGeminiAPI(String userMessage) async {
    try {
      _chatSession ??= _model.startChat();

      final response = await _chatSession!.sendMessage(
        Content.text(userMessage),
      );

      if (response.text != null && response.text!.isNotEmpty) {
        return response.text!;
      } else {
        throw Exception('No response text received from Gemini');
      }
    } catch (e) {
      debugPrint('Gemini API Error: $e');
      rethrow;
    }
  }

  void clearChat() {
    messages.clear();
    _chatSession = null;
  }
}
