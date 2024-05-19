import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_management/controllers/conseil_controller.dart';
import 'package:pharmacy_management/models/conseil_model.dart';
import '../../functions.dart';

class ConseilsList extends StatelessWidget {
  final String productUID;
  final String description;
  ConseilsList({required this.productUID, required this.description});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Description'),
                Tab(text: 'Conseils d\'utilisation'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  DescriptionTab(productUID: productUID, description: description,),
                  ConseilTab(productUID: productUID),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DescriptionTab extends StatelessWidget {
  final String productUID;
  final String description;

  const DescriptionTab({super.key, required this.productUID, required this.description});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(description),
        ],
      ),
    );
  }
}

class ConseilTab extends StatelessWidget {
  final String productUID;

  const ConseilTab({super.key, required this.productUID});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: advices.where('productUID', isEqualTo: productUID).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.separated(
            itemCount: streamSnapshot.data!.docs.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
              return FutureBuilder(
                future: ConseilController().fetchAdvicesByProductId(productUID),
                builder: (context, AsyncSnapshot<ConseilModel?> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return Container(
                    margin: const EdgeInsets.all(5),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            title: Text(
                              documentSnapshot['content'],
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
