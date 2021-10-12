class PlexPayload {
  final String? event;
  final String? title;
  final String? showType;
  final String? grandparentTitle;
  final String? parentTitle;
  final String? summary;
  final double? audienceRating;
  final int? parentIndex;
  final int? index;

  const PlexPayload({
    this.event,
    this.title,
    this.showType,
    this.grandparentTitle,
    this.parentTitle,
    this.summary,
    this.parentIndex = 0,
    this.index = 0,
    this.audienceRating,
  });

  factory PlexPayload.fromJson(Map<String, dynamic> json) => PlexPayload(
        event: json['event'] as String?,
        title: json['Metadata']['title'] as String?,
        showType: json['Metadata']['librarySectionType'] as String? ?? '',
        grandparentTitle: json['Metadata']['grandparentTitle'] as String?,
        parentTitle: json['Metadata']['parentTitle'] as String?,
        summary: json['Metadata']['summary'] as String?,
        audienceRating: json['Metadata']['audienceRating'] ?? 0.0,
        parentIndex: (json['Metadata'] as Map<String, dynamic>)
                .containsKey('parentIndex')
            ? int.tryParse(json['Metadata']['parentIndex'] ?? 0.0)
            : 0,
        index: (json['Metadata'] as Map<String, dynamic>).containsKey('index')
            ? int.tryParse(json['Metadata']['index'] ?? 0.0)
            : 0,
      );

  @override
  List<Object?> get props => [
        event,
        title,
        grandparentTitle,
        parentTitle,
        summary,
        audienceRating,
        index,
        parentIndex
      ];

  String createJsonForDiscordWebhook(String? link) {
    String query = '''
    {
      "embeds": [
        {
          "title": "${(showType ?? '').toLowerCase().contains("show") ? "${grandparentTitle ?? 'Unknow content title'} - ${title ?? 'Unknow subcontent title'} (S$parentIndex - E$index)" : "${title ?? 'Unknow content title'} "}",
          "description": "${summary ?? 'No description available'}",
          "footer": {
            "text": "Audience rating: $audienceRating/10"
          },
          "thumbnail": {
            "url": "${link ?? 'https://cdn.discordapp.com/embed/avatars/3.png'}"
          },
          "author": {
            "name": "New ${showType ?? 'unknowTypeShow'}"
          }
        }
      ]
    }
    ''';
    return query;
  }
}
