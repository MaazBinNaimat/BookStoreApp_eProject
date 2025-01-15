import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageOrdersScreen extends StatefulWidget {
  const ManageOrdersScreen({super.key});

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      default:
        return Colors.white;
    }
  }

  Widget getStatusWidget(String status, String orderId) {
    switch (status) {
      case 'rejected':
        return const Text(
          'rej-td',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        );
      case 'approved':
        return IconButton(
          icon: const Icon(Icons.thumb_up, color: Colors.white),
          onPressed: () => _updateOrderStatus(orderId, 'delivered'),
        );
      case 'delivered':
        return const Text(
          'delv-rd',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        );
      case 'review submitted':
        return const Text(
          'all done',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        );
      default: // pending
        return Row(
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () => _updateOrderStatus(orderId, 'approved'),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => _updateOrderStatus(orderId, 'rejected'),
            ),
          ],
        );
    }
  }

  Future<void> _updateOrderStatus(String orderId, String status) async {
    await _firestore.collection('orders').doc(orderId).update({'orderstatus': status});
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
        stream: _firestore.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!.docs;

          return SingleChildScrollView(
            child: Column(
              children: orders.map((orderDoc) {
                final orderData = orderDoc.data() as Map<String, dynamic>;
                final orderId = orderData['orderid'];
                final orderStatus = orderData['orderstatus'];
                final orderQuantity = orderData['orderquantity'];
                final productId = orderData['productid'];
                final userId = orderData['userid'];
                final orderDate = orderData['date'];

                return FutureBuilder<DocumentSnapshot>(
                  future: _firestore.collection('users').doc(userId).get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!userSnapshot.hasData) {
                      return const Center(child: Text('User not found.'));
                    }

                    final userData = userSnapshot.data!.data() as Map<String, dynamic>;

                    return FutureBuilder<DocumentSnapshot>(
                      future: _firestore.collection('products').doc(productId).get(),
                      builder: (context, productSnapshot) {
                        if (productSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!productSnapshot.hasData) {
                          return const Center(child: Text('Product not found.'));
                        }

                        final productData = productSnapshot.data!.data() as Map<String, dynamic>;

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: getStatusColor(orderStatus),
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
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Product image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  productData['productimage'],
                                  height: 60.0,
                                  width: 60.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              // Column for product and user details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productData['productname'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text('Quantity: $orderQuantity'),
                                    const SizedBox(height: 4.0),
                                    Text('Order ID: $orderId'),
                                    const SizedBox(height: 4.0),
                                    Text('by: ${userData['username']}'),
                                    const SizedBox(height: 4.0),
                                    Text(userData['useremail']),
                                    const SizedBox(height: 4.0),
                                    Text(orderDate),
                                  ],
                                ),
                              ),
                              // Status or action icons
                              getStatusWidget(orderStatus, orderId),
                            ],
                          ),
                        );
                      },
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
