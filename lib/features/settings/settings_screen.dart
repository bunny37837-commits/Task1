import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taskremind_pro/features/settings/settings_controller.dart';
import 'package:taskremind_pro/services/overlay_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(remindersEnabledProvider);
    final mode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Global reminders'),
            value: enabled,
            onChanged: (v) => ref.read(remindersEnabledProvider.notifier).state = v,
          ),
          ListTile(
            title: const Text('Overlay permission'),
            subtitle: FutureBuilder<bool>(
              future: OverlayService.isGranted(),
              builder: (_, snapshot) => Text(snapshot.data == true ? 'Granted' : 'Not granted'),
            ),
            trailing: TextButton(
              onPressed: OverlayService.openSettings,
              child: const Text('Open settings'),
            ),
          ),
          ListTile(
            title: const Text('Battery optimization'),
            subtitle: const Text('Recommended to disable optimization for reliable reminders'),
            trailing: TextButton(
              onPressed: () => openAppSettings(),
              child: const Text('Open'),
            ),
          ),
          ListTile(
            title: const Text('Theme mode'),
            subtitle: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.system, label: Text('System')),
                ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
              ],
              selected: {mode},
              onSelectionChanged: (value) =>
                  ref.read(themeModeProvider.notifier).state = value.first,
            ),
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (_, snapshot) {
              final version = snapshot.data?.version ?? '...';
              return ListTile(title: const Text('App version'), subtitle: Text(version));
            },
          ),
        ],
      ),
    );
  }
}
