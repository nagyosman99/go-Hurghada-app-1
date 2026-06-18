import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/features/ai_assistant/presentation/viewmodels/ai_chat_viewmodel.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/hotel_results/compact_hotel_card.dart';
import 'package:go_hurghada/features/activities/presentation/widgets/compact_activity_card.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AIChatViewModel _viewModel;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _viewModel = AppProvider.of(context).aiChatViewModel;
      _isInitialized = true;
    }
  }

  void _sendMessage() {
    final text = _controller.text;
    _controller.clear();
    _viewModel.sendMessage(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            final isReady = _viewModel.isGeminiReady;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'AI Assistant',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                GestureDetector(
                  onTap: isReady
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Row(
                                children: [
                                  Icon(Icons.warning_amber_rounded, color: Colors.amber),
                                  SizedBox(width: 8),
                                  Text("AI Diagnosis / تشخيص الـ AI"),
                                ],
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Here is why the AI is currently offline / سبب عدم عمل الذكاء الاصطناعي حالياً:",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _viewModel.initStatusMessage,
                                      style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          );
                        },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isReady ? Colors.green : Colors.amber,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isReady ? 'Gemini AI Online' : 'Offline Mode (Tap to diagnose) ⚠️',
                        style: TextStyle(
                          fontSize: 11,
                          color: isReady ? Colors.green : Colors.amber[700],
                          fontWeight: FontWeight.w500,
                          decoration: isReady ? TextDecoration.none : TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _viewModel.clearMessages();
            },
            tooltip: 'Clear Chat',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                final messages = _viewModel.messages;
                if (messages.isEmpty) {
                  return const Center(child: Text('Start a conversation!'));
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length + (_viewModel.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == messages.length) {
                      return const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    final msg = messages[index];
                    return _buildMessageBubble(msg);
                  },
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final isUser = msg.isUser;
    final hasAttachments = msg.attachments.isNotEmpty;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          // Text Bubble
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: isUser ? AppColors.primary : Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                bottomRight: isUser ? Radius.zero : const Radius.circular(16),
              ),
            ),
            child: Text(
              msg.text,
              style: TextStyle(color: isUser ? Colors.white : Colors.black87),
            ),
          ),

          // Attachments (Hotels or Activities)
          if (hasAttachments) _buildAttachmentsList(msg.attachments),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildAttachmentsList(List<dynamic> attachments) {
    return SizedBox(
      height: 250, // Reduced height for compact cards
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final item = attachments[index];
          if (item is HotelSearchResult) {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CompactHotelCard(hotel: item),
            );
          } else if (item is Activity) {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CompactActivityCard(activity: item),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Suggestion Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                _buildSuggestionChip('🏨 البحث عن فنادق | Finding Hotels', 'Find top hotels'),
                _buildSuggestionChip('💰 فنادق اقتصادية | Budget Stays', 'Find cheap hotels'),
                _buildSuggestionChip('🏝️ الجونة | El Gouna', 'Hotels in El Gouna'),
                _buildSuggestionChip('🌵 سفاري الصحراء | Desert Safari', 'Safari trips'),
                _buildSuggestionChip('🐠 غطس وسنوركلينج | Snorkeling', 'Snorkeling activities'),
                _buildSuggestionChip('🚤 رحلات بحرية | Boat Trips', 'Boat trips'),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Ask about hotels or activities...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send),
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String label, String query) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey[300]!),
        ),
        onPressed: () {
          _controller.text = query;
          _sendMessage();
        },
      ),
    );
  }
}
