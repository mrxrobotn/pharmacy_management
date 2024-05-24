import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../controllers/fournisseur_controller.dart';
import '../../controllers/medicine_controller.dart';
import '../../controllers/notifications_api.dart';
import '../../controllers/orders_controller.dart';
import '../../controllers/user_controller.dart';
import '../../functions.dart';
import '../../models/medicine_model.dart';
import '../../models/stock_model.dart';

class FournisseurStocks extends StatefulWidget {
  const FournisseurStocks({super.key});

  @override
  State<FournisseurStocks> createState() => _FournisseurStocksState();
}

class _FournisseurStocksState extends State<FournisseurStocks> {
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
        _onholdOrders = FournisseurController().getStockOrders('en attente');
        _inprogressOrders = FournisseurController().getAcceptedOrders();
        _deliveredOrders = FournisseurController().getStockOrders('livrée');
      });
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const ListTile(
            title: Text(
              "Commandes Pharmaciens",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, color: kGrey),
            ),
          ),
        ),
        body: DefaultTabController(
          length: 3,
          child: Column(
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
                          builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> streamSnapshot) {
                            if (!streamSnapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            return ListView.separated(
                              itemCount: streamSnapshot.data!.length,
                              separatorBuilder: (context, index) => const Divider(),
                              itemBuilder: (context, index) {
                                final documentSnapshot = streamSnapshot.data![index];
                                return FutureBuilder<MedicineModel?>(
                                  future: MedicineController().getMedicineByUid(documentSnapshot['productUID']),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (!snapshot.hasData) {
                                      return const Text('Médicament non trouvé');
                                    }
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
                                                  'Qté: ${documentSnapshot['quantity']}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                onTap: (){
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => OrderDetailsWidget(orderNumber: documentSnapshot['number'])),
                                                  );
                                                },
                                                leading: Image.network(medicine.thumbnail),
                                                trailing: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () async {
                                                        String orderNumber = documentSnapshot['number'];
                                                        print('orderNumber $orderNumber');
                                                        Map<String, dynamic> updates = {
                                                          'deliveryUID': userUID,
                                                          'status': 'en cours',
                                                        };
                                                        FournisseurController().updateOrderByNumber(
                                                            orderNumber, updates);
                                                        OrderController().updateOrderByNumber(
                                                            orderNumber, updates);
                                                        String? token = await UserController().getTokenForUser(documentSnapshot['orderBy']);
                                                        sendNotificationMessage(
                                                            recipientToken: token!,
                                                            title: 'Commande N°: ${documentSnapshot['orderNumber']}',
                                                            body: 'Votre commande est maintenant en cours'
                                                        );
                                                      },
                                                      icon: const Icon(
                                                        Icons.check,
                                                        color: kGreen,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        String orderNumber = documentSnapshot['number'];
                                                        Map<String, dynamic> updates = {
                                                          'status': 'rejetée',
                                                        };
                                                        FournisseurController().updateOrderByNumber(
                                                            orderNumber, updates);
                                                      },
                                                      icon: const Icon(
                                                        Icons.close,
                                                        color: kRed,
                                                      ),
                                                    )
                                                  ],
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
                                      if (!snapshot.hasData) {
                                        return const Text('Aucun commandes trouvé');
                                      }
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
                                                    onTap: (){
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => OrderDetailsWidget(orderNumber: documentSnapshot['number'])),
                                                      );
                                                    },
                                                    leading: Image.network(medicine.thumbnail),
                                                    trailing: IconButton(
                                                      onPressed: () {
                                                        String orderNumber = documentSnapshot['number'];
                                                        print('orderNumber $orderNumber');
                                                        Map<String, dynamic> updates = {
                                                          'deliveryUID': userUID,
                                                          'status': 'livrée',
                                                        };
                                                        FournisseurController().updateOrderByNumber(
                                                            orderNumber, updates);
                                                      },
                                                      icon: const Icon(
                                                        Icons.check,
                                                        color: kGreen,
                                                      ),
                                                    ),
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
                                      if (!snapshot.hasData) {
                                        return const Text('Aucun commandes trouvé');
                                      }
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
                                                    onTap: (){
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => OrderDetailsWidget(orderNumber: documentSnapshot['number'])),
                                                      );
                                                    },
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

class OrderDetailsWidget extends StatefulWidget {
  final String orderNumber;

  const OrderDetailsWidget({super.key, required this.orderNumber});

  @override
  _OrderDetailsWidgetState createState() => _OrderDetailsWidgetState();
}

class _OrderDetailsWidgetState extends State<OrderDetailsWidget> {
  late Future<StockModel?> _orderFuture;

  @override
  void initState() {
    super.initState();
    _orderFuture = getOrderDetails();
  }

  Future<StockModel?> getOrderDetails() async {
    return FournisseurController().getStockOrderByNumber(widget.orderNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: FutureBuilder<StockModel?>(
        future: _orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            StockModel order = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(Icons.confirmation_number, 'Commande N°', order.number),
                      _buildDetailRow(Icons.info_outline, 'Status', order.status, color: _getStatusColor(order.status)),
                      _buildDetailRow(Icons.attach_money, 'Quantité', order.quantity),
                      _buildDetailRow(Icons.access_time, 'Date', order.orderTime.toDate().toString()),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('Order not found'),
            );
          }
        },
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
          ),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.green;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
