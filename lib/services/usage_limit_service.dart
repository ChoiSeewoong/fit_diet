// lib/services/usage_limit_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class UsageLimitService {
  static const String _usageKey = 'diet_usage_count';
  static const int _maxUsage = 1;

  /// 사용 횟수 증가
  static Future<void> incrementUsage() async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(_usageKey) ?? 0;
    prefs.setInt(_usageKey, current + 1);
  }

  /// 사용 가능 여부 확인 (true: 사용 가능, false: 제한 초과)
  static Future<bool> canUse() async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(_usageKey) ?? 0;
    return current < _maxUsage;
  }

  /// 제한 메시지 반환 (null이면 사용 가능)
  static Future<String?> getUsageBlockReason() async {
    final count = await getUsageCount();
    if (count >= _maxUsage) {
      return '무료 사용 가능 횟수를 모두 사용했습니다.\n프리미엄 버전에서 무제한 사용이 가능합니다.';
    }
    return null;
  }

  /// 사용 횟수 초기화 (예: 프리미엄 구매 시)
  static Future<void> resetUsage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_usageKey, 0);
  }

  /// 현재 사용 횟수 확인
  static Future<int> getUsageCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_usageKey) ?? 0;
  }
}
