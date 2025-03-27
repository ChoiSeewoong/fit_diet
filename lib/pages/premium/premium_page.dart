import 'package:flutter/material.dart';
import 'package:fit_diet/services/usage_limit_service.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  Future<void> _simulatePurchase(BuildContext context) async {
    await UsageLimitService.resetUsage(); // 🔓 사용 횟수 초기화
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('프리미엄 결제가 완료되었습니다!')));
      Navigator.pop(context); // 뒤로 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('프리미엄 안내')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🎁 프리미엄 멤버십',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              '무료 사용자는 하루 1회의 AI 식단 추천만 이용 가능합니다.\n\n'
              '프리미엄 가입 시:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const BulletPoint(text: 'AI 식단 추천 무제한 이용'),
            const BulletPoint(text: '식사 알림 기능 사용 가능'),
            const BulletPoint(text: 'PDF 저장 및 공유 기능 제공'),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () => _simulatePurchase(context),
                child: const Text('프리미엄 결제 (시뮬레이션)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.teal),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
