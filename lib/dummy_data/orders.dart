import 'package:biteflow/models/order.dart';
import 'package:biteflow/models/order_item.dart';
import 'package:biteflow/models/order_clients_payment.dart';
import 'package:biteflow/models/order_item_participant.dart';

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
      restaurantId: 'r1',
      participants: [
        OrderItemParticipant(
          userId: '1',
          userName: 'John Doe',
        ),
        OrderItemParticipant(
          userId: '2',
          userName: 'Jane Doe',
        ),
      ],
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
      restaurantId: 'r1',
      participants: [
        OrderItemParticipant(
          userId: '1',
          userName: 'John Doe',
        ),
        OrderItemParticipant(
          userId: '2',
          userName: 'Jane Doe',
        ),
      ],
    ),
  ],
  orderClientsPayment: [
    OrderClientsPayment(
      userId: '1',
      isPaid: true,
      amount: 1000,
    ),
    OrderClientsPayment(
      userId: '2',
      isPaid: false,
      amount: 2000,
    ),
  ],
  paymentMethod: 'cash',
  restaurantId: '1',
  orderNumber: 73,
);