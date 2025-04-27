import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _id = '';
  String _username = '';
  String _email = '';
  double _experience = 0.0;
  int _level = 0;
  int _credits = 0;

  // Getters
  String get id => _id;
  String get username => _username;
  String get email => _email;
  double get experience => _experience;
  int get level => _level;
  int get credits => _credits;

  // Setters
  void setId(String id) {
    _id = id;
    notifyListeners();
  }

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setExperience(double experience) {
    _experience = experience;
    notifyListeners();
  }

  void setLevel(int level) {
    _level = level;
    notifyListeners();
  }

  void setCredits(int credits) {
    _credits = credits;
    notifyListeners();
  }

  // Method to update all fields at once
  void setUser({
    required String id,
    required String username,
    required String email,
    required double experience,
    required int level,
    required int credits,
  }) {
    _id = id;
    _username = username;
    _email = email;
    _experience = experience;
    _level = level;
    _credits = credits;
    notifyListeners();
  }

  // Method to clear user data
  void clearUser() {
    _id = '';
    _username = '';
    _email = '';
    _experience = 0.0;
    _level = 0;
    _credits = 0;
    notifyListeners();
  }
}