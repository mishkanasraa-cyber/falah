import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/ai_diagnosis_model.dart';
import '../../services/app_state.dart';
import '../../widgets/attachment_sheet.dart';
import 'gemini_api_key_dialog.dart';
import 'crop_disease_scanner_screen.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AppState _appState = AppState();

  final List<String> _quickPrompts = [
    'ما هو برنامج تسميد البطاطا في منطقة السواني؟',
    'متى أفضل موعد لتقليم أشجار الزيتون في ترهونة؟',
    'كيف أكافح سوسة النخيل الحمراء في فزان؟',
    'كيف أتعامل مع ملوحة مياه البئر المرتفعة؟',
    'شروط تسجيل أرض زراعية جديدة بالسجل العقاري؟',
  ];

  @override
  void initState() {
    super.initState();
    _appState.addListener(_onStateUpdate);
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateUpdate);
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onStateUpdate() {
    if (mounted) {
      setState(() {});
      _scrollToBottom();
    }
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

  void _sendMessage([String? presetText]) {
    final text = presetText ?? _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    _appState.sendChatMessage(text);
  }

  Future<void> _attachImageAndAsk() async {
    final result = await AttachmentSheet.show(
      context,
      title: 'إرفاق صورة للمحصول',
      allowDocuments: false,
    );

    if (!mounted || result == null) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تحليل الصور غير مربوط حاليًا. '
          'يمكنك كتابة سؤالك للحصول على إرشادات تجريبية.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.psychology_rounded,
              color: AppColors.limeBright,
              size: 22,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('مساعد فلاح الذكي'),
                Text(
                  'مستشارك الزراعي المدعوم بـ Gemini AI',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.limeLight,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_enhance_rounded),
            tooltip: 'طبيب النبات بالصور',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CropDiseaseScannerScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.vpn_key_rounded),
            tooltip: 'إعدادات مفتاح Gemini',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const GeminiApiKeyDialog(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Prompts Bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: AppColors.surfacePure,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: _quickPrompts.map((prompt) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ActionChip(
                      backgroundColor: AppColors.surfaceElevated,
                      label: Text(prompt, style: AppTypography.bodySmall),
                      onPressed: () => _sendMessage(prompt),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const Divider(height: 1),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _appState.chatHistory.length,
              itemBuilder: (context, index) {
                final message = _appState.chatHistory[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Input Bar
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: BoxDecoration(
              color: AppColors.surfacePure,
              border: const Border(
                top: BorderSide(color: AppColors.surfaceBorder),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  offset: const Offset(0, -2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.add_a_photo_rounded,
                      color: AppColors.forestPrimary,
                    ),
                    onPressed: _attachImageAndAsk,
                    tooltip: 'إرفاق صورة لفحصها بالكاميرا',
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText:
                            'اسأل عن التربة، التسميد، الري، أو المحاصيل...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(
                            color: AppColors.surfaceBorder,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.limeBright,
                    radius: 22,
                    child: IconButton(
                      icon: const Icon(
                        Icons.send_rounded,
                        color: AppColors.forestDarkest,
                        size: 20,
                      ),
                      onPressed: () => _sendMessage(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    if (msg.isThinking) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.forestPrimary,
              child: Icon(
                Icons.psychology_rounded,
                color: AppColors.limeBright,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfacePure,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.forestPrimary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(msg.text, style: AppTypography.bodySmall),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12, right: 40),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.forestPrimary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.forestPrimary.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            msg.text,
            style: AppTypography.bodyMedium.copyWith(color: Colors.white),
          ),
        ),
      );
    }

    // Assistant Message
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.forestDark,
            child: Icon(
              Icons.eco_rounded,
              color: AppColors.limeBright,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfacePure,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                border: Border.all(color: AppColors.surfaceBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'مساعد فلاح الذكي (Gemini)',
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.forestDarkest,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.verified_rounded,
                        size: 14,
                        color: AppColors.limeDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    msg.text,
                    style: AppTypography.bodyMedium.copyWith(height: 1.55),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
