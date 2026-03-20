import '../../../core/network/api_client.dart';
import '../models/channel_model.dart';

class AnalysisService {
  static Future<ChannelModel> analyzeChannel(String channelUrl) async {
    final response = await ApiClient.post(
      "/api/analyze",
      {
        "channelInput": channelUrl,
      },
    );

    return ChannelModel.fromJson(response);
  }

  static Future<ChannelModel> analyze(String input) async{
    final formattedInput = input.startsWith("http")
        ?input
        :"https://youtube.com/$input";

    return await AnalysisService.analyzeChannel(formattedInput);
  }
}
