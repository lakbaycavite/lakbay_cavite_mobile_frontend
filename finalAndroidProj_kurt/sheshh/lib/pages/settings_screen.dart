import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool isNotificationsEnabled = true;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Dark Mode Toggle
          SwitchListTile(
            title: Text('Dark Mode'),
            value: isDarkMode,
            onChanged: (bool value) {
              setState(() {
                isDarkMode = value;
              });
            },
            secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
          ),
          Divider(),

          // Notifications Toggle
          SwitchListTile(
            title: Text('Enable Notifications'),
            value: isNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                isNotificationsEnabled = value;
              });
            },
            secondary: Icon(isNotificationsEnabled ? Icons.notifications : Icons.notifications_off),
          ),
          Divider(),

          // Language Selector
          ListTile(
            title: Text('Language'),
            subtitle: Text(selectedLanguage),
            leading: Icon(Icons.language),
            onTap: () {
              _selectLanguage(context);
            },
          ),
          Divider(),

          // Privacy Policy
          ListTile(
            title: Text('Privacy Policy'),
            leading: Icon(Icons.privacy_tip),
            onTap: () {
              _showPrivacyPolicy(context);
            },
          ),
          Divider(),

          // Terms and Conditions
          ListTile(
            title: Text('Terms and Conditions'),
            leading: Icon(Icons.description),
            onTap: () {
              _showTermsAndConditions(context);
            },
          ),
          Divider(),
        ],
      ),
    );
  }

  // Method to show language selection dialog
  Future<void> _selectLanguage(BuildContext context) async {
    final List<String> languages = ['English', 'Filipino', 'Spanish'];
    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select Language'),
          children: languages.map((String language) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, language);
              },
              child: Text(language),
            );
          }).toList(),
        );
      },
    );
    if (result != null && result != selectedLanguage) {
      setState(() {
        selectedLanguage = result;
      });
    }
  }

  // Dummy method for showing privacy policy
  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Privacy Policy'),
          content: Text('This is a placeholder for your privacy policy.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Dummy method for showing terms and conditions
  void _showTermsAndConditions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Terms and Conditions'),
          content: Text('This is a placeholder for your terms and conditions.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
