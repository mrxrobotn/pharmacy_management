import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmacy_management/constants.dart';
import 'package:pharmacy_management/controllers/conseil_controller.dart';
import 'package:pharmacy_management/controllers/medicine_controller.dart';
import 'package:pharmacy_management/controllers/stock_controller.dart';
import 'package:pharmacy_management/functions.dart';
import 'package:pharmacy_management/models/conseil_model.dart';
import 'package:pharmacy_management/models/stock_model.dart';

import '../client/conseils_list.dart';

class PharmacienMedicineDetails extends StatefulWidget {
  final String uid;
  final String name;
  final String description;
  final String price;
  final String quantity;
  final String thumbnail;
  final String expiration;
  final String availability;
  final DocumentSnapshot documentSnapshot;

  const PharmacienMedicineDetails({
    super.key,
    required this.uid,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.documentSnapshot,
    required this.thumbnail,
    required this.expiration,
    required this.availability,
  });

  @override
  _PharmacienMedicineDetailsState createState() =>
      _PharmacienMedicineDetailsState();
}

class _PharmacienMedicineDetailsState extends State<PharmacienMedicineDetails> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController expirationController = TextEditingController();
  final TextEditingController adviceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
    descriptionController.text = widget.description;
    priceController.text = widget.price;
    quantityController.text = widget.quantity;
    expirationController.text = widget.expiration;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF545D68),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            'Description du produit',
            style: TextStyle(
              fontFamily: 'Varela',
              fontSize: 24.0,
              color: Color(0xFF545D68),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
                flex: 2,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 50),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Color(0xff0043ba), Color(0xff006df1)]),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.thumbnail)),
                      ),
                    ),
                  ],
                )),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                    child: Column(
                      children: [
                        Text(
                          widget.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton.extended(
                              onPressed: () async {
                                await update(context);
                              },
                              heroTag: 'update',
                              elevation: 0,
                              label: const Text("Modifier"),
                              icon: const Icon(Icons.edit),
                            ),
                            const SizedBox(width: 10.0),
                            FloatingActionButton.extended(
                              onPressed: () async {
                                await delete(context);
                              },
                              heroTag: 'delete',
                              elevation: 0,
                              backgroundColor: Colors.red,
                              label: const Text("Supprimer"),
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton.extended(
                              onPressed: () async {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Donner une conseil:'),
                                    content: TextField(
                                      controller: adviceController,
                                      decoration: const InputDecoration(
                                          labelText: 'Conseil', border: OutlineInputBorder()),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          ConseilModel advice = ConseilModel(
                                              content: adviceController.text,
                                              senderUID: userUID!,
                                              productUID: widget.uid
                                          );
                                          ConseilController().addNewAdvice(advice);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Ajouter'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Fermer'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              elevation: 0,
                              backgroundColor: kBlue,
                              label: const Text("Conseil"),
                              icon: const Icon(Icons.send),
                            ),
                            const SizedBox(width: 10.0),
                            FloatingActionButton.extended(
                              onPressed: () async {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Commander cette produit:'),
                                    content: TextField(
                                      keyboardType: TextInputType.number,
                                      controller: quantityController,
                                      decoration: const InputDecoration(
                                          labelText: 'Quantité', border: OutlineInputBorder()),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          String number = Random().nextInt(4294967296).toString();
                                          StockModel stock = StockModel(
                                              productUID: widget.uid,
                                              orderBy: userUID!,
                                              quantity: quantityController.text,
                                              status: 'en attente',
                                              orderTime: Timestamp.now(),
                                              deliveryUID: '',
                                              number: number
                                          );
                                          StockController().createStock(stock);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Oui'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Non'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              elevation: 0,
                              backgroundColor: Colors.green,
                              label: const Text("Commander"),
                              icon: const Icon(Icons.send),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                            width: 400,
                            height: 400,
                            child: ConseilsList(productUID: widget.uid, description: widget.description,)
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }


  Future<void> delete(BuildContext context) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Supprimer'),
        content: const Text('Voulez-vous vraiment supprimer?'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await MedicineController().deleteMedicine(widget.uid);
              Navigator.of(context).pop();
            },
            child: const Text('Oui'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Non'),
          ),
        ],
      ),
    );
  }

  Future<void> update(BuildContext context) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Modifier les détails'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                keyboardType: TextInputType.name,
                controller: nameController,
                decoration: const InputDecoration(
                    labelText: 'Nom', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              TextField(
                keyboardType: TextInputType.multiline,
                controller: descriptionController,
                decoration: const InputDecoration(
                    labelText: 'Description', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: priceController,
                decoration: const InputDecoration(
                    labelText: 'Prix', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              TextField(
                keyboardType: TextInputType.number,
                controller: quantityController,
                decoration: const InputDecoration(
                    labelText: 'Quantité', border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final String name = nameController.text;
              final String description = descriptionController.text;
              final int price = int.parse(priceController.text);
              final int quantity = int.parse(quantityController.text);
              await medicines.doc(widget.documentSnapshot.id).update({
                'name': name,
                'price': price,
                'quantity': quantity,
                'description': description,
              });

              setState(() {});

              Navigator.of(context).pop();
            },
            child: const Text('Modifier'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
