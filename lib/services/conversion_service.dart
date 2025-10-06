import 'dart:io';
import 'dart:typed_data';
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as path;
import '../models/conversion.dart';
import '../utils/app_constants.dart';

class ConversionService {
  Future<ConversionResult> convertHeicToFormat({
    required String inputPath,
    required String outputFormat,
    String quality = 'high',
  }) async {
    try {
      final inputFile = File(inputPath);
      final inputSize = await inputFile.length();
      final filename = path.basenameWithoutExtension(inputPath);

      if (outputFormat == 'jpg' || outputFormat == 'png') {
        return await _convertToImage(
          inputPath: inputPath,
          outputFormat: outputFormat,
          quality: quality,
          filename: filename,
          inputSize: inputSize,
        );
      } else if (outputFormat == 'pdf') {
        return await _convertToPdf(
          inputPath: inputPath,
          filename: filename,
          inputSize: inputSize,
        );
      } else {
        throw Exception('Unsupported output format: $outputFormat');
      }
    } catch (e) {
      throw Exception('Conversion failed: ${e.toString()}');
    }
  }

  Future<ConversionResult> _convertToImage({
    required String inputPath,
    required String outputFormat,
    required String quality,
    required String filename,
    required int inputSize,
  }) async {
    final jpgPath = await HeicToJpg.convert(inputPath);
    if (jpgPath == null) {
      throw Exception('Failed to convert HEIC file');
    }

    final imageBytes = await File(jpgPath).readAsBytes();
    final image = img.decodeImage(imageBytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    final qualityValue = AppConstants.qualityPresets[quality] ?? 95;
    final outputBytes = outputFormat == 'jpg'
        ? img.encodeJpg(image, quality: qualityValue)
        : img.encodePng(image);

    final outputFilename = '$filename.$outputFormat';

    return ConversionResult(
      outputBytes: Uint8List.fromList(outputBytes),
      outputFilename: outputFilename,
      outputSize: outputBytes.length,
      inputSize: inputSize,
    );
  }

  Future<ConversionResult> _convertToPdf({
    required String inputPath,
    required String filename,
    required int inputSize,
  }) async {
    final jpgPath = await HeicToJpg.convert(inputPath);
    if (jpgPath == null) {
      throw Exception('Failed to convert HEIC file');
    }

    final imageBytes = await File(jpgPath).readAsBytes();
    final image = img.decodeImage(imageBytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    final pdf = pw.Document();
    final pdfImage = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(pdfImage, fit: pw.BoxFit.contain),
          );
        },
      ),
    );

    final outputBytes = await pdf.save();
    final outputFilename = '$filename.pdf';

    return ConversionResult(
      outputBytes: Uint8List.fromList(outputBytes),
      outputFilename: outputFilename,
      outputSize: outputBytes.length,
      inputSize: inputSize,
    );
  }

  Future<List<ConversionResult>> batchConvert({
    required List<String> inputPaths,
    required String outputFormat,
    String quality = 'high',
    Function(int current, int total)? onProgress,
  }) async {
    final results = <ConversionResult>[];

    for (int i = 0; i < inputPaths.length; i++) {
      onProgress?.call(i + 1, inputPaths.length);

      try {
        final result = await convertHeicToFormat(
          inputPath: inputPaths[i],
          outputFormat: outputFormat,
          quality: quality,
        );
        results.add(result);
      } catch (e) {
        results.add(ConversionResult.error(
          error: e.toString(),
          inputPath: inputPaths[i],
        ));
      }
    }

    return results;
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  double calculateCompressionRatio(int inputSize, int outputSize) {
    if (inputSize == 0) return 0;
    return ((inputSize - outputSize) / inputSize * 100);
  }
}

class ConversionResult {
  final Uint8List? outputBytes;
  final String? outputFilename;
  final int outputSize;
  final int inputSize;
  final String? error;
  final String? inputPath;

  ConversionResult({
    this.outputBytes,
    this.outputFilename,
    required this.outputSize,
    required this.inputSize,
    this.error,
    this.inputPath,
  });

  factory ConversionResult.error({
    required String error,
    required String inputPath,
  }) {
    return ConversionResult(
      outputSize: 0,
      inputSize: 0,
      error: error,
      inputPath: inputPath,
    );
  }

  bool get isSuccess => error == null && outputBytes != null;
}
