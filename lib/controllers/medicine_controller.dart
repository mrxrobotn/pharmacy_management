import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmacy_management/models/medicine_model.dart';

import '../functions.dart';


class MedicineController {

  Future<List<MedicineModel>> getAllMedicines() async {
    try {
      QuerySnapshot querySnapshot = await medicines.get();
      List<MedicineModel> medicineList = querySnapshot.docs
          .map((doc) => MedicineModel(
        uid: doc.id,
        name: doc['name'],
        description: doc['description'],
        price: doc['price'],
        quantity: doc['quantity'],
        ownerUID: doc['ownerUID'],
        thumbnail: doc['thumbnail'],
        expiration: doc['expiration'],
        availability: doc['availability'],
      ))
          .toList();
      return medicineList;
    } catch (e) {
      print('Error fetching medicines: $e');
      return [];
    }
  }

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
        'availability': medicine.availability,
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
        'availability': updatedMedicine.availability,
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

  Future<MedicineModel?> getMedicineByUid(String uid) async {
    try {
      DocumentSnapshot docSnapshot = await medicines.doc(uid).get();
      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        return MedicineModel(
          uid: docSnapshot.id,
          name: data['name'],
          description: data['description'],
          price: data['price'],
          quantity: data['quantity'],
          ownerUID: data['ownerUID'],
          thumbnail: data['thumbnail'],
          expiration: data['expiration'],
          availability: data['availability'],
        );
      } else {
        return null; // Medicine not found
      }
    } catch (e) {
      print('Error getting medicine by UID: $e');
      throw Exception('Failed to get medicine by UID');
    }
  }

  Future<void> updateMedicineByName(String name, MedicineModel updatedMedicine) async {
    try {
      QuerySnapshot querySnapshot = await medicines.where('name', isEqualTo: name).get();
      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        await medicines.doc(docId).update({
          'name': updatedMedicine.name,
          'price': updatedMedicine.price,
          'quantity': updatedMedicine.quantity,
          'thumbnail': updatedMedicine.thumbnail,
          'expiration': updatedMedicine.expiration,
          'description': updatedMedicine.description,
          'availability': updatedMedicine.availability,
        });
      } else {
        print('Medicine not found');
      }
    } catch (e) {
      print('Error updating data: $e');
    }
  }

  Future<void> updateQuantityByName(String medicineName, int newQuantity) async {

    // Fetch the medicine document by its name
    QuerySnapshot snapshot = await medicines
        .where('name', isEqualTo: medicineName)
        .get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = snapshot.docs.first;
      final medicine = MedicineModel.fromSnapshot(doc);

      // Update the quantity
      await medicines.doc(medicine.uid).update({
        'quantity': newQuantity,
      });
      print('Quantity updated successfully for $medicineName.');
    } else {
      print('No medicine found with the name $medicineName.');
    }
  }
}
