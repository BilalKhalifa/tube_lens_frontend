class VideoModel {
  final String title;
  final int views;
  final int likes;
  final int comments;
  final String duration;

  VideoModel({
    required this.title,
    required this.views,
    required this.likes,
    required this.comments,
    required this.duration,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      title: json['title'],
      views: json['views'],
      likes: json['likes'],
      comments: json['comments'],
      duration: json['duration'],
    );
  }
}
