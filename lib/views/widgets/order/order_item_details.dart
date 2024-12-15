import 'package:biteflow/locator.dart';
import 'package:biteflow/main.dart';
import 'package:biteflow/models/order_item.dart';
import 'package:biteflow/models/order_item_participant.dart';
import 'package:biteflow/viewmodels/client_orders_view_model.dart';
import 'package:biteflow/views/widgets/cart/card_trait.dart';
import 'package:biteflow/views/widgets/user/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class OrderItemDetails extends StatelessWidget {
  const OrderItemDetails(this.orderItem, {super.key});

  final OrderItem orderItem;
  @override
  Widget build(BuildContext context) {
    final _viewmodel = getIt<ClientOrdersViewModel>();
    bool isClientInItems = false;
    for (final OrderItemParticipant in orderItem.participants) {
      if (OrderItemParticipant.userId == _viewmodel.clientLogged.id) {
        isClientInItems = true;
        break;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isClientInItems 
          ? Colors.blue.shade50 
          : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: isClientInItems 
          ? Border.all(color: Colors.blue.shade200, width: 2)
          : null,
        boxShadow: [
          BoxShadow(
            color: isClientInItems 
              ? Colors.blue.withOpacity(0.3) 
              : Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderItem.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isClientInItems 
                        ? Colors.blue.shade800 
                        : Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  OrderItemCardTrait(
                    Icons.production_quantity_limits_outlined,
                    isClientInItems ? Colors.green.shade600 : Colors.orange,
                    'Quantity: ${orderItem.quantity}',
                    isClientInItems ? Colors.green.shade900 : Colors.black87,
                  ),
                  if (orderItem.notes.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        orderItem.notes,
                        style: TextStyle(
                          color: isClientInItems 
                            ? Colors.blue.shade700 
                            : Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  OrderItemCardTrait(
                    Icons.star,
                    isClientInItems ? Colors.amber.shade600 : Colors.green,
                    'Rating: ${orderItem.rating}',
                    isClientInItems ? Colors.amber.shade900 : Colors.black87,
                  ),
                  OrderItemCardTrait(
                    Icons.price_change_rounded,
                    isClientInItems ? Colors.purple.shade600 : Colors.red,
                    '${orderItem.price} \$',
                    isClientInItems ? Colors.purple.shade900 : Colors.black87,
                  ),
                  Row(
                    children: [
                      for (final OrderItemParticipant participant in orderItem.participants)
                        UserAvatar(userId: participant.userId, userName: participant.userName),
                    ],
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
                  image: NetworkImage(orderItem.imageUrl),
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
                if (isClientInItems)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}