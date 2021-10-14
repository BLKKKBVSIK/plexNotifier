class ImgurPayload {
  final int? status;
  final bool? success;
  final String? id;
  final String? link;

  const ImgurPayload({
    this.status,
    this.success,
    this.id,
    this.link,
  });

  factory ImgurPayload.fromJson(Map<String, dynamic> json) => ImgurPayload(
        status: json['status'] as int?,
        success: json['success'] as bool?,
        id: json['data']['id'] as String?,
        link: json['data']['link'] as String?,
      );

  @override
  List<Object?> get props => [
        status,
        success,
        id,
        link,
      ];
}
