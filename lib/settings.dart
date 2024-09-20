import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:timer/breadAddSetting.dart';
import 'emergencyList.dart';

class settings extends StatefulWidget {
  const settings({super.key});
  // const settingUI({Key? key}) : super(key: key);

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('일반'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.list),
                title: const Text('홀케익 목록 설정(개발 중)'),
                value: const Text('기기에 저장된 홀케익 목록을 편집할 수 있습니다.'),
                // onPressed: (BuildContext context) {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => wholeCakeList()),
                //   );
                // },
              ),
              SettingsTile(
                leading: const Icon(Icons.list),
                title: const Text("조각케익 목록 설정(개발 중)"),
                value: const Text('기기에 저장된 조각케익 목록을 편집할 수 있습니다.'),
              ),
              SettingsTile(
                leading: const Icon(Icons.list),
                title: const Text("스콘 & 마카롱 목록 설정"),
                value: const Text('기기에 저장된 스콘 또는 목록을 편집할 수 있습니다.'),
                onPressed: (BuildContext context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BreadAddSetting(kind: "scone")),
                  );
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.warning_amber),
                title: const Text("임시 리스트 생성"),
                value: const Text(
                    "메인 화면이 올바르게 동작하지 않을 경우, 해동 시작 시각 임시 리스트를 생성합니다."),
                onPressed: (BuildContext context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EmergencyList()),
                  );
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.rocket_launch_sharp),
                title: const Text('개발자 응원하기'),
                value: const Text('카카오뱅크 3333-03-0417246 고성준'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
