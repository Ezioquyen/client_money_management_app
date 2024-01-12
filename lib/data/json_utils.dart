import 'dart:convert';

class JsonUtils {
  static String toJson(dynamic object) {
    try {
      return jsonEncode(object);
    } catch (e) {
      return '';
    }
  }

  static dynamic fromJson(String jsonString) {
    try {
      return jsonDecode(jsonString);
    } catch (e) {
      return null;
    }
  }

  static Map<String, dynamic> toMap(dynamic object) {
    try {
      return jsonDecode(jsonEncode(object));
    } catch (e) {
      return {};
    }
  }

  static dynamic fromMap(Map<String, dynamic> jsonMap) {
    try {
      return jsonMap;
    } catch (e) {
      print('Error converting from map: $e');
      return null;
    }
  }
}
