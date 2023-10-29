import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class settingUI extends StatefulWidget {
  const settingUI({super.key});
  // const settingUI({Key? key}) : super(key: key);


  @override
  State<settingUI> createState() => _settingUIState();
}

class _settingUIState extends State<settingUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text('Language'),
                value: Text('English'),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: true,
                leading: Icon(Icons.format_paint),
                title: Text('Enable custom theme'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
