import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_management/controllers/user_controller.dart';

import '../../constants.dart';
import '../../functions.dart';
import '../../models/user_model.dart';

class PharmacienOrders extends StatefulWidget {
  const PharmacienOrders({super.key});

  @override
  State<PharmacienOrders> createState() => _PharmacienOrdersState();
}

class _PharmacienOrdersState extends State<PharmacienOrders> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  late Stream<QuerySnapshot> _ordersStream;

  @override
  void initState() {
    super.initState();
    _ordersStream = orders.where('recieverUID', isEqualTo: userUID).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
            ),
            child: const ListTile(
              title: Text(
                "Commandes",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: kWhite),
              ),
              subtitle: Text(
                "Tous les commandes",
                textAlign: TextAlign.center,
                style: TextStyle(color: kWhite),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(),
              child: StreamBuilder(
                stream: _ordersStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    return ListView.separated(
                      itemCount: streamSnapshot.data!.docs.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];

                        return FutureBuilder(
                          future: UserController().getUserDataById(documentSnapshot['senderUID']),
                          builder: (context, AsyncSnapshot<UserModel?> userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (userSnapshot.hasData && userSnapshot.data != null) {
                              UserModel user = userSnapshot.data!;
                              return Container(
                                margin: const EdgeInsets.all(5),
                                child: Card(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage('${documentSnapshot['thumbnail']}'), // Use your user's image URL here
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          title: Text(
                                            'Nom: ${documentSnapshot['name']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          subtitle: Text(
                                            'Commandé par: ${user.name}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              // Accept command logic
                                            },
                                            icon: const Icon(Icons.check),
                                            color: Colors.green,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              // Decline command logic
                                            },
                                            icon: const Icon(Icons.close),
                                            color: Colors.red,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}