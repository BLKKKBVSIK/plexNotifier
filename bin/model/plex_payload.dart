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

  factory PlexPayload.fromJson(Map<String, dynamic> json) => PlexPayload(
        event: json['event'] as String?,
        title: json['Metadata']['title'] as String?,
        showType: json['Metadata']['librarySectionType'] as String?,
        grandparentTitle: json['Metadata']['grandparentTitle'] as String?,
        parentTitle: json['Metadata']['parentTitle'] as String?,
        summary: json['Metadata']['summary'] as String?,
        audienceRating: json['Metadata']['audienceRating'] ?? 0.0,
      );

  @override
  List<Object?> get props =>
      [event, title, grandparentTitle, parentTitle, summary, audienceRating];

  String createJsonForDiscordWebhook() {
    return '''
  {
    "username": "",
    "avatar_url": "",
    "content": "",
    "embeds": [
      {
        "title": "There is a new ${this.showType} on the PleX",
        "color": 0,
        "description": "${this.summary}",
        "timestamp": "",
        "author": {},
        "image": {},
        "thumbnail": {},
        "footer": {
          "text": "Audience rating: ${this.audienceRating.toString()}/10"
        },
        "fields": [
          {
            "name": "Title",
            "value": "${this.title}"
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
}
