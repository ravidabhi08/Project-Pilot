import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  late SharedPreferences _prefs;

  final RxBool _isDarkMode = false.obs;
  final RxBool _notificationsEnabled = true.obs;
  final RxString _language = 'en'.obs;
  final RxBool _isLoading = false.obs;

  bool get isDarkMode => _isDarkMode.value;
  bool get notificationsEnabled => _notificationsEnabled.value;
  String get language => _language.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      _isLoading.value = true;
      _prefs = await SharedPreferences.getInstance();

      _isDarkMode.value = _prefs.getBool('dark_mode') ?? false;
      _notificationsEnabled.value = _prefs.getBool('notifications_enabled') ?? true;
      _language.value = _prefs.getString('language') ?? 'en';

      // Apply theme
      Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    } catch (e) {
      // Handle error silently
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> toggleDarkMode() async {
    try {
      _isDarkMode.value = !_isDarkMode.value;
      await _prefs.setBool('dark_mode', _isDarkMode.value);
      Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> toggleNotifications() async {
    try {
      _notificationsEnabled.value = !_notificationsEnabled.value;
      await _prefs.setBool('notifications_enabled', _notificationsEnabled.value);
      // TODO: Update Firebase Cloud Messaging settings
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> setLanguage(String languageCode) async {
    try {
      _language.value = languageCode;
      await _prefs.setString('language', languageCode);
      // TODO: Update app locale
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> clearCache() async {
    try {
      _isLoading.value = true;
      // TODO: Clear app cache, images, etc.
      await Future.delayed(const Duration(seconds: 2)); // Simulate clearing
    } catch (e) {
      // Handle error silently
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> resetSettings() async {
    try {
      _isLoading.value = true;
      await _prefs.clear();
      await _loadSettings(); // Reload defaults
    } catch (e) {
      // Handle error silently
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> exportData() async {
    try {
      _isLoading.value = true;
      // TODO: Export user data
      await Future.delayed(const Duration(seconds: 2)); // Simulate export
    } catch (e) {
      // Handle error silently
    } finally {
      _isLoading.value = false;
    }
  }
}
