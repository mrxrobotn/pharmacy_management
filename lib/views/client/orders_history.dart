import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_management/controllers/medicine_controller.dart';
import 'package:pharmacy_management/controllers/user_controller.dart';

import '../../constants.dart';
import '../../controllers/orders_controller.dart';
import '../../functions.dart';
import '../../models/medicine_model.dart';
import '../../models/order_model.dart';
import '../../models/user_model.dart';

class ClientOrdersHistory extends StatefulWidget {
  const ClientOrdersHistory({Key? key}) : super(key: key);

  @override
  State<ClientOrdersHistory> createState() => _ClientOrdersHistoryState();
}

class _ClientOrdersHistoryState extends State<ClientOrdersHistory> {

  late Stream<QuerySnapshot> _onholdOrders;
  late Stream<QuerySnapshot> _inprogressOrders;
  late Stream<QuerySnapshot> _deliveredOrders;

  @override
  void initState() {
    super.initState();
    // Assuming 'orders' is a collection reference
    _onholdOrders = orders.where('orderBy', isEqualTo: userUID).where('status', isEqualTo: 'en attente').snapshots();
    _inprogressOrders = orders.where('orderBy', isEqualTo: userUID).where('status', isEqualTo: 'en cours').snapshots();
    _deliveredOrders = orders.where('orderBy', isEqualTo: userUID).where('status', isEqualTo: 'livré').snapshots();
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
                        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            return ListView.separated(
                              itemCount: streamSnapshot.data!.docs.length,
                              separatorBuilder: (context, index) => const Divider(),
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];

                                return Container(
                                  margin: const EdgeInsets.all(5),
                                  child: Card(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ListTile(
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            title: Text(
                                              'Numéro: ${documentSnapshot['number']}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            subtitle: Text(
                                              'Status: ${documentSnapshot['status']}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            trailing: IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => OrderDetailsWidget(orderNumber: documentSnapshot['number'])),
                                                );
                                              },
                                              icon: const Icon(Icons.arrow_forward),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            return ListView.separated(
                              itemCount: streamSnapshot.data!.docs.length,
                              separatorBuilder: (context, index) => const Divider(),
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];

                                return Container(
                                  margin: const EdgeInsets.all(5),
                                  child: Card(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ListTile(
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            title: Text(
                                              'Numéro: ${documentSnapshot['number']}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            subtitle: Text(
                                              'Status: ${documentSnapshot['status']}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            trailing: IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => OrderDetailsWidget(orderNumber: documentSnapshot['number'])),
                                                );
                                              },
                                              icon: const Icon(Icons.arrow_forward),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            return ListView.separated(
                              itemCount: streamSnapshot.data!.docs.length,
                              separatorBuilder: (context, index) => const Divider(),
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];

                                return Container(
                                  margin: const EdgeInsets.all(5),
                                  child: Card(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ListTile(
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            title: Text(
                                              'Numéro: ${documentSnapshot['number']}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            subtitle: Text(
                                              'Status: ${documentSnapshot['status']}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            trailing: IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => OrderDetailsWidget(orderNumber: documentSnapshot['number'])),
                                                );
                                              },
                                              icon: const Icon(Icons.arrow_forward),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
  late Future<OrderModel?> _orderFuture;

  @override
  void initState() {
    super.initState();
    _orderFuture = getOrderDetails();
  }

  Future<OrderModel?> getOrderDetails() async {
    OrderController orderController = OrderController();
    return orderController.getOrderByNumber(widget.orderNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: FutureBuilder<OrderModel?>(
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
            OrderModel order = snapshot.data!;
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
                      _buildDetailRow(Icons.attach_money, 'Prix Total', order.totalAmount),
                      _buildDetailRow(Icons.access_time, 'Date', order.orderTime.toDate().toString()),
                      _buildDetailRow(Icons.payment, 'Methode de Paiement', order.paymentDetails),
                      const SizedBox(height: 10),
                      const Text(
                        'Products:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: order.products.map((product) {
                          return FutureBuilder<MedicineModel?>(
                            future: MedicineController().getMedicineByUid(product),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (snapshot.hasData) {
                                MedicineModel medicine = snapshot.data!;
                                return Text(
                                  '- ${medicine.name}',
                                  style: const TextStyle(fontSize: 16),
                                );
                              } else {
                                return const Text('- Product not found');
                              }
                            },
                          );
                        }).toList(),
                      ),
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
      case 'en attente':
        return kYellow;
      case 'en cours':
        return kBlue;
      case 'livrée':
        return kGreen;
      default:
        return Colors.black;
    }
  }
}
