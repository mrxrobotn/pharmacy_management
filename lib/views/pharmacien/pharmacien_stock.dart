import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_management/views/pharmacien/pharmacian_add_stock.dart';
import 'package:pharmacy_management/views/pharmacien/pharmacien_medicine_details.dart';
import '../../constants.dart';
import '../../functions.dart';

class PharmacienStock extends StatefulWidget {
  const PharmacienStock({super.key});

  @override
  State<PharmacienStock> createState() => _PharmacienStockState();
}

class _PharmacienStockState extends State<PharmacienStock> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  late Stream<QuerySnapshot> _medicinesStream;
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _medicinesStream = medicines.where('ownerUID', isEqualTo: userUID).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              color: kYellow,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
            ),
            child: ListTile(
              title: const Text(
                "Stock",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              subtitle: const Text(
                "Tous les médicaments",
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddMedecinesPage()),
                  );
                },
                icon: const Icon(Icons.add),
              ),
              leading: const Icon(Icons.medication_rounded),
            ),
          ),
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
                  if (value.isNotEmpty) {
                    setState(() {
                      _searching = true;
                      _medicinesStream = medicines
                          .where('ownerUID', isEqualTo: userUID)
                          .where('name', isGreaterThanOrEqualTo: value)
                          .snapshots();
                    });
                  } else {
                    setState(() {
                      _searching = false;
                      _medicinesStream = medicines.where('ownerUID', isEqualTo: userUID).snapshots();
                    });
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _medicinesStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 1.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(4),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PharmacienMedicineDetails(
                                documentSnapshot: documentSnapshot,
                                uid: documentSnapshot['uid'],
                                name: documentSnapshot['name'],
                                description: documentSnapshot['description'],
                                price: documentSnapshot['price'].toString(),
                                quantity: documentSnapshot['quantity'].toString(),
                                thumbnail: documentSnapshot['thumbnail'],
                                expiration: documentSnapshot['expiration'],
                              ),
                            ));
                          },
                          child: Container(
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 8,
                                    top: 8,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Qté: ${documentSnapshot['quantity']}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEF7532)),
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
                                      image: NetworkImage(documentSnapshot['thumbnail']),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Center(
                                  child: Text(
                                    'Nom: ${documentSnapshot['name']}',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Color(0xFF575E67),
                                        fontFamily: 'Varela',
                                        fontSize: 14),
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
                                          'Prix: ${documentSnapshot['price']}',
                                          style: const TextStyle(
                                              color: Color(0xFFCC8053),
                                              fontFamily: 'Varela',
                                              fontSize: 16),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            )
            ,
          ),
        ],
      ),
    );
  }
}
