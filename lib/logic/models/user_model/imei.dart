class ImeiModel {
  final String imei;

  ImeiModel({required this.imei});

  Map<String, dynamic> toJson() => {'imei': imei};

  factory ImeiModel.fromJson(Map<String, dynamic> json) {
    return ImeiModel(imei: json['imei']);
  }
}