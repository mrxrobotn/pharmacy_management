import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_management/models/order_model.dart';

import '../../constants.dart';
import '../../controllers/medicine_controller.dart';
import '../../controllers/notifications_api.dart';
import '../../controllers/orders_controller.dart';
import '../../controllers/user_controller.dart';
import '../../functions.dart';
import '../../models/medicine_model.dart';

class FournisseurOrders extends StatefulWidget {
  const FournisseurOrders({super.key});

  @override
  State<FournisseurOrders> createState() => _FournisseurOrdersState();
}

class _FournisseurOrdersState extends State<FournisseurOrders> {


  Stream<List<OrderModel>> getWaitingOrders() {
    return orders.where('status', isEqualTo: 'en attente').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromFirestore(doc);
      }).toList();
    });
  }
  Stream<List<OrderModel>> getInProgressOrders() {
    return orders.where('status', isEqualTo: 'en cours').where('deliveryUID', isEqualTo: userUID).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromFirestore(doc);
      }).toList();
    });
  }
  Stream<List<OrderModel>> getDeliveredOrders() {
    return orders.where('status', isEqualTo: 'livrée').where('deliveryUID', isEqualTo: userUID).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromFirestore(doc);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ListTile(
          title: Text(
            "Commandes Utilisateurs",
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
                Tab(text: 'Livrée', icon: Icon(Icons.history)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  StreamBuilder<List<OrderModel>>(
                    stream: getWaitingOrders(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No orders found'));
                      } else {
                        List<OrderModel> orders = snapshot.data!;
                        return ListView.separated(
                          itemCount: orders.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            OrderModel order = orders[index];
                            return Container(
                              margin: const EdgeInsets.all(5),
                              child: Card(
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  title: Text('Commande #${order.number}'),
                                  subtitle: Text('Prix: \$${order.totalAmount}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          Map<String, dynamic> updates = {
                                            'deliveryUID': userUID,
                                            'status': 'en cours',
                                          };
                                          OrderController().updateOrderByNumber(
                                              order.number, updates);
                                          String? token = await UserController().getTokenForUser(order.orderBy);
                                          sendNotificationMessage(
                                              recipientToken: token!,
                                              title: 'Commande N°: ${order.number}',
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
                                          Map<String, dynamic> updates = {
                                            'status': 'rejetée',
                                          };
                                          OrderController().updateOrderByNumber(
                                              order.number, updates);
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: kRed,
                                        ),
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => OrderDetailsWidget(orderNumber: order.number)),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                  StreamBuilder<List<OrderModel>>(
                    stream: getInProgressOrders(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No orders found'));
                      } else {
                        List<OrderModel> orders = snapshot.data!;
                        return ListView.separated(
                          itemCount: orders.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            OrderModel order = orders[index];
                            return Container(
                              margin: const EdgeInsets.all(5),
                              child: Card(
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  title: Text('Commande #${order.number}'),
                                  subtitle: Text('Prix: \$${order.totalAmount}'),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      Map<String, dynamic> updates = {
                                        'status': 'livrée',
                                      };
                                      OrderController().updateOrderByNumber(
                                          order.number, updates);
                                      String? token = await UserController().getTokenForUser(order.orderBy);
                                      sendNotificationMessage(
                                          recipientToken: token!,
                                          title: 'Commande N°: ${order.number}',
                                          body: 'Votre commande est maintenant livrée'
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.check,
                                      color: kGreen,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => OrderDetailsWidget(orderNumber: order.number)),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                  StreamBuilder<List<OrderModel>>(
                    stream: getDeliveredOrders(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No orders found'));
                      } else {
                        List<OrderModel> orders = snapshot.data!;
                        return ListView.separated(
                          itemCount: orders.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            OrderModel order = orders[index];
                            return Container(
                              margin: const EdgeInsets.all(5),
                              child: Card(
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  title: Text('Commande #${order.number}'),
                                  subtitle: Text('Prix: \$${order.totalAmount}'),
                                  trailing: const Icon(Icons.arrow_forward),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => OrderDetailsWidget(orderNumber: order.number)),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
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
    return OrderController().getOrderByNumber(widget.orderNumber);
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
                      _buildDetailRow(Icons.payment, 'Paiement', order.paymentDetails),
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
        return Colors.orange;
      case 'en cours':
        return Colors.blue;
      case 'livrée':
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}