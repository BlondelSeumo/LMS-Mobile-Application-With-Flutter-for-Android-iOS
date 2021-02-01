import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:typed_data';

class NetworkImageLoader {
  String url;
  Map<String, String> headers;

  NetworkImageLoader(this.url, {this.headers});

//  static final http.Client _httpClient = createHttpClient();

  Future<Uint8List> load() async {
    final Uri resolved = Uri.base.resolve(this.url);
    final http.Response response = await http.get(resolved, headers: headers);
    if (response == null || response.statusCode != 200)
      throw new Exception(
          'HTTP request failed, statusCode: ${response?.statusCode}, $resolved');

    final Uint8List bytes = response.bodyBytes;
    if (bytes.lengthInBytes == 0)
      throw new Exception('NetworkImage is an empty file: $resolved');

    return bytes;
  }
}
