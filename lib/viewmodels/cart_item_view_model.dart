import 'package:biteflow/core/providers/notification_provider.dart';
import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/cart.dart';
import 'package:biteflow/services/firestore/cart_service.dart';
import 'package:biteflow/viewmodels/base_model.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:logger/logger.dart';

class CartItemViewModel extends BaseModel {
  final _cartService = getIt<CartService>();
  final _cartViewModel = getIt<CartViewModel>();
  final _userProvider = getIt<UserProvider>();
  final _notificationProvider = getIt<NotificationProvider>();

  CartItemViewModel({required this.itemId}) {
    _itemQuantity = cartItem.quantity;
    _notes = cartItem.notes;
  }

  Set<CartParticipant> selectedParticipants = {};
  final String itemId;
  late int _itemQuantity;
  late String _notes;

  CartItem get cartItem => _cartViewModel.getItem(itemId)!;
  int get itemQuantity => _itemQuantity;
  String get notes => _notes;

  void updateNote(String newNote) {
    _notes = newNote;
    notifyListeners();
  }

  void updateItemQuantity(int val) {
    _itemQuantity += val;
    notifyListeners();
  }

  void updateItem() async {
    cartItem.quantity = _itemQuantity;
    cartItem.notes = _notes;
    setBusy(true);
    final result =
        await _cartService.updateItemInCart(_cartViewModel.cart!.id, cartItem);
    if (result.isSuccess) {
    } else {
      getIt<Logger>().e(result.error);
    }
    setBusy(false);
  }

  void addParticipantToItem(CartParticipant participant) async {
    participant.status = ParticipantStatus.pending;
    cartItem.participants.add(participant);
    setBusy(true);
    final result =
        await _cartService.updateItemInCart(_cartViewModel.cart!.id, cartItem);
    if (result.isSuccess) {
    } else {
      getIt<Logger>().e(result.error);
    }
    setBusy(false);
    notifyListeners();
  }

  void removeParticipantFromItem(String participantId) async {
    cartItem.participants
        .removeWhere((participant) => participant.id == participantId);
    setBusy(true);
    final result =
        await _cartService.updateItemInCart(_cartViewModel.cart!.id, cartItem);
    if (result.isSuccess) {
    } else {
      getIt<Logger>().e(result.error);
    }
    setBusy(false);
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
    List<String> ids = [];
    for (var participant in selectedParticipants) {
      addParticipantToItem(participant);
      ids.add(participant.id);
    }
    if (ids.isNotEmpty) {
      _notificationProvider.sendSplitRequestNotification(
          ids,
          'Share with me',
          'User ${_userProvider.user!.name} is inviting you to share ${cartItem.menuItem.title} with him!',
          cartItem.menuItem.id);
    }
    selectedParticipants.clear();
    notifyListeners();
  }
}
