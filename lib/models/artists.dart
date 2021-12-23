class Artist {
  final String id;
  final String image;
  final String name;
  final String description;
  final List<String> eventsId;
  final List<String> hostsId;
  bool isTrending;
  bool isMostLiked;
  bool isRecentlyPerforming;
  bool isFavorite;

  Artist({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.eventsId,
    required this.hostsId,
    this.isTrending = false,
    this.isMostLiked = false,
    this.isRecentlyPerforming = false,
    this.isFavorite = false,
  });
}
