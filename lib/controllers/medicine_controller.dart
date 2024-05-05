import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmacy_management/models/medicine_model.dart';


class MedicineController {

  // Collection reference
  final CollectionReference medicines = FirebaseFirestore.instance.collection('medicines');

  Future<void> addMedicine(MedicineModel medicine) async {
    try {
      // Create a new document in the "medicines" collection
      DocumentReference docRef = await medicines.add({
        'name': medicine.name,
        'price': medicine.price,
        'quantity': medicine.quantity,
        'ownerUID': medicine.ownerUID,
        'thumbnail': medicine.thumbnail,
        'expiration': medicine.expiration,
        'description': medicine.description,
      });

      // Retrieve the ID of the newly created document
      String docId = docRef.id;

      // Update the document with the UID
      await medicines.doc(docId).update({
        'uid': docId,
        'ownerUID': FirebaseAuth.instance.currentUser?.uid,
      });
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  Future<void> updateMedicine(String docId, MedicineModel updatedMedicine) async {
    try {
      await medicines.doc(docId).update({
        'name': updatedMedicine.name,
        'price': updatedMedicine.price,
        'quantity': updatedMedicine.quantity,
        'thumbnail': updatedMedicine.thumbnail,
        'expiration': updatedMedicine.expiration,
        'description': updatedMedicine.description,
      });
    } catch (e) {
      print('Error updating data: $e');
    }
  }

  Future<void> deleteMedicine(String docId) async {
    try {
      await medicines.doc(docId).delete();
    } catch (e) {
      print('Error deleting data: $e');
    }
  }
}
