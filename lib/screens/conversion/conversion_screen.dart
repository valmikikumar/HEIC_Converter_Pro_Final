import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../services/conversion_service.dart';
import '../../services/supabase_service.dart';
import '../../models/conversion.dart' as models;
import '../../utils/app_constants.dart';

class ConversionScreen extends StatefulWidget {
  const ConversionScreen({super.key});

  @override
  State<ConversionScreen> createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  final _conversionService = ConversionService();
  final _supabase = SupabaseService();

  List<PlatformFile>? _selectedFiles;
  String _outputFormat = 'jpg';
  String _qualityPreset = 'high';
  bool _isConverting = false;
  double _progress = 0.0;
  List<ConversionResult> _results = [];

  Future<void> _startConversion() async {
    if (_selectedFiles == null || _selectedFiles!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select files first')),
      );
      return;
    }

    setState(() {
      _isConverting = true;
      _progress = 0.0;
      _results.clear();
    });

    try {
      final paths = _selectedFiles!
          .where((file) => file.path != null)
          .map((file) => file.path!)
          .toList();

      final results = await _conversionService.batchConvert(
        inputPaths: paths,
        outputFormat: _outputFormat,
        quality: _qualityPreset,
        onProgress: (current, total) {
          setState(() {
            _progress = current / total;
          });
        },
      );

      setState(() {
        _results = results;
        _isConverting = false;
      });

      for (var result in results.where((r) => r.isSuccess)) {
        await _saveConversionToDatabase(result);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Converted ${results.where((r) => r.isSuccess).length} files successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _isConverting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Conversion failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveConversionToDatabase(ConversionResult result) async {
    try {
      final userId = _supabase.currentUser?.id;
      if (userId == null) return;

      final conversion = models.Conversion(
        id: '',
        userId: userId,
        originalFilename: result.inputPath?.split('/').last ?? 'unknown',
        originalSize: result.inputSize,
        outputFormat: _outputFormat,
        outputFilename: result.outputFilename,
        outputSize: result.outputSize,
        status: models.ConversionStatus.completed,
        createdAt: DateTime.now(),
        completedAt: DateTime.now(),
      );

      await _supabase.createConversion(conversion);

      final profile = await _supabase.getProfile(userId);
      if (profile != null) {
        await _supabase.updateProfile(
          profile.copyWith(conversionCount: profile.conversionCount + 1),
        );
      }
    } catch (e) {
      debugPrint('Error saving conversion: $e');
    }
  }

  Future<void> _saveResult(ConversionResult result) async {
    if (!result.isSuccess || result.outputBytes == null) return;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${result.outputFilename}');
      await file.writeAsBytes(result.outputBytes!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved to ${file.path}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _shareResult(ConversionResult result) async {
    if (!result.isSuccess || result.outputBytes == null) return;

    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/${result.outputFilename}');
      await file.writeAsBytes(result.outputBytes!);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Converted with HEIC Converter Pro',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convert Files'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Output Format',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'jpg', label: Text('JPG')),
                          ButtonSegment(value: 'png', label: Text('PNG')),
                          ButtonSegment(value: 'pdf', label: Text('PDF')),
                        ],
                        selected: {_outputFormat},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() {
                            _outputFormat = newSelection.first;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quality',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'high', label: Text('High')),
                          ButtonSegment(value: 'medium', label: Text('Medium')),
                          ButtonSegment(value: 'low', label: Text('Low')),
                        ],
                        selected: {_qualityPreset},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() {
                            _qualityPreset = newSelection.first;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isConverting ? null : _startConversion,
                icon: const Icon(Icons.transform),
                label: const Text('Start Conversion'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              if (_isConverting) ...[
                const SizedBox(height: 24),
                LinearProgressIndicator(value: _progress),
                const SizedBox(height: 8),
                Text(
                  '${(_progress * 100).toStringAsFixed(0)}% Complete',
                  textAlign: TextAlign.center,
                ),
              ],
              if (_results.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  'Results',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                ..._results.map((result) => _buildResultCard(result)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(ConversionResult result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  result.isSuccess ? Icons.check_circle : Icons.error,
                  color: result.isSuccess ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    result.outputFilename ?? 'Unknown',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (result.isSuccess) ...[
              const SizedBox(height: 8),
              Text(
                'Size: ${_conversionService.formatFileSize(result.outputSize)}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _saveResult(result),
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _shareResult(result),
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                    ),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 8),
              Text(
                'Error: ${result.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
