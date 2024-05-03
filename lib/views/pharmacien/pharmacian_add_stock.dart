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
  File? _selectedImage;

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
                ElevatedButton(
                  onPressed: () async {
                    if (_FormKey.currentState!.validate()) {
                      if (_selectedImage != null) {
                        // Save data to Firebase
                        // Upload image to Firebase Storage
                        String imageUrl = await _uploadImage();

                        MedicineModel medicine = MedicineModel(
                          uid: '',
                          name: nameController.text,
                          description: descriptionController.text,
                          price: int.parse(priceController.text),
                          quantity: int.parse(quantityController.text),
                          ownerUID: '',
                          thumbnail: imageUrl,
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


  Future<String> _uploadImage() async {
    try {
      if (_selectedImage != null) {
        // Generate a unique filename for the image
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

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