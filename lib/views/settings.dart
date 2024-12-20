import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'; // Add this import
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  SettingsViewState createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  bool _darkMode = ThemeMode.dark == MarappState.themeNotifier.value;
  bool _notifications = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
      _notifications = prefs.getBool('notifications') ?? false;
    });
  }

  void _saveDarkModeSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  void _saveNotificationSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _darkMode = value;
      MarappState.themeNotifier.value =
          _darkMode ? ThemeMode.dark : ThemeMode.light;
    });
    _saveDarkModeSetting(value);
  }

  void _toggleNotifications(bool value) {
    setState(() {
      _notifications = value;
    });
    _saveNotificationSetting(value);
  }

  void _sendTestNotification() {
    // Code to send a push notification
    if (kDebugMode) {
      print('Test push notification sent');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark Mode'),
                defaultTargetPlatform == TargetPlatform.iOS ||
                        defaultTargetPlatform == TargetPlatform.macOS
                    ? CupertinoSwitch(
                        value: _darkMode,
                        onChanged: _toggleDarkMode,
                      )
                    : Switch(
                        value: _darkMode,
                        onChanged: _toggleDarkMode,
                      ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Notifications'),
                defaultTargetPlatform == TargetPlatform.iOS ||
                        defaultTargetPlatform == TargetPlatform.macOS
                    ? CupertinoSwitch(
                        value: _notifications,
                        onChanged: _toggleNotifications,
                      )
                    : Switch(
                        value: _notifications,
                        onChanged: _toggleNotifications,
                      ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendTestNotification,
              child: const Text('Test Push Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
