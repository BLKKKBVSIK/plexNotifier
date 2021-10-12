import 'dart:io';
import 'dart:convert';
import 'package:multipart/multipart.dart';
import 'model/imgur_payload.dart';
import 'model/plex_payload.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart' as dio;

const kDISCORD_WEBHOOK =
    "https://discord.com/api/webhooks/892084912457400340/-dVRWne65KPgku6pB_FJk6kwsClKvD31UlweyadUJEwNS71pb2fxURg_hOjHDD3k1TmS";

void main() async {
  var server = await HttpServer.bind('127.0.0.1', 9000);
  print("[Debug] Http server opened on http://127.0.0.1:9000/");

  await for (HttpRequest r in server) {
    if (r.method == 'POST') {
      PlexPayload? currentEvent;
      final multiPart = Multipart(r);
      final parts = await multiPart.load();

      if (parts.first.filename == null) {
        Map<String, dynamic> decodedJSON;

        try {
          print("[Debug] Decoding JSON...");
          decodedJSON = json.decode(await parts.first.content.text())
              as Map<String, dynamic>;
          currentEvent = PlexPayload.fromJson(decodedJSON);
        } on FormatException catch (_) {
          throw '[Error] PlexPayload -> The provided string is not valid JSON';
        }

        if (currentEvent.event == "library.new") {
          print("[Debug] Found new content in library");

          File imageFile = await File('showImage.jpg')
              .writeAsBytes(await parts.last.content.takeBytes());

          String? imageId;
          ImgurPayload? imgurPayload;

          try {
            final dio.Response response = await dio.Dio().post(
              "https://api.imgur.com/3/upload",
              data: dio.FormData.fromMap({
                "image": await dio.MultipartFile.fromFile(imageFile.path,
                    filename: "picture.png",
                    contentType: MediaType('image', 'png'))
              }),
            );
            if (response.statusCode == 200) {
              print("HIII");

              imgurPayload = ImgurPayload.fromJson(
                  (response.data as Map<String, dynamic>));
            } else {
              throw 'Error parsing imgur';
            }
          } on dio.DioError catch (e) {
            if (e.response != null) {
              print("Error when uploading to Imgur");
            }
          }

          HttpClient httpClient = HttpClient();
          HttpClientRequest request =
              await httpClient.postUrl(Uri.tryParse(kDISCORD_WEBHOOK)!);
          request.headers.contentType =
              ContentType("application", "json", charset: "utf-8");
          request.write(
            currentEvent.createJsonForDiscordWebhook(imgurPayload!.link),
          );
          request.close();
        }
      }
      r.response.close();
    } else {
      r.response
        ..headers.set('Content-Type', 'text/html')
        ..write('''
          <!doctype html>
          <html>
          <body>
            <p>Hello! Nothing to see there</p>
          </body>
          </html>
        ''')
        ..close();
    }
  }
}
