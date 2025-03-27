import 'package:flutter/material.dart';
import 'package:fit_diet/models/user_profile.dart';
import 'package:fit_diet/pages/result/diet_result_page.dart';
import 'package:fit_diet/services/usage_limit_service.dart';

class UserInputPage extends StatefulWidget {
  const UserInputPage({super.key});

  @override
  State<UserInputPage> createState() => _UserInputPageState();
}

class _UserInputPageState extends State<UserInputPage> {
  String gender = 'male';
  int age = 25;
  double height = 170;
  double weight = 65;
  String goal = 'lose_weight';
  String activityLevel = 'moderate';
  List<String> allergies = [];
  bool wantsSnack = true;
  TimeOfDay? alarmTime;

  final List<String> allergyOptions = ['milk', 'egg', 'nuts', 'wheat', 'fish'];

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => alarmTime = picked);
    }
  }

  Future<void> _onSubmit() async {
    final canUse = await UsageLimitService.canUse();

    if (!canUse) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('이용 제한'),
              content: const Text(
                '무료 사용자는 1회만 식단 추천이 가능합니다.\n프리미엄 결제를 통해 더 많은 추천을 받을 수 있습니다.',
              ),
              actions: [
                TextButton(
                  child: const Text('확인'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
      );
      return;
    }

    final profile = UserProfile(
      gender: gender,
      age: age,
      height: height,
      weight: weight,
      goal: goal,
      activityLevel: activityLevel,
      allergies: allergies,
      wantsSnack: wantsSnack,
      alarmTime: alarmTime,
    );

    await UsageLimitService.incrementUsage();
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DietResultPage(profile: profile)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내 정보 입력'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('성별', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('남성'),
                  selected: gender == 'male',
                  onSelected: (_) => setState(() => gender = 'male'),
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('여성'),
                  selected: gender == 'female',
                  onSelected: (_) => setState(() => gender = 'female'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSlider('나이', age.toDouble(), 10, 80, (val) {
              setState(() => age = val.toInt());
            }, '$age세'),
            _buildSlider('키', height, 130, 200, (val) {
              setState(() => height = val);
            }, '${height.toInt()}cm'),
            _buildSlider('체중', weight, 40, 150, (val) {
              setState(() => weight = val);
            }, '${weight.toInt()}kg'),
            const SizedBox(height: 24),

            const Text('목표', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                ChoiceChip(
                  label: const Text('감량'),
                  selected: goal == 'lose_weight',
                  onSelected: (_) => setState(() => goal = 'lose_weight'),
                ),
                ChoiceChip(
                  label: const Text('유지'),
                  selected: goal == 'maintain',
                  onSelected: (_) => setState(() => goal = 'maintain'),
                ),
                ChoiceChip(
                  label: const Text('근육 증가'),
                  selected: goal == 'gain_muscle',
                  onSelected: (_) => setState(() => goal = 'gain_muscle'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text('활동량', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                ChoiceChip(
                  label: const Text('적음'),
                  selected: activityLevel == 'low',
                  onSelected: (_) => setState(() => activityLevel = 'low'),
                ),
                ChoiceChip(
                  label: const Text('보통'),
                  selected: activityLevel == 'moderate',
                  onSelected: (_) => setState(() => activityLevel = 'moderate'),
                ),
                ChoiceChip(
                  label: const Text('많음'),
                  selected: activityLevel == 'high',
                  onSelected: (_) => setState(() => activityLevel = 'high'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text('알러지', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  allergyOptions.map((item) {
                    return FilterChip(
                      label: Text(item),
                      selected: allergies.contains(item),
                      onSelected: (_) {
                        setState(() {
                          allergies.contains(item)
                              ? allergies.remove(item)
                              : allergies.add(item);
                        });
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 24),

            SwitchListTile(
              title: const Text('간식 포함 여부'),
              value: wantsSnack,
              onChanged: (val) => setState(() => wantsSnack = val),
            ),

            ListTile(
              title: Text(
                alarmTime != null
                    ? '알림 시간: ${alarmTime!.format(context)}'
                    : '알림 시간 설정',
              ),
              trailing: const Icon(Icons.alarm),
              onTap: _pickTime,
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.auto_awesome),
                label: const Text('AI 식단 추천받기'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: _onSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
    String displayValue,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: $displayValue'),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          label: displayValue,
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
