import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// One versioned snapshot keeps the profile and attempt consistent.
class StudyStore {
  StudyStore(this.preferences);
  final SharedPreferences preferences;
  static const key = 'foco_de_teste.v1';

  Map<String, dynamic>? read() {
    final raw = preferences.getString(key);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> write(Map<String, dynamic> snapshot) async {
    if (!await preferences.setString(key, jsonEncode(snapshot))) {
      throw StateError('Não foi possível salvar o estudo neste dispositivo.');
    }
  }
}
