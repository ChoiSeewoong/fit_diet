// lib/models/user_profile.dart

import 'package:flutter/material.dart';

class UserProfile {
  final String gender;
  final int age;
  final double height;
  final double weight;
  final String goal;
  final String activityLevel;
  final List<String> allergies;
  final bool wantsSnack;
  final TimeOfDay? alarmTime;

  UserProfile({
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.goal,
    required this.activityLevel,
    required this.allergies,
    required this.wantsSnack,
    required this.alarmTime,
  });

  @override
  String toString() {
    return '''
성별: $gender
나이: $age
키: $height
체중: $weight
목표: $goal
활동량: $activityLevel
간식 포함: ${wantsSnack ? '예' : '아니오'}
알러지: ${allergies.join(', ')}
알람 시간: ${alarmTime?.toString},
''';
  }
}
