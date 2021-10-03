import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:multipart/multipart.dart';

const kDISCORD_WEBHOOK =
    "https://discord.com/api/webhooks/892084912457400340/-dVRWne65KPgku6pB_FJk6kwsClKvD31UlweyadUJEwNS71pb2fxURg_hOjHDD3k1TmS";

const kIMDB_API_KEY = "";
void main() async {
  var server = await HttpServer.bind('127.0.0.1', 9000);
  print("[Debug] Http server opened on http://127.0.0.1:9000/");

  await for (HttpRequest r in server) {
    if (r.method == 'POST') {
      final multiPart = Multipart(r);
      final parts = await multiPart.load();

      final currentEvent =
          PlexPayload.fromJson(json.decode(await utf8.decodeStream(r)));
      print(currentEvent.title);
      r.response.close();

      HttpClient httpClient = HttpClient();
      HttpClientRequest request =
          await httpClient.postUrl(Uri.tryParse(kDISCORD_WEBHOOK)!);
      request.headers.contentType =
          new ContentType("application", "json", charset: "utf-8");
      request.write(
        createJsonForDiscordWebhook(newLibraryItem: currentEvent),
      );
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

class PlexPayload {
  final String? event;
  final String? title;
  final String? showType;
  final String? grandparentTitle;
  final String? parentTitle;
  final String? summary;
  final double audienceRating;

  const PlexPayload({
    this.event,
    this.title,
    this.showType,
    this.grandparentTitle,
    this.parentTitle,
    this.summary,
    required this.audienceRating,
  });

  factory PlexPayload.fromJson(Map<String, dynamic> json) =>
      _$PlexPayloadFromJson(json);

  @override
  List<Object?> get props =>
      [event, title, grandparentTitle, parentTitle, summary, audienceRating];
}

PlexPayload _$PlexPayloadFromJson(Map<String, dynamic> json) {
  return PlexPayload(
    event: json['event'] as String?,
    title: json['Metadata']['title'] as String?,
    showType: json['Metadata']['librarySectionType'] as String?,
    grandparentTitle: json['Metadata']['grandparentTitle'] as String?,
    parentTitle: json['Metadata']['parentTitle'] as String?,
    summary: json['Metadata']['summary'] as String?,
    audienceRating: json['Metadata']['audienceRating'] ?? 0.0,
  );
}

String createJsonForDiscordWebhook({required PlexPayload newLibraryItem}) {
  return '''
  {
    "username": "",
    "avatar_url": "",
    "content": "",
    "embeds": [
      {
        "title": "There is a new ${newLibraryItem.showType} on the PleX",
        "color": 0,
        "description": "${newLibraryItem.summary}",
        "timestamp": "",
        "author": {},
        "image": {},
        "thumbnail": {},
        "footer": {
          "text": "Audience rating: ${newLibraryItem.audienceRating.toString()}/10"
        },
        "fields": [
          {
            "name": "Title",
            "value": "${newLibraryItem.title}"
          },
          {
            "name": "Serie Title",
            "value": "Ooooo"
          }
        ]
      }
    ],
    "components": []
  }
  ''';
}
