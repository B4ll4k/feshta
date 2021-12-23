class Ticket {
  final String id;
  final String name;
  final String image;
  final String description;
  final int quantity;
  final int remaining;
  final String qr;
  final String location;
  final DateTime start;
  final double price;
  final String hostName;
  final bool isActive;
  final bool isPast;

  Ticket({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.quantity,
    required this.remaining,
    required this.qr,
    required this.location,
    required this.start,
    required this.price,
    required this.hostName,
    required this.isActive,
    required this.isPast,
  });
}
