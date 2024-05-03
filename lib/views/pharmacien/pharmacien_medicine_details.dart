import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmacy_management/constants.dart';
import 'package:pharmacy_management/controllers/medicine_controller.dart';
import 'package:pharmacy_management/functions.dart';

class PharmacienMedicineDetails extends StatefulWidget {
  final String uid;
  final String name;
  final String description;
  final String price;
  final String quantity;
  final String thumbnail;
  final DocumentSnapshot documentSnapshot;

  PharmacienMedicineDetails({
    Key? key,
    required this.uid,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.documentSnapshot,
    required this.thumbnail,
  }) : super(key: key);

  @override
  _PharmacienMedicineDetailsState createState() => _PharmacienMedicineDetailsState();
}

class _PharmacienMedicineDetailsState extends State<PharmacienMedicineDetails> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
    descriptionController.text = widget.description;
    priceController.text = widget.price;
    quantityController.text = widget.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF545D68),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Details',
          style: TextStyle(
            fontFamily: 'Varela',
            fontSize: 24.0,
            color: Color(0xFF545D68),
          ),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16.0),
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'Plus des détails:',
              style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF17532),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Hero(
              tag: widget.thumbnail,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.thumbnail),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Center(
            child: Text(
              'Prix: ${widget.price}',
              style: const TextStyle(
                fontFamily: 'Varela',
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF17532),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Center(
            child: Text(
              widget.name,
              style: const TextStyle(
                color: Color(0xFF575E67),
                fontFamily: 'Varela',
                fontSize: 24.0,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 52.0,
              child: Text(
                widget.description,
                maxLines: 4,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 16.0,
                  color: Color(0xFFB4B8B9),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Column(
            children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 100.0,
                  height: 52.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    color: const Color(0xFFF17532),
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () async {
                        await confirmUpdate(context);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit,
                            size: 32,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Modifier',
                            style: TextStyle(
                              fontFamily: 'Varela',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: kDefaultPadding),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 100.0,
                  height: 52.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    color: const Color(0xFFF17532),
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () async {
                        await confirmDelete(context);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            size: 32,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Supprimer',
                            style: TextStyle(
                              fontFamily: 'Varela',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> confirmUpdate(BuildContext context) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Modifier'),
        content: const Text('Voulez-vous vraiment modifier?'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await update(context);
            },
            child: const Text('Oui'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Non'),
          ),
        ],
      ),
    );
  }

  Future<void> confirmDelete(BuildContext context) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Supprimer'),
        content: const Text('Voulez-vous vraiment supprimer?'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await MedicineController().deleteMedicine(widget.uid);
              Navigator.of(context).pop();
            },
            child: const Text('Oui'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Non'),
          ),
        ],
      ),
    );
  }

  Future<void> update(BuildContext context) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Modifier les détails'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                keyboardType: TextInputType.name,
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Prix'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantité'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final String name = nameController.text;
              final int price = int.parse(priceController.text);
              final int quantity = int.parse(quantityController.text);
              await medicines.doc(widget.documentSnapshot.id).update({
                'name': name,
                'price': price,
                'quantity': quantity,
              });

              setState(() {

              });

              Navigator.of(context).pop();
            },
            child: const Text('Modifier'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
