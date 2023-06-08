class ImagesComplaintModel{
  String url;
  int id;

  ImagesComplaintModel({
    required this.url,
    required this.id
  });

  factory ImagesComplaintModel.toMap(Map<String, dynamic> json) => ImagesComplaintModel(
    url: json['url'],
    id: json['id']
  );

  Map<String, dynamic> toJson() => {
    'url': url,
    'id': id
  };


} 