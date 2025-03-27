import 'package:flutter/material.dart';
import 'package:fit_diet/pages/user_input/user_input_page.dart';
import 'package:fit_diet/pages/favorite/favorite_page.dart';
import 'package:fit_diet/pages/premium/premium_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset('assets/logo_pink.png', width: 40, height: 40),
        ),
        title: const Text(
          'Fit Diet',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.teal),
            tooltip: '즐겨찾기 보기',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritePage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🥗 로고 크게
            Image.asset('assets/logo_pink.png', width: 160, height: 160),
            const SizedBox(height: 32),

            // 🎯 브랜드 메시지
            const Text(
              '당신을 위한 맞춤형 AI 식단',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              '건강한 변화, 지금 시작하세요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // 🍱 식단 생성 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.fastfood),
                label: const Text('맞춤 식단 만들기', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UserInputPage()),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // 💎 프리미엄 안내 버튼
            TextButton.icon(
              icon: const Icon(Icons.workspace_premium, color: Colors.amber),
              label: const Text(
                '프리미엄 안내 보기',
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PremiumPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
