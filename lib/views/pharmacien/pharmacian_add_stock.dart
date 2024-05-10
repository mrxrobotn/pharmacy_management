import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:pharmacy_management/functions.dart';
import 'package:pharmacy_management/models/medicine_model.dart';

import '../../constants.dart';
import '../../controllers/medicine_controller.dart';

class AddMedecinesPage extends StatefulWidget {
  const AddMedecinesPage({Key? key}) : super(key: key);

  @override
  State<AddMedecinesPage> createState() => _AddMedecinesPageState();
}

class _AddMedecinesPageState extends State<AddMedecinesPage> {

  final _FormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController expirationController = TextEditingController();
  File? _selectedImage;
  DateTime selectedDate = DateTime.now();

  Status _selectedStatus = Status.En_stock;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context, await imagePicker.pickImage(source: ImageSource.camera));
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context, await imagePicker.pickImage(source: ImageSource.gallery));
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        expirationController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un nouveau médicament'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _FormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(75),
                      image: _selectedImage != null
                          ? DecorationImage(
                        image: FileImage(_selectedImage!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: _selectedImage == null
                        ? const Icon(
                      Icons.camera_alt,
                      size: 40,
                      color: Colors.white,
                    )
                        : null,
                  ),
                ),
                const SizedBox(height: kDefaultPadding * 2),
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  cursorColor: kPrimaryColor,
                  decoration: const InputDecoration(
                    hintText: "Nom",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(kDefaultPadding),
                      child: Icon(Icons.medication_rounded),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Saisir un nom';
                    } else if (value.length > 13) {
                      return 'Le nombre maximum de caractères est de 13';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: kDefaultPadding),
                TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  cursorColor: kPrimaryColor,
                  decoration: const InputDecoration(
                    hintText: "Description",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(kDefaultPadding),
                      child: Icon(Icons.description),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Saisir une description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: kDefaultPadding),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  cursorColor: kPrimaryColor,
                  decoration: const InputDecoration(
                    hintText: "Prix",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(kDefaultPadding),
                      child: Icon(Icons.monetization_on_sharp),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Saisir un prix';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: kDefaultPadding),
                TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  cursorColor: kPrimaryColor,
                  decoration: const InputDecoration(
                    hintText: "Quantité",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(kDefaultPadding),
                      child: Icon(Icons.numbers),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir un nombre';
                    } else if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'Veuillez entrer un nombre correct';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: kDefaultPadding),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(75),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
                      const Text("Date d'expiration:", style: TextStyle(fontSize: 16),),
                      const Spacer(),
                      Text(
                        '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        icon: const Icon(Icons.edit_outlined),
                      ),
                    ],
                  )
                ),
                const SizedBox(height: kDefaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Disponibilité: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    DropdownButton<Status>(
                      value: _selectedStatus,
                      items: Status.values.map((status) {
                        return DropdownMenuItem<Status>(
                          value: status,
                          child: Text(status.toString().split('.')[1]),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value!;
                        });
                      },
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: kDefaultPadding),

                ElevatedButton(
                  onPressed: () async {
                    if (_FormKey.currentState!.validate()) {
                      if (_selectedImage != null) {
                        // Upload image to Firebase Storage
                       
                        String imageUrl = await _uploadImage(nameController.text);

                        MedicineModel medicine = MedicineModel(
                          uid: '',
                          name: nameController.text,
                          description: descriptionController.text,
                          price: int.parse(priceController.text),
                          quantity: int.parse(quantityController.text),
                          ownerUID: '',
                          thumbnail: imageUrl,
                          expiration: expirationController.text,
                          availability: _selectedStatus.toString().split('.')[1],
                        );
                        await MedicineController().addMedicine(medicine);

                        // Show a success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Médicament ajouté avec succès'),
                          ),
                        );

                        // Clear the form fields
                        nameController.clear();
                        priceController.clear();
                        quantityController.clear();
                        _selectedImage = null;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Veuillez remplir tous les champs'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Ajouter',style: TextStyle(
                      fontSize: 16.0,
                      color: kWhite
                  ),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<String> _uploadImage(String fileName) async {
    try {
      if (_selectedImage != null) {

        // Upload image to Firebase Storage
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('medicines/$fileName.jpg');

        await ref.putFile(_selectedImage!);

        // Get the image URL
        String imageUrl = await ref.getDownloadURL();

        return imageUrl;
      } else {
        print('No image selected');
        return '';
      }
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

}