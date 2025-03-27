import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _key = 'favorite_diets';

  // 즐겨찾기 목록 불러오기
  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  // 즐겨찾기 추가
  static Future<void> addFavorite(String diet) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];

    if (!favorites.contains(diet)) {
      favorites.add(diet);
      await prefs.setStringList(_key, favorites);
    }
  }

  // 즐겨찾기 제거
  static Future<void> removeFavorite(String diet) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];

    if (favorites.contains(diet)) {
      favorites.remove(diet);
      await prefs.setStringList(_key, favorites);
    }
  }

  // 특정 식단이 즐겨찾기인지 여부 확인
  static Future<bool> isFavorite(String diet) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];
    return favorites.contains(diet);
  }
}
