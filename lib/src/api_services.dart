import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// to received image file Uploading Status during ImageKit.io() Function Call.
typedef OnUploadProgressCallback = void Function(double progressValue);

/// Add file from File Picker with `ImageKit.io` private api key.
class ImageKit {
  static HttpClient getHttpClient() {
    HttpClient httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    return httpClient;
  }

  /// This will return your uploaded Image/Video single link
  static Future<String> io(
    File? file, {

    /// Recomended to use `setState(() {})` OR use your Fevrate
    /// `State Management technique` to Preview Live Uploading status on your app.
    OnUploadProgressCallback? onUploadProgress,
    required String privateKey,
  }) async {
    assert(file != null);
    String apiKey = privateKey; // (Keep Confidential)
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$apiKey:'))}';
    const url = 'https://upload.imagekit.io/api/v1/files/upload';
    String fileName = file!.path.split('/').last;
    final httpClient = getHttpClient();
    final request = await httpClient.postUrl(Uri.parse(url));
    request.headers.add('authorization', basicAuth);
    int byteCount = 0;
    var requestMultipart = http.MultipartRequest("Post", Uri.parse(url));
    var multipart = await http.MultipartFile.fromPath("file", file.path);

    /// Required: this is your `file`
    requestMultipart.files.add(multipart);

    /// Required: this is your `fileName`
    requestMultipart.fields["fileName"] = fileName;
    var msStream = requestMultipart.finalize();
    var totalByteLength = requestMultipart.contentLength;
    request.contentLength = totalByteLength;
    request.headers.set(HttpHeaders.contentTypeHeader,
        requestMultipart.headers[HttpHeaders.contentTypeHeader]!);
    Stream<List<int>> streamUpload = msStream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(data);
          byteCount += data.length;
          double valueTotal = byteCount / totalByteLength;
          if (onUploadProgress != null) {
            /// if `OnUploadProgressCallback` is null you will not received any progress Status.
            onUploadProgress(valueTotal);
          }
        },
        handleError: (error, stack, sink) {
          throw error;
        },
        handleDone: (sink) {
          sink.close();
        },
      ),
    );
    await request.addStream(streamUpload);
    final httpResponse = await request.close();
    var statusCode = httpResponse.statusCode;
    if (statusCode ~/ 100 != 2) {
      throw Exception(
          'Error uploading file, Status code: ${httpResponse.statusCode}');
    } else {
      var data = await readResponseAsString(httpResponse);
      var json = jsonDecode(data);
      return json["url"];
    }
  }

  static Future<String> readResponseAsString(HttpClientResponse response) {
    var completer = Completer<String>();
    var contents = StringBuffer();
    response.transform(utf8.decoder).listen((String data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }
}
