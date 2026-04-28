class LiveTvChannel {
  final int id;
  final String name;
  final String url;

  const LiveTvChannel({
    required this.id,
    required this.name,
    required this.url,
  });

  factory LiveTvChannel.fromJson(Map<String, dynamic> json) {
    return LiveTvChannel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }
}

