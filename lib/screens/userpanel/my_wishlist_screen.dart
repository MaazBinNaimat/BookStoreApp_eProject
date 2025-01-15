import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyWishlistScreen extends StatefulWidget {
  final String userid;
  const MyWishlistScreen({super.key, required this.userid});

  @override
  State<MyWishlistScreen> createState() => _MyWishlistScreenState();
}

class _MyWishlistScreenState extends State<MyWishlistScreen> {
  // Function to delete an item from the wishlist
  Future<void> deleteWishlistItem(String wishlistId) async {
    try {
      await FirebaseFirestore.instance
          .collection('wishlist')
          .doc(wishlistId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item removed from wishlist')),
      );
    } catch (e) {
      print('Error deleting wishlist item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to remove item')),
      );
    }
  }

  // Function to add item to cart
  Future<void> addToCart(String productId, String wishlistId) async {
    try {
      // Check if item is already in the cart
      var cartSnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .where('userid', isEqualTo: widget.userid)
          .where('productid', isEqualTo: productId)
          .get();

      if (cartSnapshot.docs.isEmpty) {
        // Add to cart if not already added
        DocumentReference newCartDoc = await FirebaseFirestore.instance
            .collection('cart')
            .add({
          'userid': widget.userid,
          'productid': productId,
          'cartquantity': '1', // Set initial quantity to 1
        });

        // Update the newly added document with cart id equal to its document ID
        await newCartDoc.update({'cartid': newCartDoc.id});

        // Show success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Item added to cart'),
            backgroundColor: Colors.green,
          ),
        );

        // Delete item from wishlist after adding to cart
        await deleteWishlistItem(wishlistId);
      } else {
        // Show message if already in cart
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item is already in your cart')),
        );
      }
    } catch (e) {
      print('Error adding to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add item to cart')),
      );
    }
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
        title: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('wishlist')
              .where('userid', isEqualTo: widget.userid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              int wishlistCount = snapshot.data!.docs.length;
              return Text(
                "My WishList($wishlistCount)", // Dynamic wishlist count
                style: const TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              );
            } else {
              return const Text(
                "My WishList",
                style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              );
            }
          },
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('wishlist')
            .where('userid', isEqualTo: widget.userid)
            .snapshots(),
        builder: (context, wishlistSnapshot) {
          if (wishlistSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!wishlistSnapshot.hasData || wishlistSnapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Your wishlist is empty!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // Get list of product ids from wishlist
          List<String> productIds = wishlistSnapshot.data!.docs
              .map((doc) => doc['productid'] as String)
              .toList();

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchWishlistProducts(productIds),
            builder: (context, productSnapshot) {
              if (productSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!productSnapshot.hasData || productSnapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No products found!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              List<Map<String, dynamic>> wishlistProducts = productSnapshot.data!;

              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView.builder(
                        itemCount: wishlistProducts.length,
                        itemBuilder: (context, index) {
                          // Get product data
                          var product = wishlistProducts[index];
                          var wishlistItem = wishlistSnapshot.data!.docs[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              height: 100, // Increased height for each product
                              color: Colors.grey.shade200,
                              child: Row(
                                children: [
                                  // Product Image
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image.network(
                                      product['productimage'],
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // Product Title, Availability, and Actions
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                product['productname'],
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: product['prodcuctavailibility'] == 'In Stock'
                                                  ? () {
                                                addToCart(product['productid'], wishlistItem.id);
                                              }
                                                  : () {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Cannot add to cart, product is out of stock'),
                                                  ),
                                                );
                                              },
                                              child: Icon(
                                                Icons.add_shopping_cart_rounded,
                                                color: product['prodcuctavailibility'] == 'In Stock'
                                                    ? Colors.green
                                                    : Colors.black, // Black if out of stock
                                                size: 30,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            GestureDetector(
                                              onTap: () {
                                                // Delete wishlist item
                                                deleteWishlistItem(wishlistItem.id);
                                              },
                                              child: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                                size: 30,
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          product['prodcuctavailibility'],
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: product['prodcuctavailibility'] == 'In Stock'
                                                  ? Colors.green
                                                  : Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // Fetch product details for the wishlist products
  Future<List<Map<String, dynamic>>> fetchWishlistProducts(List<String> productIds) async {
    List<Map<String, dynamic>> products = [];
    for (String productId in productIds) {
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();
      if (productSnapshot.exists) {
        products.add(productSnapshot.data() as Map<String, dynamic>);
      }
    }
    return products;
  }
}
