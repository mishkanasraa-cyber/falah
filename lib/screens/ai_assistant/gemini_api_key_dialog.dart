import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../services/gemini_service.dart';

class GeminiApiKeyDialog extends StatefulWidget {
  const GeminiApiKeyDialog({super.key});

  @override
  State<GeminiApiKeyDialog> createState() => _GeminiApiKeyDialogState();
}

class _GeminiApiKeyDialogState extends State<GeminiApiKeyDialog> {
  late TextEditingController _controller;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: GeminiService().currentApiKey ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final geminiService = GeminiService();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.surfacePure,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.forestDark,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.psychology_rounded, color: AppColors.limeBright, size: 22),
          ),
          const SizedBox(width: 12),
          Text(
            'مفتاح Gemini API',
            style: AppTypography.titleLarge.copyWith(color: AppColors.forestDarkest),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'يمكنك إدخال مفتاح Google Gemini API الخاص بك لتفعيل التحليل البصري التفاعلي وتشخيص أمراض النبات مباشرة عبر السحابة.',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.limeLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.limeBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline_rounded, color: AppColors.limeDark, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      geminiService.isConfigured
                          ? 'مفتاح Gemini مفعّل ومتصل بنجاح.'
                          : 'يعمل التطبيق حالياً بمحرك الخبرة الزراعية الذكي المدمج دون الحاجة لمفتاح.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.limeDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'أدخل رمز المفتاح (AIzaSy...)',
                hintText: 'ألصق المفتاح هنا...',
                prefixIcon: const Icon(Icons.key_rounded, color: AppColors.forestMedium),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    color: AppColors.textMuted,
                  ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إلغاء', style: AppTypography.labelMedium),
        ),
        if (geminiService.isConfigured)
          TextButton(
            onPressed: () {
              geminiService.configureApiKey('');
              _controller.clear();
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف المفتاح والعودة للمحرك المحلي')),
              );
              Navigator.pop(context);
            },
            child: Text(
              'مسح المفتاح',
              style: AppTypography.labelMedium.copyWith(color: AppColors.statusAlert),
            ),
          ),
        ElevatedButton(
          onPressed: () {
            geminiService.configureApiKey(_controller.text);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.forestPrimary,
                content: Text(
                  _controller.text.trim().isNotEmpty
                      ? 'تم حفظ مفتاح Gemini وتفعيل الاتصال السحابي!'
                      : 'تم تفعيل الوضع الذكي المدمج',
                ),
              ),
            );
          },
          child: const Text('حفظ الإعدادات'),
        ),
      ],
    );
  }
}
