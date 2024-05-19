import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_management/controllers/medicine_controller.dart';
import 'package:pharmacy_management/views/client/product_grid_item.dart';
import 'package:provider/provider.dart';
import '../../controllers/cart_provider.dart';
import 'package:badges/badges.dart' as badges;

import '../../functions.dart';
import '../../models/medicine_model.dart';
import 'grid_item_details.dart';
import 'shop_cart_details.dart';

class ClientShopPage extends StatefulWidget {
  const ClientShopPage({super.key});

  @override
  State<ClientShopPage> createState() => _ClientShopPageState();
}

class _ClientShopPageState extends State<ClientShopPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        title: 'Boutique',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final TextEditingController nameController = TextEditingController();
  bool _searching = false;
  late Stream<QuerySnapshot> _medicinesStream;

  @override
  void initState() {
    super.initState();
    _medicinesStream = medicines.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: const Text(
          "Boutique",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          Row(
            children: [
              Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  return badges.Badge(
                    badgeColor: Colors.red,
                    position: badges.BadgePosition.bottomEnd(bottom: 1, end: 1),
                    badgeContent: Text(
                      cartProvider.cartCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.local_mall),
                      iconSize: 25,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext ctx) =>
                                const CartDetails()));
                      },
                    ),
                  );
                },
              ),
              const SizedBox(
                width: 5,
              )
            ],
          )
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Focus(
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Rechercher par nom",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searching = value.isNotEmpty;
                            _medicinesStream = _searching
                                ? medicines
                                .where('name', isGreaterThanOrEqualTo: value)
                                .snapshots()
                                : medicines.snapshots();
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _medicinesStream,
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text('An error occurred!'),
                          );
                        } else if (snapshot.hasData) {
                          if (snapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Text("Aucun produit trouvé"),
                            );
                          } else {
                            List<MedicineModel> data = snapshot.data!.docs.map((doc) => MedicineModel.fromSnapshot(doc)).toList();

                            return GridView.builder(
                              padding: const EdgeInsets.all(4.0),
                              itemCount: data.length,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 3 / 3.5,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                              itemBuilder: (context, index) {
                                var product = data[index];
                                return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) => GridItemDetails(medicine: product),
                                        ),
                                      );
                                    },
                                    child: ProductGridItem(medicine: product));
                              },
                            );
                          }
                        }
                        return const Text("Aucun produit trouvé");
                      },
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
