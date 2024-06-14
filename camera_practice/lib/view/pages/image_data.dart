class ImageData {
  final int idimages;
  final String usercode;
  final String url;
  final String category;
  final String weight;
  final String length;
  final String location;
  final DateTime createtime;

  ImageData({
    required this.idimages,
    required this.usercode,
    required this.url,
    required this.category,
    required this.weight,
    required this.length,
    required this.location,
    required this.createtime,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      idimages: json['idimages'],
      usercode: json['usercode'],
      url: json['url'],
      category: json['category'],
      weight: json['weight'],
      length: json['length'],
      location: json['location'],
      createtime: DateTime.parse(json['createtime']),
    );
  }
}
