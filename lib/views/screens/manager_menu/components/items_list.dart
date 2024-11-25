import 'package:flutter/material.dart';
import 'package:biteflow/view-model/manager_menu_view_model.dart';
import 'package:biteflow/locator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:biteflow/models/menu_item.dart';

class ItemsList extends StatefulWidget {
  const ItemsList({super.key});

  @override
  State<ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  final ManagerMenuViewModel _viewModel = getIt<ManagerMenuViewModel>();

  void showItemDetails(BuildContext context, MenuItem item) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ]
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  item.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // return const Text('Items List');
    return AnimatedBuilder(
        animation: _viewModel,
        builder: (context, _) {
          return Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _viewModel.menuItemsOfSelectedCategory
                    .map((item) => GestureDetector(
                          onTap: () => showItemDetails(context, item),
                          child: Card(
                            margin: const EdgeInsets.all(8),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    item.imageUrl,
                                    width: double.infinity,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$${item.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                        Row(
                                          children: [
                                            RatingBarIndicator(
                                              rating: item.rating,
                                              itemBuilder: (context, index) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              itemCount: 5,
                                              itemSize: 16,
                                              direction: Axis.horizontal,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              item.rating.toStringAsFixed(1),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                      ]),
                                ],
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          );
        });
    // return Container(
    //   child: ListView.builder(
    //     itemCount: _viewModel.menuItemsOfSelectedCategory.length,
    //     itemBuilder: (context, index) {
    //       final item = _viewModel.menuItemsOfSelectedCategory[index];
    //       return Card(
    //           margin: const EdgeInsets.all(8),
    //           child: ListTile(
    //             // contentPadding: const EdgeInsets.all(8),
    //             // leading: Image.network(
    //             //   item.imageUrl,
    //             //   width: 60,
    //             //   height: 60,
    //             //   fit: BoxFit.cover,
    //             // ),
    //             title: Text(item.title),
    //             // subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
    //             // onTap: () => showItemDetails(context, item),
    //           ),
    //         );
    //     },
    //   ),
    // );
  }
}
