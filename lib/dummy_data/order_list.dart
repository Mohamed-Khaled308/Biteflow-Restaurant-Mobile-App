import 'package:biteflow/models/order_item.dart';

final List<OrderItem> orderList = [
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
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg/800px-Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg',
      description: 'This is a pants',
      rating: 4.5,
      notes: 'This is a note for pants',
      categoryId: 'c2',
      restaurantId: 'r1'
    ),

    OrderItem(
      id: '3',
      title: 'Shoes',
      quantity: 1,
      price: 3000,
      imageUrl: 'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
      description: 'This is a shoes',
      rating: 4.5,
      categoryId: 'c3',
      restaurantId: 'r1'
    ),
    OrderItem(
      id: '4',
      title: 'Shirt',
      quantity: 1,
      price: 4000,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg/800px-Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg',
      description: 'This is a shirt',
      rating: 4.5,
      categoryId: 'c4',
      restaurantId: 'r1'
    ),
  ];