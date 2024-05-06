import 'package:flutter/material.dart';
import 'package:pharmacy_management/models/medicine_model.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../controllers/cart_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ProductGridItem extends StatefulWidget {
  final MedicineModel medicine;
  const ProductGridItem({super.key, required this.medicine});

  @override
  State<ProductGridItem> createState() => _ProductGridItemState();
}

class _ProductGridItemState extends State<ProductGridItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3.0,
            blurRadius: 5.0,
          )
        ],
        color: Colors.white,
      ),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const Padding(
            padding: EdgeInsets.only(
              right: 8,
              top: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'En stock',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEF7532)),
                )
              ],
            ),
          ),
          Container(
            height: 92,
            width: 92,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(widget.medicine.thumbnail),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              widget.medicine.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Color(0xFF575E67),
                  fontFamily: 'Varela',
                  fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: const Color(0xFFEBEBEB),
              height: 1.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Prix: ${widget.medicine.price} TND',
                    style: const TextStyle(
                        color: Color(0xFFCC8053),
                        fontFamily: 'Varela',
                        fontSize: 16),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    color: kPrimaryColor,
                    iconSize: 25,
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(widget.medicine, 1, "");
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}