import './inventorySlotDetails.dart';
import 'inventorySlot.dart';

class InventorySlotWithGenericPageItem extends InventorySlot {
  String name;

  InventorySlotWithGenericPageItem(
      {InventorySlotDetails pageItem, int quantity})
      : super(pageItem: pageItem, quantity: quantity) {
    name = pageItem.name;
  }
}
