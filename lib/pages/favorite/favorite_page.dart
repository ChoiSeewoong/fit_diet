import 'package:flutter/material.dart';
import 'package:fit_diet/services/favorite_service.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<String> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final data = await FavoriteService.getFavorites();
    setState(() {
      favorites = data;
      isLoading = false;
    });
  }

  Future<void> _removeFavorite(String diet) async {
    await FavoriteService.removeFavorite(diet);
    _loadFavorites(); // 리스트 새로고침
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('즐겨찾기 식단')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : favorites.isEmpty
              ? const Center(child: Text('저장된 식단이 없습니다.'))
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: favorites.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final diet = favorites[index];
                  return ListTile(
                    title: Text(
                      diet,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeFavorite(diet),
                    ),
                    onTap: () {
                      // 전체 보기 화면 or 복사 기능 추가 가능
                      showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: const Text('저장된 식단'),
                              content: Text(diet),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('닫기'),
                                ),
                              ],
                            ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
