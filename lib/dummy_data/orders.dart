import 'package:biteflow/models/order.dart';
import 'package:biteflow/models/order_item.dart';

final Order tableOrder = Order(
  id: '1',
  status: 'pending',
  totalAmount: 1000,
  items: [
    OrderItem(
      id: '1',
      title: 'Fruits',
      quantity: 1,
      price: 1000,
      imageUrl: 'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
      description: 'This is a shirt',
      rating: 4.5,
      categoryId: 'c1',
      restaurantId: 'r1'
    ),
    OrderItem(
      id: '2',
      title: 'Pasta',
      quantity: 9,
      price: 2000,
      imageUrl: 'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
      description: 'This is a pants',
      rating: 4.5,
      notes: 'This is a note for pants',
      categoryId: 'c2',
      restaurantId: 'r1'
    ),
  ],
  userIDs: ['1', '2'],
  paymentMethod: 'cash',
  restaurantId: '1',
  orderNumber: 73,
);