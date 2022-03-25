import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import 'languages_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Settings UI')),
      body: buildSettingsList(),
    );
  }

  Widget buildSettingsList() {
    return SettingsList(
      sections: [
        SettingsSection(
          title: Text('Common'),
          tiles: [
            SettingsTile(
              title: Text('Language'),
              leading: Icon(Icons.language),
              onPressed: (context) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => LanguagesScreen(),
                ));
              },
            ),
            SettingsTile(
              title: Text('Environment'),
              leading: Icon(Icons.cloud_queue),
            ),
          ],
        ),
        SettingsSection(
          title: Text('Account'),
          tiles: [
            SettingsTile(title: Text('Phone number'), leading: Icon(Icons.phone)),
            SettingsTile(title: Text('Email'), leading: Icon(Icons.email)),
            SettingsTile(title: Text('Sign out'), leading: Icon(Icons.exit_to_app)),
          ],
        ),
        SettingsSection(
          title: Text('Security'),
          tiles: [
            SettingsTile.switchTile(
              title: Text('Lock app in background'),
              leading: Icon(Icons.phonelink_lock),
              onToggle: (bool value) {
                setState(() {
                  lockInBackground = value;
                  notificationsEnabled = value;
                });
              }, initialValue: lockInBackground,
            ),
            SettingsTile.switchTile(
              title: Text('Use fingerprint'),
              leading: Icon(Icons.fingerprint),
              onToggle: (bool value) {
              },
              initialValue: false,
            ),
            SettingsTile.switchTile(
              title: Text('Change password'),
              leading: Icon(Icons.lock),
              onToggle: (bool value) {},
              initialValue: true,
            ),
            SettingsTile.switchTile(
              title: Text('Enable Notifications'),
              enabled: notificationsEnabled,
              leading: Icon(Icons.notifications_active),
              onToggle: (value) {}, initialValue: true,
            ),
          ],
        ),
        SettingsSection(
          title: Text('Misc'),
          tiles: [
            SettingsTile(
                title: Text('Terms of Service'), leading: Icon(Icons.description)),
            SettingsTile(
                title: Text('Open source licenses'),
                leading: Icon(Icons.collections_bookmark)),
          ],
        ),
      ],
    );
  }
}