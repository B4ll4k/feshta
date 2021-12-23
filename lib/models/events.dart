class Event {
  final String id;
  final String image;
  final String name;
  final DateTime start;
  final DateTime end;
  bool isSponsored;
  String description;
  String offer;
  String location;
  String price;
  String info;
  List<String> categoryIds;
  List<String> hostIds;
  List<String> artistsId;
  bool isBooked;
  bool isTrending;
  bool isFavorite;
  String gps;

  Event({
    required this.id,
    required this.image,
    required this.name,
    required this.start,
    required this.end,
    required this.isSponsored,
    required this.description,
    required this.price,
    required this.info,
    required this.location,
    required this.categoryIds,
    required this.hostIds,
    required this.offer,
    required this.isBooked,
    required this.artistsId,
    this.isTrending = false,
    this.isFavorite = false,
    this.gps = '',
  });
}
