import '../../../core/network/api_client.dart';
import '../models/comparison_model.dart';

class CompareService {
  static Future<ComparisonResultModel> compareChannels(
      String channelA, String channelB) async {
    final response = await ApiClient.post(
      "/api/compare",
      {
        "channelA": channelA,
        "channelB": channelB,
      },
    );

    return ComparisonResultModel.fromJson(response);
  }
}
