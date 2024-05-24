import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_management/controllers/medicine_controller.dart';
import 'package:pharmacy_management/controllers/orders_controller.dart';
import 'package:pharmacy_management/controllers/user_controller.dart';
import 'package:pharmacy_management/models/order_model.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../../controllers/cart_provider.dart';
import '../../functions.dart';
import '../../models/cart_item_model.dart';
import 'cart_list_item.dart';

class CartDetails extends StatefulWidget {
  const CartDetails({super.key});

  @override
  State<CartDetails> createState() => _CartDetailsState();
}

class _CartDetailsState extends State<CartDetails> {
  bool useDiscount = false;
  TextEditingController couponController = TextEditingController();


  bool _validateCoupon(String value) {
    if (value.isEmpty) {
      return false;
    }
    double? points = double.tryParse(value);
    return points != null && points <= 1000 && points >= 0;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 500,
                padding: const EdgeInsets.all(10),
                color: Theme.of(context).colorScheme.primary,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios_new_outlined,
                              color: Colors.white,
                            ),
                          ),
                          const Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Panier",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                          Consumer<CartProvider>(
                            builder: (context, cartProvider, child) {
                              return badges.Badge(
                                position: badges.BadgePosition.bottomEnd(
                                    bottom: 1, end: 1),
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
                                  onPressed: () {},
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 800,
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 80, top: 20),
                margin: const EdgeInsets.only(top: 70),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  children: [
                    Expanded(
                      child: Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          final List<CartItem> cartItems =
                              cartProvider.cartItems;

                          if (cartItems.isEmpty) {
                            return Center(
                              child: Text(
                                'Votre panier est vide.',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final cartItem = cartItems[index];
                              return Dismissible(
                                key: Key(cartItem.medicine.uid
                                    .toString()), // Use a unique key for each item
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  Provider.of<CartProvider>(context,
                                      listen: false)
                                      .removeCartItem(index);
                                },
                                child: GestureDetector(
                                    onTap: () {},
                                    child: CartListItem(
                                      cartItem: cartItem,
                                      index: index,
                                    )),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Consumer<CartProvider>(
                      builder: (context, cartProvider, child) {
                        return Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Container()),
                                  ElevatedButton(
                                    onPressed: () {
                                      Provider.of<CartProvider>(context,
                                          listen: false)
                                          .clearCart();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(30),
                                        )),
                                    child: const Text(
                                      "Vider le panier",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Prix total:',
                                    style:
                                    Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Expanded(child: Container()),
                                  Text(
                                    '${cartProvider.totalPrice.toStringAsFixed(2)} TND',
                                    style:
                                    Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Points de fidelité:',
                                    style:
                                    Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Expanded(child: Container()),
                                  SizedBox(
                                    height: 60,
                                    width: 200,
                                    child: TextFormField(
                                      controller: couponController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'Entrer points (0 - 1000)',
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          useDiscount = _validateCoupon(value);
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),

                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    String number = Random().nextInt(4294967296).toString();
                                    List<String> products = [];
                                    List<String> productsOwners = [];
                                    for (var item in cartProvider.cartItems) {
                                      products.add(item.medicine.uid);
                                      productsOwners.add(item.medicine.ownerUID);
                                      int newQuantity = item.medicine.quantity - 1;
                                      MedicineController().updateQuantityByName(item.medicine.name, newQuantity);
                                    }
                                    if (useDiscount == true) {
                                      UserController().updateUserCoupon(userUID!, int.parse(couponController.text.toString()), false);
                                      OrderModel order = OrderModel(
                                        number: number,
                                        orderBy: userUID!,
                                        status: '',
                                        totalAmount: (cartProvider.totalPrice - (double.parse(couponController.text) * 0.01)).toString(),
                                        paymentDetails: "Paiement à la livraison",
                                        orderTime: Timestamp.now(),
                                        products: products,
                                        productsOwners: productsOwners,
                                      );
                                      OrderController().addOrder(order);
                                      users.doc(userUID).collection('orders').add({
                                        "orderNumber": number
                                      });

                                    } else {
                                      OrderModel order = OrderModel(
                                        number: number,
                                        orderBy: userUID!,
                                        status: '',
                                        totalAmount: cartProvider.totalPrice.toStringAsFixed(2),
                                        paymentDetails: "Paiement à la livraison",
                                        orderTime: Timestamp.now(),
                                        products: products,
                                        productsOwners: productsOwners,
                                      );
                                      OrderController().addOrder(order);
                                      users.doc(userUID).collection('orders').add({
                                        "orderNumber": number
                                      });
                                      UserController().updateUserCoupon(userUID!, 100, true);
                                    }

                                    Provider.of<CartProvider>(context,
                                        listen: false)
                                        .clearCart();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                    elevation: 10,
                                  ),
                                  child: const Text('Passer la commande',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}