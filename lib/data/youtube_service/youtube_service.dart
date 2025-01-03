import 'package:http/http.dart' as http;

class YouTubeService {
  static const String baseUrl = 'https://www.googleapis.com/youtube/v3';

  Future<bool> likeVideo(String videoId, String accessToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/videos/rate?id=$videoId&rating=like'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      return response.statusCode == 204;
    } catch (e) {
      print('Like error: $e');
      return false;
    }
  }
}
