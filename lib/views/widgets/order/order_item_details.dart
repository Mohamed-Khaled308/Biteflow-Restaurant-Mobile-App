import 'package:biteflow/locator.dart';
import 'package:biteflow/models/order_item.dart';
import 'package:biteflow/models/order_item_participant.dart';
import 'package:biteflow/viewmodels/client_orders_view_model.dart';
import 'package:biteflow/views/widgets/cart/card_trait.dart';
import 'package:biteflow/views/widgets/user/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transparent_image/transparent_image.dart';

class OrderItemDetails extends StatelessWidget {
  const OrderItemDetails(this.orderItem, {super.key});

  final OrderItem orderItem;
  @override
  Widget build(BuildContext context) {
    final viewmodel = getIt<ClientOrdersViewModel>();
    bool isClientInItems = false;
    for (final orderItemParticipant in orderItem.participants) {
      if (orderItemParticipant.userId == viewmodel.clientLogged.id) {
        isClientInItems = true;
        break;
      }
    }
    final discountPercentage = orderItem.discountPercentage;
    final price = orderItem.price * orderItem.quantity;
    final newPrice = price * (1 - discountPercentage / 100);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isClientInItems 
          ? Colors.blue.shade50 
          : Theme.of(context).scaffoldBackgroundColor,
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
                        : Theme.of(context).secondaryHeaderColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  OrderItemCardTrait(
                    Icons.production_quantity_limits_outlined,
                    isClientInItems ? Colors.green.shade600 : Colors.orange,
                    'Quantity: ${orderItem.quantity}',
                    isClientInItems ? Colors.green.shade900 : Theme.of(context).secondaryHeaderColor,
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
                  
                  if (discountPercentage > 0)
            Row(
              children: [
                Text(
                  price.toStringAsFixed(2), // Old price
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    decoration:
                        TextDecoration.lineThrough, // Strikethrough effect
                  ),
                ),
                const SizedBox(width: 4), // Space between old and new prices
                Text(
                  '${newPrice.toStringAsFixed(2)} \$', // New discounted price
                  style: TextStyle(
                      fontSize: 13.sp,
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
                  '${price.toStringAsFixed(2)} \$',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
              ],
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
                      child:  Icon(
                        Icons.check,
                        color: Theme.of(context).secondaryHeaderColor,
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