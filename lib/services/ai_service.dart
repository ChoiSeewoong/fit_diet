import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_profile.dart';

class AIService {
  static Future<String> generateDiet(UserProfile profile) async {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('❌ OpenAI API 키가 설정되지 않았습니다. .env 파일을 확인해주세요.');
    }

    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    final prompt = '''
너는 전문 식단 코치야.
다음 정보를 기반으로 한 하루 맞춤 식단을 추천해줘.

성별: ${profile.gender}
나이: ${profile.age}
키: ${profile.height}cm
체중: ${profile.weight}kg
목표: ${profile.goal}
활동량: ${profile.activityLevel}
간식 포함 여부: ${profile.wantsSnack ? '예' : '아니오'}
알러지: ${profile.allergies.join(', ')}

아침, 점심, 저녁 식단과 간식(선택)을 추천해줘.

함량 : "탄수화물 : 단백질 : 지방 = 5 : 3 : 2". 
**응답은 줄바꿈과 마크다운 형식을 포함해서 보기 좋게 포맷팅해줘.**
    ''';

    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "model": "gpt-4-1106-preview", // 또는 "gpt-4-1106-preview"로 변경 가능
      "messages": [
        {"role": "user", "content": prompt},
      ],
      "temperature": 0.7,
      "max_tokens": 800,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedBody);
      final reply = data['choices'][0]['message']['content'];
      return reply.trim();
    } else {
      final decodedError = utf8.decode(response.bodyBytes);
      final error = jsonDecode(decodedError);
      final errorMessage = error['error']?['message'] ?? '알 수 없는 오류';
      throw Exception('⚠️ GPT 응답 실패: $errorMessage');
    }
  }
}
