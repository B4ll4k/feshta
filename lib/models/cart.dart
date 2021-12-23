class Cart {
  final String orderId;
  final String ticketId;
  final String eventId;
  final String name;
  int quantity;
  final double price;
  final String description;
  final String image;
  double total;

  Cart({
    required this.orderId,
    required this.ticketId,
    required this.eventId,
    required this.name,
    required this.description,
    required this.image,
    required this.quantity,
    required this.price,
    required this.total,
  });
}

// import 'products.dart';

// class Cart {
//   final Product productt;
//   final int numOfItem;

//   Cart({required this.productt, required this.numOfItem});

//   Product get product {
//     return productt;
//   }
// }

// // Demo data for our cart

// List<Cart> demoCarts = [
//   Cart(productt: demoProducts[0], numOfItem: 2),
//   Cart(productt: demoProducts[1], numOfItem: 1),
//   Cart(productt: demoProducts[3], numOfItem: 1),
// ];
