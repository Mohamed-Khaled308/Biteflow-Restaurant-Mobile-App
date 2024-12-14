import 'package:biteflow/locator.dart';
import 'package:biteflow/models/cart.dart';
import 'package:biteflow/services/firestore/cart_service.dart';
import 'package:biteflow/viewmodels/base_model.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:logger/logger.dart';

class CartItemViewModel extends BaseModel {
  CartItem cartItem;
  final _cartService = getIt<CartService>();

  Set<CartParticipant> selectedParticipants = {};

  CartItemViewModel({required this.cartItem});

  void updateNote(String newNote) {
    cartItem.notes = newNote;
    notifyListeners();
  }

  void updateItemQuantity(int val) {
    cartItem.quantity += val;
    notifyListeners();
  }

  void updateItem() async {
    setBusy(true);
    final result = await _cartService.updateItemInCart(
        getIt<CartViewModel>().cart!.id, cartItem);
    if (result.isSuccess) {
      
    } else {
      getIt<Logger>().e(result.error);
    }
    setBusy(false);
  }

  void addParticipantToItem(CartParticipant participant) {
    participant.status = ParticipantStatus.pending;
    cartItem.participants.add(participant);
    updateItem();
    notifyListeners();
  }

  void removeParticipantFromItem(String participantId) {
    cartItem.participants
        .removeWhere((participant) => participant.id == participantId);
    updateItem();
    notifyListeners();
  }

  void toggleParticipantSelection(
      CartParticipant participant, bool isSelected) {
    if (isSelected) {
      selectedParticipants.add(participant);
    } else {
      selectedParticipants.remove(participant);
    }
    notifyListeners();
  }

  void sendInvitations() {
    for (var participant in selectedParticipants) {
      addParticipantToItem(participant);
    }
    selectedParticipants.clear();
    notifyListeners();
  }
}
