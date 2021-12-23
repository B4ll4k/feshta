class Host {
  final String id;
  final String name;
  final String logo;
  final String description;
  final String address;
  final bool isSponsored;
  final List<String> eventsId;
  final List<String> artistsId;
  bool isTrending;
  bool isRecent;
  bool isMostLiked;
  bool isFavorite;

  Host({
    required this.id,
    required this.name,
    required this.logo,
    required this.description,
    required this.address,
    required this.isSponsored,
    required this.artistsId,
    required this.eventsId,
    this.isTrending = false,
    this.isRecent = false,
    this.isFavorite = false,
    this.isMostLiked = false,
  });
}
