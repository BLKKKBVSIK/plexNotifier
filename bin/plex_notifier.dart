import 'dart:io';
import 'dart:convert';
import 'package:multipart/multipart.dart';
import 'model/plex_payload.dart';

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
        currentEvent =
            PlexPayload.fromJson(json.decode(await parts.first.content.text()));
      }
      print(currentEvent!.title);

      HttpClient httpClient = HttpClient();
      HttpClientRequest request =
          await httpClient.postUrl(Uri.tryParse(kDISCORD_WEBHOOK)!);
      request.headers.contentType =
          ContentType("application", "json", charset: "utf-8");
      request.write(
        currentEvent.createJsonForDiscordWebhook(),
      );
      r.response.close();
      request.close();
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
