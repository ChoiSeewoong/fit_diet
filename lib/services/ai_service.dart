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
너는 전문 영양 식단 코치야.

다음 사용자의 정보를 기반으로, 아침, 점심, 저녁 식단과 선택 간식을 포함한 하루 맞춤 식단을 구성해줘.
각 끼니별로 음식 구성, 권장 섭취량(g), 총 칼로리(kcal), 탄수화물/단백질/지방 비율(%)도 표기해줘.

사용자 정보:
- 성별: ${profile.gender}
- 나이: ${profile.age}
- 키: ${profile.height}cm
- 체중: ${profile.weight}kg
- 목표: ${profile.goal}
- 활동량: ${profile.activityLevel}
- 간식 포함 여부: ${profile.wantsSnack ? '예' : '아니오'}
- 알러지: ${profile.allergies.join(', ')}

응답은 보기 좋고 정돈된 형식으로 출력해줘.
예시:
[아침]
- 메뉴: 현미밥 150g, 닭가슴살 1.5개, 브로콜리 50g
- 칼로리: 약 450 kcal
- 비율: 탄수화물 50%, 단백질 30%, 지방 20%

[점심]
...

형식은 꼭 위와 같이 지켜줘. 쓸데없는 기호나 강조 부호 없이 명확하게 출력해줘.
출력 시 HTML, 마크다운, 기호(**, *, [], () 등)는 절대 사용하지 마.
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
      "max_tokens": 1200,
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
