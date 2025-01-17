import 'package:flutter/material.dart';
import 'package:biteflow/viewmodels/manager_menu_view_model.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/models/menu_item.dart';

class ItemsList extends StatefulWidget {
  const ItemsList({super.key});

  @override
  State<ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
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
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  item.title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ]),
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
    final viewModel = context.watch<ManagerMenuViewModel>();
    return Expanded(
      child: SingleChildScrollView(
        child: viewModel.menuItemsOfSelectedCategory!.isEmpty
            ? const Center(child: Text('No items'))
            : Column(
                children: viewModel.menuItemsOfSelectedCategory!
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
                                  if (item.discountPercentage > 0)
            Row(
              children: [
                Text(
                  item.price.toStringAsFixed(2), // Old price
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    decoration:
                        TextDecoration.lineThrough, // Strikethrough effect
                  ),
                ),
                const SizedBox(width: 4), // Space between old and new prices
                Text(
                  '${(item.price * (1 - item.discountPercentage/100)).toStringAsFixed(2)} \$', // New discounted price
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                      overflow:
                          TextOverflow.clip // Highlighted color for new price
                      ),
                ),
              ],
            )
          else
            Row(
              children: [
                Text(
                  '${item.price.toStringAsFixed(2)} \$',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
              ],
            ),
                                  // Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Text(
                                  //         '\$${item.price.toStringAsFixed(2)}',
                                  //         style: const TextStyle(
                                  //             fontSize: 14, color: Colors.grey),
                                  //       ),
                                        
                                  //     ]),
                                ],
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
      ),
    );
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
