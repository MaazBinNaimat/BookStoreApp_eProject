import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class MyCartScreen extends StatefulWidget {
  final String userid;
  const MyCartScreen({super.key, required this.userid});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  void _fetchCartItems() async {
    try {
      QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .where('userid', isEqualTo: widget.userid)
          .get();

      List<Map<String, dynamic>> fetchedItems = [];
      for (var doc in cartSnapshot.docs) {
        var cartItem = doc.data() as Map<String, dynamic>;

        DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .doc(cartItem['productid'])
            .get();

        var productData = productSnapshot.data() as Map<String, dynamic>;
        fetchedItems.add({
          'cartid': doc.id,
          'productid': cartItem['productid'],
          'quantity': int.parse(cartItem['cartquantity']),
          'productname': productData['productname'],
          'productprice': int.parse(productData['productprice']),
          'productimage': productData['productimage'],
        });
      }

      setState(() {
        cartItems = fetchedItems;
      });
    } catch (e) {
      print('Error fetching cart items: $e');
    }
  }

  void updateCartQuantity(String cartId, int newQuantity) async {
    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(cartId)
          .update({'cartquantity': newQuantity.toString()});
      _fetchCartItems();
    } catch (e) {
      print('Error updating cart quantity: $e');
    }
  }

  void deleteCartItem(String cartId) async {
    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(cartId)
          .delete();
      _fetchCartItems();
    } catch (e) {
      print('Error deleting cart item: $e');
    }
  }

  // Place orders and insert them into the 'orders' collection
  void _placeOrders() async {
    try {
      // Get the current date and time in the desired format
      String formattedDate = DateFormat('hh:mm:ss a dd-MM-yyyy').format(DateTime.now());

      for (var item in cartItems) {
        DocumentReference orderRef = FirebaseFirestore.instance.collection('orders').doc();

        await orderRef.set({
          'orderid': orderRef.id,
          'userid': widget.userid,
          'productid': item['productid'],
          'orderquantity': item['quantity'].toString(),
          'orderstatus': 'pending',
          'date': formattedDate, // Add the formatted date field
        });
      }

      for (var item in cartItems) {
        await FirebaseFirestore.instance
            .collection('cart')
            .doc(item['cartid'])
            .delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Orders placed successfully!"),
          backgroundColor: Colors.orange,
        ),
      );

      _fetchCartItems();
    } catch (e) {
      print('Error placing orders: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Failed to place orders!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCheckoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Place Order'),
          content: const Text('Do you want to place your order?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _placeOrders();
              },
              child: const Text('Place Order'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = cartItems.fold<int>(0, (sum, item) {
      int price = item['productprice'];
      int quantity = item['quantity'] is int ? item['quantity'] : int.parse(item['quantity'].toString());
      return sum + (price * quantity);
    });

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
        title: Text(
          "My Cart(${cartItems.length})",
          style: const TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: cartItems.isEmpty
          ? const Center(
        child: Text(
          'Your cart is empty!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  var item = cartItems[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      height: 100,
                      color: Colors.grey.shade200,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.network(
                              item['productimage'],
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item['productname'],
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (item['quantity'] > 1) {
                                          updateCartQuantity(item['cartid'], item['quantity'] - 1);
                                        }
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurpleAccent,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.remove, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        '${item['quantity']}',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        updateCartQuantity(item['cartid'], item['quantity'] + 1);
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurpleAccent,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.add, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      'Rs ${item['productprice'] * item['quantity']}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              deleteCartItem(item['cartid']);
                            },
                            child: const Icon(Icons.delete, color: Colors.red, size: 30),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: Rs $totalPrice',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showCheckoutDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent, // Background color
                  ),
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
