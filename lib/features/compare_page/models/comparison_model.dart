class ComparedChannelModel {
  final String title;
  final int subscribers;
  final double avgViews;
  final double engagementRate;
  final int score;
  final int totalVideos;
  final int totalLikes;
  final int totalComments;

  ComparedChannelModel({
    required this.title,
    required this.subscribers,
    required this.avgViews,
    required this.engagementRate,
    required this.score,
    required this.totalVideos,
    required this.totalLikes,
    required this.totalComments,
  });

  factory ComparedChannelModel.fromJson(Map<String, dynamic> json) {
    return ComparedChannelModel(
      title: json['title']?.toString() ?? 'No Title',
      subscribers: json['subscribers'] ?? 0,
      avgViews: (json['avgViews'] as num? ?? 0).toDouble(),
      engagementRate: (json['engagementRate'] as num? ?? 0).toDouble(),
      score: json['score'] ?? 0,
      totalVideos: json['totalVideos'] ?? 0,
      totalLikes: json['totalLikes'] ?? 0,
      totalComments: json['totalComments'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subscribers': subscribers,
      'avgViews': avgViews,
      'engagementRate': engagementRate,
      'score': score,
      'totalVideos': totalVideos,
      'totalLikes': totalLikes,
      'totalComments': totalComments,
    };
  }
}

class ComparisonResultModel {
  final bool success;
  final ComparedChannelModel channelA;
  final ComparedChannelModel channelB;
  final String winner;

  ComparisonResultModel({
    required this.success,
    required this.channelA,
    required this.channelB,
    required this.winner,
  });

  factory ComparisonResultModel.fromJson(Map<String, dynamic> json) {
    return ComparisonResultModel(
      success: json['success'] ?? false,
      channelA: ComparedChannelModel.fromJson(json['channelA'] ?? {}),
      channelB: ComparedChannelModel.fromJson(json['channelB'] ?? {}),
      winner: json['winner']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'channelA': channelA.toJson(),
      'channelB': channelB.toJson(),
      'winner': winner,
    };
  }
}
