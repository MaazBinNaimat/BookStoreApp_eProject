import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package

class MyordersDisplayScreen extends StatefulWidget {
  final String userid;
  const MyordersDisplayScreen({super.key, required this.userid});

  @override
  State<MyordersDisplayScreen> createState() => _MyordersDisplayScreenState();
}

class _MyordersDisplayScreenState extends State<MyordersDisplayScreen> {
  // Fetch the orders for the user based on userid
  Stream<QuerySnapshot> getOrdersStream() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('userid', isEqualTo: widget.userid)
        .snapshots();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'rejected':
        return Colors.redAccent.withOpacity(0.8);
      case 'approved':
        return Colors.greenAccent.withOpacity(0.8);
      case 'delivered':
        return Colors.blue.withOpacity(0.8);
      case 'review submitted':
        return Colors.deepPurpleAccent.withOpacity(0.8);
      default: // pending
        return Colors.white;
    }
  }

  Widget getStatusWidget(String status, Map<String, dynamic> order) {
    switch (status) {
      case 'rejected':
        return const Text(
          'Rejected',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        );
      case 'approved':
        return const Text(
          'Approved',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        );
      case 'delivered':
        return ElevatedButton(
          onPressed: () => _showReviewModal(context, order),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.deepPurpleAccent,
            side: const BorderSide(color: Colors.deepPurpleAccent),
          ),
          child: const Text('Give Review'),
        );
      case 'review submitted':
        return const Text(
          'review submitted',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        );
      default: // pending
        return const Text(
          'Pending',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        );
    }
  }

  void _showReviewModal(BuildContext context, Map<String, dynamic> order) {
    String? rating;
    String? review;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Give Review',
            style: TextStyle(
              color: Colors.deepPurpleAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order ID: ${order['orderid']}'),
                const SizedBox(height: 8.0),
                Text('Product Name: ${order['productName']}'),
                const SizedBox(height: 16.0),
                const Text('Rating'),
                DropdownButtonFormField<int>(
                  items: [1, 2, 3, 4, 5]
                      .map((e) => DropdownMenuItem<int>(
                    value: e,
                    child: Text(e.toString()),
                  ))
                      .toList(),
                  onChanged: (value) {
                    rating = value.toString();
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text('Review'),
                TextField(
                  maxLines: 4,
                  onChanged: (value) => review = value,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // Format the current date and time
                final now = DateTime.now();
                final formattedDate = DateFormat('hh:mm:ss a dd-MM-yyyy').format(now);

                // Submit the review to the Firestore 'reviews' collection
                if (rating != null && review != null) {
                  // Add the review to the 'reviews' collection
                  await FirebaseFirestore.instance.collection('reviews').add({
                    'reviewid': FirebaseFirestore.instance.collection('reviews').doc().id,
                    'orderid': order['orderid'],
                    'rating': rating,
                    'review': review,
                    'productid': order['productid'],
                    'userid': widget.userid,
                    'date': formattedDate, // Add the formatted date and time
                  });

                  // Update the order status to 'review submitted'
                  await FirebaseFirestore.instance.collection('orders').doc(order['orderid']).update({
                    'orderstatus': 'review submitted',
                  });

                  Navigator.of(context).pop(); // Close the modal

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Review submitted successfully'),
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
              ),
              child: const Text('Submit Review', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.deepPurpleAccent,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: const Text(
          "Manage Orders",
          style: TextStyle(
            color: Colors.deepPurpleAccent,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getOrdersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          List<QueryDocumentSnapshot> orders = snapshot.data!.docs;

          return SingleChildScrollView(
            child: Column(
              children: orders.map((orderDoc) {
                Map<String, dynamic> orderData = orderDoc.data() as Map<String, dynamic>;

                // Fetch product details based on productid
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('products')
                      .doc(orderData['productid'])
                      .get(),
                  builder: (context, productSnapshot) {
                    if (productSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!productSnapshot.hasData || !productSnapshot.data!.exists) {
                      return const Text('Product not found.');
                    }

                    var productData = productSnapshot.data!.data() as Map<String, dynamic>;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: getStatusColor(orderData['orderstatus']),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.deepPurpleAccent,
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              productData['productimage']!,
                              height: 60.0,
                              width: 60.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productData['productname']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text('Quantity: ${orderData['orderquantity']}'),
                                const SizedBox(height: 4.0),
                                Text('Order ID: ${orderData['orderid']}'),
                                const SizedBox(height: 4.0),
                              ],
                            ),
                          ),
                          getStatusWidget(orderData['orderstatus'], orderData),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
