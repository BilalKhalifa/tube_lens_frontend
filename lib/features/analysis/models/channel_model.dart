class ChannelModel {
  // --- EXISTING FIELDS ---
  final String id;
  final String title;
  final int subscribers;
  final int totalViews;
  final int totalVideos;
  final String thumbnail;
  final int analyzedVideos;
  final double avgViews;
  final double avgLikes;
  final double avgComments;
  final double engagementRate;
  final List<String> aiInsights;

  // --- INTELLIGENCE & TRENDS ---
  final String momentum;
  final double momentumIncreasePercent;
  final double engagementScore;
  final String consistencyScore;
  final double avgUploadGap;
  final double subscriberConversion;
  final List<PerformanceTrend> trends;

  // --- NEW FIELDS FROM API ---
  final bool success;
  final bool cached;
  final List<HeatmapData> uploadTimeHeatmap;
  final BestUploadTime? bestUploadTime;

  ChannelModel({
    required this.id,
    required this.title,
    required this.subscribers,
    required this.totalViews,
    required this.totalVideos,
    required this.thumbnail,
    required this.analyzedVideos,
    required this.avgViews,
    required this.avgLikes,
    required this.avgComments,
    required this.engagementRate,
    required this.aiInsights,
    required this.momentum,
    required this.momentumIncreasePercent,
    required this.engagementScore,
    required this.consistencyScore,
    required this.avgUploadGap,
    required this.subscriberConversion,
    required this.trends,
    required this.success,
    required this.cached,
    required this.uploadTimeHeatmap,
    this.bestUploadTime,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    final channel = json['channel'] ?? {};
    final analytics = json['analytics'] ?? {};
    final intelligence = json['intelligence'] ?? {};
    final trendList = json['performanceTrend'] as List? ?? [];

    return ChannelModel(
      id: channel['id']?.toString() ?? '',
      title: channel['title']?.toString() ?? 'No Title',
      subscribers: channel['subscribers'] ?? 0,
      totalViews: channel['totalViews'] ?? 0,
      totalVideos: channel['totalVideos'] ?? 0,
      thumbnail: channel['thumbnail']?.toString() ?? '',
      analyzedVideos: analytics['analyzedVideos'] ?? 0,
      avgViews: (analytics['avgViews'] as num? ?? 0).toDouble(),
      avgLikes: (analytics['avgLikes'] as num? ?? 0).toDouble(),
      avgComments: (analytics['avgComments'] as num? ?? 0).toDouble(),
      engagementRate: (analytics['engagementRate'] as num? ?? 0).toDouble(),
      aiInsights: List<String>.from(json['aiInsights'] ?? []),
      momentum: intelligence['momentum']?.toString() ?? 'Stable',
      momentumIncreasePercent: (intelligence['momentumIncreasePercent'] as num? ?? 0).toDouble(),
      engagementScore: (intelligence['engagementScore'] as num? ?? 0).toDouble(),
      consistencyScore: intelligence['consistencyScore']?.toString() ?? 'Medium',
      avgUploadGap: (intelligence['avgUploadGap'] as num? ?? 0).toDouble(),
      subscriberConversion: (intelligence['subscriberConversion'] as num? ?? 0).toDouble(),
      trends: trendList.map((t) => PerformanceTrend.fromJson(t)).toList(),
      
      // Mapping new fields
      success: json['success'] ?? false,
      cached: json['cached'] ?? false,
      uploadTimeHeatmap: (analytics['uploadTimeHeatmap'] as List? ?? [])
          .map((h) => HeatmapData.fromJson(h))
          .toList(),
      bestUploadTime: analytics['bestUploadTime'] != null
          ? BestUploadTime.fromJson(analytics['bestUploadTime'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'cached': cached,
      'channel': {
        'id': id,
        'title': title,
        'subscribers': subscribers,
        'totalViews': totalViews,
        'totalVideos': totalVideos,
        'thumbnail': thumbnail,
      },
      'analytics': {
        'analyzedVideos': analyzedVideos,
        'avgViews': avgViews,
        'avgLikes': avgLikes,
        'avgComments': avgComments,
        'engagementRate': engagementRate,
        'uploadTimeHeatmap': uploadTimeHeatmap.map((h) => h.toJson()).toList(),
        'bestUploadTime': bestUploadTime?.toJson(),
      },
      'intelligence': {
        'momentum': momentum,
        'momentumIncreasePercent': momentumIncreasePercent,
        'engagementScore': engagementScore,
        'consistencyScore': consistencyScore,
        'avgUploadGap': avgUploadGap,
        'subscriberConversion': subscriberConversion,
      },
      'performanceTrend': trends.map((t) => t.toJson()).toList(),
      'aiInsights': aiInsights,
    };
  }

  List<List<int>> getHeatmapGrid() {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    const slots = ["12AM", "6AM", "12PM", "6PM", "9PM"];

    List<List<int>> grid =
        List.generate(days.length, (_) => List.filled(slots.length, 0));

    for (var item in uploadTimeHeatmap) {
      int dayIndex = days.indexOf(item.day);
      int slotIndex = slots.indexOf(item.slot);

      if (dayIndex != -1 && slotIndex != -1) {
        grid[dayIndex][slotIndex] = item.score;
      }
    }

    return grid;
  }
}

class PerformanceTrend {
  final DateTime date;
  final int views;

  PerformanceTrend({required this.date, required this.views});

  factory PerformanceTrend.fromJson(Map<String, dynamic> json) {
    return PerformanceTrend(
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      views: json['views'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'views': views,
  };
}

class HeatmapData {
  final String day;
  final String slot;
  final int score;

  HeatmapData({required this.day, required this.slot, required this.score});

  factory HeatmapData.fromJson(Map<String, dynamic> json) {
    return HeatmapData(
      day: json['day']?.toString() ?? '',
      slot: json['slot']?.toString() ?? '',
      score: json['score'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'day': day,
    'slot': slot,
    'score': score,
  };
}

class BestUploadTime {
  final String day;
  final String time;
  final int engagement;

  BestUploadTime({required this.day, required this.time, required this.engagement});

  factory BestUploadTime.fromJson(Map<String, dynamic> json) {
    return BestUploadTime(
      day: json['day']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      engagement: json['engagement'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'day': day,
    'time': time,
    'engagement': engagement,
  };
}
