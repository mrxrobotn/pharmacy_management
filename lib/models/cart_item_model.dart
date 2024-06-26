import 'package:pharmacy_management/models/medicine_model.dart';


class CartItem {
  final MedicineModel medicine;
  int quantity;

  CartItem({required this.medicine, this.quantity = 1});
  Map<String, dynamic> toMap() {
    return {
      'medicine': medicine,
      'quantity': quantity,
    };
  }
}