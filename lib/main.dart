import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:fit_diet/pages/splash/splash_screen.dart';
import 'package:fit_diet/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ⏰ 타임존 초기화 (예약 알림을 위한 필수 설정)
  tz.initializeTimeZones();

  // 🔐 .env 환경 변수 로드 (API 키 등)
  await dotenv.load(fileName: ".env");

  // 🔔 알림 서비스 초기화
  await NotificationService.init();
  print('✅ 앱 시작 준비 완료');

  // 🚀 앱 실행
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fit Diet',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        fontFamily: 'NotoSansKR', // ✅ 폰트 적용
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // ✅ 스플래시부터 시작
    );
  }
}
