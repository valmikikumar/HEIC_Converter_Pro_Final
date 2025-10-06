enum ConversionStatus { pending, processing, completed, failed }

class Conversion {
  final String id;
  final String userId;
  final String originalFilename;
  final int originalSize;
  final String outputFormat;
  final String? outputFilename;
  final int outputSize;
  final ConversionStatus status;
  final String? errorMessage;
  final String? storagePath;
  final DateTime createdAt;
  final DateTime? completedAt;

  Conversion({
    required this.id,
    required this.userId,
    required this.originalFilename,
    required this.originalSize,
    required this.outputFormat,
    this.outputFilename,
    required this.outputSize,
    required this.status,
    this.errorMessage,
    this.storagePath,
    required this.createdAt,
    this.completedAt,
  });

  factory Conversion.fromJson(Map<String, dynamic> json) {
    return Conversion(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      originalFilename: json['original_filename'] as String,
      originalSize: json['original_size'] as int? ?? 0,
      outputFormat: json['output_format'] as String,
      outputFilename: json['output_filename'] as String?,
      outputSize: json['output_size'] as int? ?? 0,
      status: _parseStatus(json['status'] as String?),
      errorMessage: json['error_message'] as String?,
      storagePath: json['storage_path'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  static ConversionStatus _parseStatus(String? status) {
    switch (status) {
      case 'pending':
        return ConversionStatus.pending;
      case 'processing':
        return ConversionStatus.processing;
      case 'completed':
        return ConversionStatus.completed;
      case 'failed':
        return ConversionStatus.failed;
      default:
        return ConversionStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'original_filename': originalFilename,
      'original_size': originalSize,
      'output_format': outputFormat,
      'output_filename': outputFilename,
      'output_size': outputSize,
      'status': status.name,
      'error_message': errorMessage,
      'storage_path': storagePath,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  Conversion copyWith({
    String? outputFilename,
    int? outputSize,
    ConversionStatus? status,
    String? errorMessage,
    String? storagePath,
    DateTime? completedAt,
  }) {
    return Conversion(
      id: id,
      userId: userId,
      originalFilename: originalFilename,
      originalSize: originalSize,
      outputFormat: outputFormat,
      outputFilename: outputFilename ?? this.outputFilename,
      outputSize: outputSize ?? this.outputSize,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      storagePath: storagePath ?? this.storagePath,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
