import 'package:flutter/material.dart';
import 'package:pharmacy_management/controllers/notifications_api.dart';
import 'package:pharmacy_management/controllers/user_controller.dart';
import 'package:pharmacy_management/views/pharmacien/pharmacien_stock_orders.dart';
import '../../constants.dart';
import '../../controllers/medicine_controller.dart';
import '../../controllers/orders_controller.dart';
import '../../functions.dart';
import '../../models/medicine_model.dart';
import '../../models/order_model.dart';

class PharmacienOrders extends StatefulWidget {
  const PharmacienOrders({super.key});

  @override
  State<PharmacienOrders> createState() => _PharmacienOrdersState();
}

class _PharmacienOrdersState extends State<PharmacienOrders> {
  late Stream<List<Map<String, dynamic>>> _ordersOnHoldStream;
  late Stream<List<Map<String, dynamic>>> _ordersInProgressStreams;
  late Stream<List<Map<String, dynamic>>> _ordersDeliveredStreams;

  @override
  void initState() {
    super.initState();
    _ordersOnHoldStream = const Stream.empty();
    _ordersDeliveredStreams = const Stream.empty();
    _ordersInProgressStreams = const Stream.empty();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      setState(() {
        _ordersOnHoldStream = OrderController().findDeliveredProductStreams(userUID!, 'en attente');
        _ordersInProgressStreams = OrderController().findDeliveredProductStreams(userUID!, 'en cours');
        _ordersDeliveredStreams = OrderController().findDeliveredProductStreams(userUID!, 'livrée');
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
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Column(
                        children: [
                          Text(
                            "Commandes",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: kWhite),
                          ),
                          Text(
                            "Tous les commandes",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kWhite),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          const Text('Mien',textAlign: TextAlign.center,
                            style: TextStyle(color: kWhite),),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => const StockOrders()),
                                );
                              },
                              icon: const Icon(Icons.arrow_forward_ios_sharp), color: kWhite,),
                        ],
                      )
                    ]
                  )
              ),
              const TabBar(
                tabs: [
                  Tab(text: 'En attente', icon: Icon(Icons.timelapse)),
                  Tab(text: 'En cours', icon: Icon(Icons.incomplete_circle)),
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
                          stream: _ordersOnHoldStream,
                          builder: (context,
                              AsyncSnapshot<List<Map<String, dynamic>>>
                              streamSnapshot) {
                            if (streamSnapshot.hasData) {
                              return ListView.separated(
                                itemCount: streamSnapshot.data!.length,
                                separatorBuilder: (context, index) => const Divider(),
                                itemBuilder: (context, index) {
                                  final orderData = streamSnapshot.data![index];
                                  return Container(
                                    margin: const EdgeInsets.all(5),
                                    child: Card(
                                      child: ListTile(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                            return OrderDetailsWidget(orderNumber: orderData['orderNumber'],);
                                          }));
                                        },
                                        title:
                                        Text('Numéro: ${orderData['orderNumber']}'),
                                        subtitle: Text(
                                            'Nom du produit: ${orderData['productName']}'),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                String orderNumber =
                                                orderData['orderNumber'];
                                                Map<String, dynamic> updates = {
                                                  'status': 'en cours',
                                                  'products': orderData['products'],
                                                  'productsOwners':
                                                  orderData['productsOwners'],
                                                  'totalAmount':
                                                  orderData['totalAmount'],
                                                };
                                                OrderController().updateOrderByNumber(
                                                    orderNumber, updates);
                                                String? token = await UserController().getTokenForUser(orderData['orderBy']);
                                                sendNotificationMessage(
                                                    recipientToken: token!,
                                                    title: 'Commande N°: ${orderData['orderNumber']}',
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
                                                String orderNumber =
                                                orderData['orderNumber'];
                                                Map<String, dynamic> updates = {
                                                  'status': 'annulé',
                                                  'products': orderData['products'],
                                                  'productsOwners':
                                                  orderData['productsOwners'],
                                                  'totalAmount':
                                                  orderData['totalAmount'],
                                                };
                                                OrderController().updateOrderByNumber(
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
                                  );
                                },
                              );
                            } else if (streamSnapshot.hasError) {
                              return Center(
                                child: Text('Error: ${streamSnapshot.error}'),
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
                          stream: _ordersInProgressStreams,
                          builder: (context,
                              AsyncSnapshot<List<Map<String, dynamic>>>
                              streamSnapshot) {
                            if (streamSnapshot.hasData) {
                              return ListView.separated(
                                itemCount: streamSnapshot.data!.length,
                                separatorBuilder: (context, index) => const Divider(),
                                itemBuilder: (context, index) {
                                  final orderData = streamSnapshot.data![index];

                                  return Container(
                                    margin: const EdgeInsets.all(5),
                                    child: Card(
                                      child: ListTile(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                            return OrderDetailsWidget(orderNumber: orderData['orderNumber'],);
                                          }));
                                        },
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                String orderNumber =
                                                orderData['orderNumber'];
                                                Map<String, dynamic> updates = {
                                                  'status': 'livrée',
                                                  'products': orderData['products'],
                                                  'productsOwners': orderData['productsOwners'],
                                                  'totalAmount': orderData['totalAmount'],
                                                };
                                                OrderController().updateOrderByNumber(
                                                    orderNumber, updates);
                                              },
                                              icon: const Icon(
                                                Icons.check,
                                                color: kGreen,
                                              ),
                                            ),
                                          ],
                                        ),
                                        title:
                                        Text('Numéro: ${orderData['orderNumber']}'),
                                        subtitle: Text(
                                            'Nom du produit: ${orderData['productName']}'
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else if (streamSnapshot.hasError) {
                              return Center(
                                child: Text('Error: ${streamSnapshot.error}'),
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
                          stream: _ordersDeliveredStreams,
                          builder: (context,
                              AsyncSnapshot<List<Map<String, dynamic>>>
                              streamSnapshot) {
                            if (streamSnapshot.hasData) {
                              return ListView.separated(
                                itemCount: streamSnapshot.data!.length,
                                separatorBuilder: (context, index) => const Divider(),
                                itemBuilder: (context, index) {
                                  final orderData = streamSnapshot.data![index];

                                  return Container(
                                    margin: const EdgeInsets.all(5),
                                    child: Card(
                                      child: ListTile(
                                        trailing: const Icon(Icons.arrow_forward_ios_sharp),
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                            return OrderDetailsWidget(orderNumber: orderData['orderNumber'],);
                                          }));
                                        },
                                        title:
                                        Text('Numéro: ${orderData['orderNumber']}'),
                                        subtitle: Text(
                                            'Nom du produit: ${orderData['productName']}'
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else if (streamSnapshot.hasError) {
                              return Center(
                                child: Text('Error: ${streamSnapshot.error}'),
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
                )
              )
            ],
          ),
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
        title: const Text('Détails du commande'),
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
                      _buildDetailRow(Icons.confirmation_number,
                          'Numéro du cammande', order.number),
                      _buildDetailRow(
                          Icons.info_outline, 'Status', order.status,
                          color: _getStatusColor(order.status)),
                      _buildDetailRow(Icons.attach_money, 'Montant total',
                          order.totalAmount),
                      _buildDetailRow(Icons.access_time, 'Temps de commande',
                          order.orderTime.toDate().toString()),
                      _buildDetailRow(Icons.payment, 'Détails de paiement',
                          order.paymentDetails),
                      const SizedBox(height: 10),
                      const Text(
                        'Produits:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: order.products.map((product) {
                          return FutureBuilder<MedicineModel?>(
                            future:
                                MedicineController().getMedicineByUid(product),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
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

  Widget _buildDetailRow(IconData icon, String label, String value,
      {Color? color}) {
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
