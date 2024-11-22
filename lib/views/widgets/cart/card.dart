import 'package:biteflow/locator.dart';
import 'package:biteflow/models/order_item.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/view-model/cart_view_model.dart';
import 'package:biteflow/views/widgets/cart/card_trait.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class OrderItemCard extends StatefulWidget {
  const OrderItemCard(this.orderItem, {super.key});
  final OrderItem orderItem;

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  final CartViewModel _viewModel = getIt<CartViewModel>();
  final NavigationService _navigationService = getIt<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Special Note'),
                content: TextField(
                  controller: _viewModel.notesController,
                  decoration: InputDecoration(
                    labelText: 'Note',
                    labelStyle: const TextStyle(color: Colors.blue),
                    hintText: 'Enter your note here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                  ),
                  maxLength: 100,
                  style: const TextStyle(fontSize: 16.0),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      _navigationService.pop();
                    },
                    child: Text('Cancel'),
                    style: TextButton.styleFrom(foregroundColor: Colors.blue),
                  ),
                  TextButton(
                    onPressed: () {
                      _navigationService.pop();
                      _viewModel.updateNotes(
                          widget.orderItem.id, _viewModel.notesController.text);
                      _viewModel.notesController.clear();
                      

                    },
                    child: Text('Okay'),
                    style: TextButton.styleFrom(foregroundColor: Colors.blue),
                  )
                ],
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.orderItem.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      const OrderItemCardTrait(
                        Icons.edit_note_rounded,
                        Colors.orange,
                        'Edit',
                        Colors.orange,
                      ),
                      if (widget.orderItem.notes.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            widget.orderItem.notes,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      OrderItemCardTrait(
                        Icons.star,
                        Colors.green,
                        'Rating: ${widget.orderItem.rating}',
                        Colors.black87,
                      ),
                      OrderItemCardTrait(
                        Icons.price_change_rounded,
                        Colors.red,
                        '${widget.orderItem.price} EGP',
                        Colors.black87,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(children: [
                    FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: NetworkImage(widget.orderItem.imageUrl),
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 130,
                          height: 130,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      left: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white.withOpacity(1),
                        ),
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () {
                                  _viewModel.decrementItemQuantity(
                                      widget.orderItem.id);
                                },
                                icon: const Icon(Icons.remove)),
                            Text('${widget.orderItem.quantity}'),
                            IconButton(
                                onPressed: () {
                                  _viewModel.incrementItemQuantity(
                                      widget.orderItem.id);
                                },
                                icon: const Icon(Icons.add)),
                          ],
                        ),
                      ),
                    )
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
