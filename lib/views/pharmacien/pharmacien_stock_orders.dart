import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_management/controllers/orders_controller.dart';
import 'package:pharmacy_management/controllers/stock_controller.dart';
import 'package:pharmacy_management/functions.dart';

import '../../constants.dart';
import '../../controllers/medicine_controller.dart';
import '../../models/medicine_model.dart';

class StockOrders extends StatefulWidget {
  const StockOrders({super.key});

  @override
  State<StockOrders> createState() => _StockOrdersState();
}

class _StockOrdersState extends State<StockOrders> {

  late Stream<List<Map<String, dynamic>>> _onholdOrders;
  late Stream<List<Map<String, dynamic>>> _inprogressOrders;
  late Stream<List<Map<String, dynamic>>> _deliveredOrders;

  @override
  void initState() {
    super.initState();
    _onholdOrders = const Stream.empty();
    _inprogressOrders = const Stream.empty();
    _deliveredOrders = const Stream.empty();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      setState(() {
        _onholdOrders = StockController().getOrders('en attente');
        _inprogressOrders = StockController().getOrders('en cours');
        _deliveredOrders = StockController().getOrders('livrée');
      });
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const ListTile(
            title: Text(
              "Commandes",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, color: kGrey),
            ),
          ),
        ),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'En attente', icon: Icon(Icons.timelapse)),
                Tab(text: 'En cours', icon: Icon(Icons.double_arrow)),
                Tab(text: 'Historique', icon: Icon(Icons.history)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(),
                      child: StreamBuilder(
                        stream: _onholdOrders,
                        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>>
                            streamSnapshot) {
                          if (!streamSnapshot.hasData) {
                            return const Text('Aucun commandes trouvé');
                          }
                          if (streamSnapshot.hasData) {
                            return ListView.separated(
                              itemCount: streamSnapshot.data!.length,
                              separatorBuilder: (context, index) => const Divider(),
                              itemBuilder: (context, index) {
                                final documentSnapshot = streamSnapshot.data![index];

                                return FutureBuilder<MedicineModel?>(
                                  future: MedicineController().getMedicineByUid(documentSnapshot['productUID']),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData) {
                                      MedicineModel medicine = snapshot.data!;
                                      return Container(
                                        margin: const EdgeInsets.all(5),
                                        child: Card(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: ListTile(
                                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                  title: Text(
                                                    'Médicament: ${medicine.name}',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    'Commande: ${documentSnapshot['status']}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  leading: Image.network(medicine.thumbnail),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const Text('- Product not found');
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
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(),
                      child: StreamBuilder(
                        stream: _inprogressOrders,
                        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>>
                        streamSnapshot) {
                          if (!streamSnapshot.hasData) {
                            return const Text('Aucun commandes trouvé');
                          }
                          if (streamSnapshot.hasData) {
                            return ListView.separated(
                              itemCount: streamSnapshot.data!.length,
                              separatorBuilder: (context, index) => const Divider(),
                              itemBuilder: (context, index) {
                                final documentSnapshot = streamSnapshot.data![index];

                                return FutureBuilder<MedicineModel?>(
                                  future: MedicineController().getMedicineByUid(documentSnapshot['productUID']),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData) {
                                      MedicineModel medicine = snapshot.data!;
                                      return Container(
                                        margin: const EdgeInsets.all(5),
                                        child: Card(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: ListTile(
                                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                  title: Text(
                                                    'Médicament: ${medicine.name}',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    'Commande: ${documentSnapshot['status']}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  leading: Image.network(medicine.thumbnail),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const Text('- Product not found');
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
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(),
                      child: StreamBuilder(
                        stream: _deliveredOrders,
                        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>>
                        streamSnapshot) {
                          if (!streamSnapshot.hasData) {
                            return const Text('Aucun commandes trouvé');
                          }
                          if (streamSnapshot.hasData) {
                            return ListView.separated(
                              itemCount: streamSnapshot.data!.length,
                              separatorBuilder: (context, index) => const Divider(),
                              itemBuilder: (context, index) {
                                final documentSnapshot = streamSnapshot.data![index];

                                return FutureBuilder<MedicineModel?>(
                                  future: MedicineController().getMedicineByUid(documentSnapshot['productUID']),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData) {
                                      MedicineModel medicine = snapshot.data!;
                                      return Container(
                                        margin: const EdgeInsets.all(5),
                                        child: Card(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: ListTile(
                                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                  title: Text(
                                                    'Médicament: ${medicine.name}',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    'Commande: ${documentSnapshot['status']}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  leading: Image.network(medicine.thumbnail),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const Text('- Product not found');
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
            ),
          ],
        ),
      ),
    );
  }
}
