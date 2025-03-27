import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:fit_diet/models/user_profile.dart';
import 'package:fit_diet/services/ai_service.dart';
import 'package:fit_diet/services/favorite_service.dart';
import 'package:fit_diet/services/notification_service.dart';

class DietResultPage extends StatefulWidget {
  final UserProfile profile;

  const DietResultPage({super.key, required this.profile});

  @override
  State<DietResultPage> createState() => _DietResultPageState();
}

class _DietResultPageState extends State<DietResultPage> {
  String result = '';
  bool isLoading = true;
  bool isFavorite = false;
  bool alarmScheduled = false;

  @override
  void initState() {
    super.initState();
    _fetchDiet();
  }

  Future<void> _fetchDiet() async {
    try {
      final aiText = await AIService.generateDiet(widget.profile);
      final cleanText =
          aiText.trim().isEmpty ? '⚠️ AI로부터 식단 응답을 받지 못했습니다.' : aiText.trim();

      if (!mounted) return;
      setState(() {
        result = cleanText;
        isLoading = false;
      });

      _checkFavorite(cleanText);

      if (widget.profile.alarmTime != null && !alarmScheduled) {
        await NotificationService.showScheduledNotification(
          widget.profile.alarmTime!,
        );
        if (!mounted) return;
        setState(() => alarmScheduled = true);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("⏰ 식사 알림이 설정되었습니다!")));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        result = '⚠️ 오류 발생: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _checkFavorite(String dietText) async {
    final favorites = await FavoriteService.getFavorites();
    if (!mounted) return;
    setState(() {
      isFavorite = favorites.contains(dietText);
    });
  }

  Future<void> _toggleFavorite() async {
    final trimmed = result.trim();
    if (isFavorite) {
      await FavoriteService.removeFavorite(trimmed);
    } else {
      await FavoriteService.addFavorite(trimmed);
    }
    _checkFavorite(trimmed);
  }

  Future<void> _generateAndSharePDF() async {
    final pdf = pw.Document();
    final font = await rootBundle.load('assets/fonts/NotoSansKR-Regular.ttf');
    final ttf = pw.Font.ttf(font);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Text(result, style: pw.TextStyle(font: ttf, fontSize: 16));
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'fit_diet_result.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🥗 AI 식단 결과'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '오늘의 AI 맞춤 식단',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: SingleChildScrollView(
                          child: SelectableText(
                            result,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.white,
                            ),
                            label: Text(isFavorite ? '즐겨찾기 제거' : '즐겨찾기 저장'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: _toggleFavorite,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.copy, color: Colors.white),
                            label: const Text('복사'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: result));
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('결과가 복사되었습니다.')),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('PDF 저장 및 공유'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: _generateAndSharePDF,
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
