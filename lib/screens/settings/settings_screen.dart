import 'package:flutter/material.dart';
import '../../services/local_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _themeMode = 'system';
  String _defaultFormat = 'jpg';
  String _qualityPreset = 'high';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final theme = await LocalStorageService.getThemeMode();
    final format = await LocalStorageService.getDefaultFormat();
    final quality = await LocalStorageService.getQualityPreset();

    setState(() {
      _themeMode = theme;
      _defaultFormat = format;
      _qualityPreset = quality;
      _isLoading = false;
    });
  }

  Future<void> _updateTheme(String theme) async {
    await LocalStorageService.setThemeMode(theme);
    setState(() => _themeMode = theme);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Theme updated'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _updateFormat(String format) async {
    await LocalStorageService.setDefaultFormat(format);
    setState(() => _defaultFormat = format);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Default format updated'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _updateQuality(String quality) async {
    await LocalStorageService.setQualityPreset(quality);
    setState(() => _qualityPreset = quality);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quality preset updated'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
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
                subtitle: Text(_themeMode.toUpperCase()),
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
                subtitle: Text(_defaultFormat.toUpperCase()),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showFormatDialog(),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.high_quality),
                title: const Text('Default Quality'),
                subtitle: Text(_qualityPreset.toUpperCase()),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showQualityDialog(),
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
                leading: const Icon(Icons.delete_forever),
                title: const Text('Reset App Data'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showResetDialog(),
              ),
            ],
          ),
        ),
      ],
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
            RadioListTile<String>(
              title: const Text('Light'),
              value: 'light',
              groupValue: _themeMode,
              onChanged: (value) {
                if (value != null) {
                  _updateTheme(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Dark'),
              value: 'dark',
              groupValue: _themeMode,
              onChanged: (value) {
                if (value != null) {
                  _updateTheme(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('System'),
              value: 'system',
              groupValue: _themeMode,
              onChanged: (value) {
                if (value != null) {
                  _updateTheme(value);
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
              groupValue: _defaultFormat,
              onChanged: (value) {
                if (value != null) {
                  _updateFormat(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('PNG'),
              value: 'png',
              groupValue: _defaultFormat,
              onChanged: (value) {
                if (value != null) {
                  _updateFormat(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('PDF'),
              value: 'pdf',
              groupValue: _defaultFormat,
              onChanged: (value) {
                if (value != null) {
                  _updateFormat(value);
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
              groupValue: _qualityPreset,
              onChanged: (value) {
                if (value != null) {
                  _updateQuality(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Medium'),
              subtitle: const Text('Balanced quality and size'),
              value: 'medium',
              groupValue: _qualityPreset,
              onChanged: (value) {
                if (value != null) {
                  _updateQuality(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Low'),
              subtitle: const Text('Smaller file size, lower quality'),
              value: 'low',
              groupValue: _qualityPreset,
              onChanged: (value) {
                if (value != null) {
                  _updateQuality(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset App Data'),
        content: const Text(
          'This will reset all app data including conversion count and Pro status. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await LocalStorageService.resetAllData();
              Navigator.pop(context);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('App data reset'),
                    backgroundColor: Colors.green,
                  ),
                );
                _loadSettings();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
