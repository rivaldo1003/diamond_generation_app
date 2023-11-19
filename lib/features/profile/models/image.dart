class ImageModel {
  final bool success;
  final String message;
  final List<ImageData> data;

  ImageModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['data'] ?? [];
    List<ImageData> imageDataList =
        list.map((e) => ImageData.fromJson(json)).toList();
    return ImageModel(
      success: json['success'],
      message: json['message'],
      data: imageDataList,
    );
  }
}

class ImageData {
  final String userId;
  final String imageName;
  final String imagePath;

  ImageData({
    required this.userId,
    required this.imageName,
    required this.imagePath,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      userId: json['user_id'] ?? '',
      imageName: json['image_name'] ?? '',
      imagePath: json['image_path'] ?? '',
    );
  }
}
