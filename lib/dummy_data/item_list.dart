import '../models/menu_item.dart';

var menuItemsList = [
  // Offers
  MenuItem(
    id: 'm1',
    title: 'Buy 1 Get 1 Free Burger',
    price: 109,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrcToGxxm_FrDNoovsYfkTUd7VOMzAFzIy_w&s',
    description: 'A delicious double cheeseburger with a special offer!',
    rating: 4.8,
    categoryId: 'c1',
    restaurantId: 'r1',
  ),
  MenuItem(
    id: 'm2',
    title: 'Family Pizza Deal',
    price: 259,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrcToGxxm_FrDNoovsYfkTUd7VOMzAFzIy_w&s',
    description: 'Two large pizzas, a side, and a drink for the family.',
    rating: 4.7,
    categoryId: 'c1',
    restaurantId: 'r1',
  ),

  // Main Dishes
  MenuItem(
    id: 'm3',
    title: 'Grilled Chicken Breast',
    price: 159,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrcToGxxm_FrDNoovsYfkTUd7VOMzAFzIy_w&s',
    description: 'Tender grilled chicken breast served with steamed veggies.',
    rating: 4.5,
    categoryId: 'c2',
    restaurantId: 'r1',
  ),
  MenuItem(
    id: 'm4',
    title: 'Spaghetti Bolognese',
    price: 129,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrcToGxxm_FrDNoovsYfkTUd7VOMzAFzIy_w&s',
    description: 'Classic Italian spaghetti with rich meat sauce.',
    rating: 5,
    categoryId: 'c2',
    restaurantId: 'r1',
  ),
  MenuItem(
    id: 'm5',
    title: 'Grilled Chicken Breast',
    price: 159,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrcToGxxm_FrDNoovsYfkTUd7VOMzAFzIy_w&s',
    description: 'Tender grilled chicken breast served with steamed veggies.',
    rating: 4.5,
    categoryId: 'c2',
    restaurantId: 'r1',
  ),
  MenuItem(
    id: 'm6',
    title: 'Spaghetti Bolognese',
    price: 129,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrcToGxxm_FrDNoovsYfkTUd7VOMzAFzIy_w&s',
    description: 'Classic Italian spaghetti with rich meat sauce.',
    rating: 5,
    categoryId: 'c2',
    restaurantId: 'r1',
  ),
  MenuItem(
    id: 'm7',
    title: 'Grilled Chicken Breast',
    price: 159,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrcToGxxm_FrDNoovsYfkTUd7VOMzAFzIy_w&s',
    description: 'Tender grilled chicken breast served with steamed veggies.',
    rating: 4.5,
    categoryId: 'c2',
    restaurantId: 'r1',
  ),
  MenuItem(
    id: 'm8',
    title: 'Spaghetti Bolognese',
    price: 129,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrcToGxxm_FrDNoovsYfkTUd7VOMzAFzIy_w&s',
    description: 'Classic Italian spaghetti with rich meat sauce.',
    rating: 5,
    categoryId: 'c2',
    restaurantId: 'r1',
  ),

  // Breakfast
  MenuItem(
    id: 'm9',
    title: 'Pancakes with Maple Syrup',
    price: 329,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrcToGxxm_FrDNoovsYfkTUd7VOMzAFzIy_w&s',
    description: 'Fluffy pancakes topped with maple syrup and butter.',
    rating: 2,
    categoryId: 'c3',
    restaurantId: 'r1',
  ),
  MenuItem(
    id: 'm10',
    title: 'Avocado Toast',
    price: 150,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrcToGxxm_FrDNoovsYfkTUd7VOMzAFzIy_w&s',
    description: 'Whole-grain toast topped with creamy avocado spread.',
    rating: 4,
    categoryId: 'c3',
    restaurantId: 'r1',
  ),

  // Appetizers
  MenuItem(
    id: 'm11',
    title: 'Mozzarella Sticks',
    price: 699,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrcToGxxm_FrDNoovsYfkTUd7VOMzAFzIy_w&s',
    description: 'Crispy fried mozzarella cheese served with marinara sauce.',
    rating: 3,
    categoryId: 'c4',
    restaurantId: 'r1',
  ),
  MenuItem(
    id: 'm12',
    title: 'Loaded Nachos',
    price: 949,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrcToGxxm_FrDNoovsYfkTUd7VOMzAFzIy_w&s',
    description: 'Nachos topped with cheese, jalapeños, sour cream, and salsa.',
    rating: 41.8,
    categoryId: 'c4',
    restaurantId: 'r1',
  ),

  // Side Dishes
  MenuItem(
    id: 'm13',
    title: 'French Fries',
    price: 499,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrcToGxxm_FrDNoovsYfkTUd7VOMzAFzIy_w&s',
    description: 'Golden and crispy fries, lightly salted.',
    rating: 4.5,
    categoryId: 'c5',
    restaurantId: 'r1',
  ),
  MenuItem(
    id: 'm14',
    title: 'Garlic Bread',
    price: 549,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrcToGxxm_FrDNoovsYfkTUd7VOMzAFzIy_w&s',
    description: 'Warm garlic bread topped with butter and herbs.',
    rating: 4.7,
    categoryId: 'c5',
    restaurantId: 'r1',
  ),

  // Beverages
  MenuItem(
    id: 'm15',
    title: 'Fresh Orange Juice',
    price: 399,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrcToGxxm_FrDNoovsYfkTUd7VOMzAFzIy_w&s',
    description: 'Freshly squeezed orange juice with no added sugar.',
    rating: 4.8,
    categoryId: 'c6',
    restaurantId: 'r1',
  ),
  MenuItem(
    id: 'm16',
    title: 'Iced Coffee',
    price: 449,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrcToGxxm_FrDNoovsYfkTUd7VOMzAFzIy_w&s',
    description: 'Chilled coffee served over ice with a touch of milk.',
    rating: 4.7,
    categoryId: 'c6',
    restaurantId: 'r1',
  ),

  // Desserts
  MenuItem(
    id: 'm17',
    title: 'Chocolate Lava Cake',
    price: 699,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrcToGxxm_FrDNoovsYfkTUd7VOMzAFzIy_w&s',
    description: 'Warm chocolate cake with a gooey molten center.',
    rating: 4.9,
    categoryId: 'c7',
    restaurantId: 'r1',
  ),
  MenuItem(
    id: 'm18',
    title: 'Vanilla Ice Cream Sundae',
    price: 549,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrcToGxxm_FrDNoovsYfkTUd7VOMzAFzIy_w&s',
    description: 'Classic vanilla ice cream with chocolate syrup and a cherry.',
    rating: 4.8,
    categoryId: 'c7',
    restaurantId: 'r1',
  ),
  MenuItem(
    id: 'm19',
    title: 'Chocolate Ice Cream Sundae',
    price: 549,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrcToGxxm_FrDNoovsYfkTUd7VOMzAFzIy_w&s',
    description:
        'Classic Chocolate ice cream with chocolate syrup and a cherry.',
    rating: 2.5,
    categoryId: 'c7',
    restaurantId: 'r1',
  ),
];
