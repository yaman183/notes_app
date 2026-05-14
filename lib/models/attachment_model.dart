class AttachmentModel {
  final String id;
  final String fileName;
  final String filePath;
  final String fileType;

  AttachmentModel({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.fileType,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fileName': fileName,
        'filePath': filePath,
        'fileType': fileType,
      };

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'],
      fileName: json['fileName'],
      filePath: json['filePath'],
      fileType: json['fileType'],
    );
  }
}