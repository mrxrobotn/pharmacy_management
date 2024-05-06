import 'package:flutter/material.dart';
import 'package:pharmacy_management/controllers/medicine_controller.dart';
import 'package:pharmacy_management/views/client/product_grid_item.dart';
import 'package:provider/provider.dart';
import '../../controllers/cart_provider.dart';
import 'package:badges/badges.dart' as badges;

import '../../models/medicine_model.dart';
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
                  const Text(
                    "Tous les médicamentsa",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: FutureBuilder<List<MedicineModel>>(
                      future: MedicineController().getAllMedicines(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.connectionState ==
                            ConnectionState.none) {
                          return const Center(
                            child: Text('An error occurred!'),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          if (snapshot.hasData) {
                            if (snapshot.error != null) {
                              return const Center(
                                child: Text('An error occurred!'),
                              );
                            } else {
                              List<MedicineModel> data = snapshot.data!;

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
                                      onTap: () {},
                                      child: ProductGridItem(medicine: product));
                                },
                              );
                            }
                          } else {
                            return const Center(child: CircularProgressIndicator());
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