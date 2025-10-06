import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/supabase_service.dart';
import '../../models/user_settings.dart' as models;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _supabase = SupabaseService();
  models.UserSettings? _settings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final userId = _supabase.currentUser?.id;
      if (userId == null) return;

      final settings = await _supabase.getSettings(userId);
      if (settings == null) {
        final newSettings = models.UserSettings(
          id: '',
          userId: userId,
          themeMode: models.ThemeMode.system,
          defaultOutputFormat: 'jpg',
          qualityPreset: 'high',
          autoDeleteAfterConversion: false,
          showAds: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _supabase.createSettings(newSettings);
        setState(() {
          _settings = newSettings;
          _isLoading = false;
        });
      } else {
        setState(() {
          _settings = settings;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateSettings(models.UserSettings settings) async {
    try {
      await _supabase.updateSettings(settings);
      setState(() => _settings = settings);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save settings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.brightness_6),
                  title: const Text('Theme'),
                  subtitle: Text(_settings?.themeMode.name.toUpperCase() ?? 'SYSTEM'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showThemeDialog(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Conversion Settings',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text('Default Output Format'),
                  subtitle: Text(_settings?.defaultOutputFormat.toUpperCase() ?? 'JPG'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFormatDialog(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.high_quality),
                  title: const Text('Default Quality'),
                  subtitle: Text(_settings?.qualityPreset.toUpperCase() ?? 'HIGH'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showQualityDialog(),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.delete_sweep),
                  title: const Text('Auto-delete after conversion'),
                  subtitle: const Text('Delete original files after successful conversion'),
                  value: _settings?.autoDeleteAfterConversion ?? false,
                  onChanged: (value) {
                    if (_settings != null) {
                      _updateSettings(_settings!.copyWith(
                        autoDeleteAfterConversion: value,
                      ));
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'About',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Version'),
                  trailing: Text('1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<models.ThemeMode>(
              title: const Text('Light'),
              value: models.ThemeMode.light,
              groupValue: _settings?.themeMode,
              onChanged: (value) {
                if (value != null && _settings != null) {
                  _updateSettings(_settings!.copyWith(themeMode: value));
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<models.ThemeMode>(
              title: const Text('Dark'),
              value: models.ThemeMode.dark,
              groupValue: _settings?.themeMode,
              onChanged: (value) {
                if (value != null && _settings != null) {
                  _updateSettings(_settings!.copyWith(themeMode: value));
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<models.ThemeMode>(
              title: const Text('System'),
              value: models.ThemeMode.system,
              groupValue: _settings?.themeMode,
              onChanged: (value) {
                if (value != null && _settings != null) {
                  _updateSettings(_settings!.copyWith(themeMode: value));
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFormatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default Output Format'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('JPG'),
              value: 'jpg',
              groupValue: _settings?.defaultOutputFormat,
              onChanged: (value) {
                if (value != null && _settings != null) {
                  _updateSettings(_settings!.copyWith(defaultOutputFormat: value));
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('PNG'),
              value: 'png',
              groupValue: _settings?.defaultOutputFormat,
              onChanged: (value) {
                if (value != null && _settings != null) {
                  _updateSettings(_settings!.copyWith(defaultOutputFormat: value));
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('PDF'),
              value: 'pdf',
              groupValue: _settings?.defaultOutputFormat,
              onChanged: (value) {
                if (value != null && _settings != null) {
                  _updateSettings(_settings!.copyWith(defaultOutputFormat: value));
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showQualityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default Quality'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('High'),
              subtitle: const Text('Best quality, larger file size'),
              value: 'high',
              groupValue: _settings?.qualityPreset,
              onChanged: (value) {
                if (value != null && _settings != null) {
                  _updateSettings(_settings!.copyWith(qualityPreset: value));
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Medium'),
              subtitle: const Text('Balanced quality and size'),
              value: 'medium',
              groupValue: _settings?.qualityPreset,
              onChanged: (value) {
                if (value != null && _settings != null) {
                  _updateSettings(_settings!.copyWith(qualityPreset: value));
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Low'),
              subtitle: const Text('Smaller file size, lower quality'),
              value: 'low',
              groupValue: _settings?.qualityPreset,
              onChanged: (value) {
                if (value != null && _settings != null) {
                  _updateSettings(_settings!.copyWith(qualityPreset: value));
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
