import 'package:biteflow/models/order.dart';
import 'package:biteflow/models/order_item.dart';
import 'package:biteflow/models/client.dart';
import 'package:biteflow/models/order_clients_payment.dart';
import 'package:biteflow/models/order_item_participant.dart';


// They all have same restaurantID corresponding to the same manager
final List<Order> managerListOfOrders = [
  Order(
      id: '1',
      status: 'pending',
      totalAmount: 1000,
      items: [
        OrderItem(
          id: '1',
          title: 'Fruits',
          quantity: 1,
          price: 1000,
          imageUrl:
              'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
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
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg/800px-Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg',
          description: 'This is a pants',
          rating: 4.5,
          categoryId: 'c2',
          notes: 'This is a note for pants',
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
      // userIDs: ['1', '2'],
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
      orderNumber: 1),
  Order(
      id: '2',
      status: 'in progress',
      totalAmount: 500,
      items: [
        OrderItem(
          id: '1',
          title: 'Fruits',
          quantity: 1,
          price: 3000,
          imageUrl:
              'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
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
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg/800px-Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg',
          description: 'This is a pants',
          rating: 4.5,
          categoryId: 'c3',
          restaurantId: 'r1',
          notes: 'This is a note for pants',
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
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg/800px-Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg',
          description: 'This is a pants',
          rating: 3.5,
          categoryId: 'c3',
          restaurantId: 'r1',
          notes: 'This is a note for pants',
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
      // userIDs: ['1', '2'],
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
      orderNumber: 2),
  Order(
      id: '3',
      status: 'accepted',
      totalAmount: 800,
      items: [
        OrderItem(
          id: '1',
          title: 'Vegetables',
          quantity: 1,
          price: 3000,
          imageUrl:
              'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
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
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg/800px-Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg',
          description: 'This is a pants',
          rating: 4.5,
          categoryId: 'c3',
          restaurantId: 'r1',
          notes: 'This is a note for pants',
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
      // userIDs: ['1', '2'],
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
      orderNumber: 23),
  Order(
      id: '3',
      status: 'served',
      totalAmount: 800,
      items: [
        OrderItem(
          id: '1',
          title: 'Vegetables',
          quantity: 1,
          price: 3000,
          imageUrl:
              'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
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
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg/800px-Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg',
          description: 'This is a pants',
          rating: 4.5,
          categoryId: 'c3',
          restaurantId: 'r1',
          notes: 'This is a note for pants',
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
      // userIDs: ['1', '2'],
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
      orderNumber: 76),
];

// They should be of same size as manager_list_of_orders
final List<Client> orderClients = [
  Client(
    id: '1',
    email: 'a@g.com',
    name: 'Ahmad',
    orderIds: ['1'],
  ),
  // Client(
  //   id: '1',
  //   email: 'a@g.com',
  //   name: 'Ahmad',
  //   nationality: 'Egyptian',
  //   birthDate: DateTime(1999, 1, 1),
  //   orderIds: ['1'],
  // ),
  // Client(
  //   id: '1',
  //   email: 'a@g.com',
  //   name: 'Ahmad',
  //   nationality: 'Egyptian',
  //   birthDate: DateTime(1999, 1, 1),
  //   orderIds: ['1'],
  // ),
];
