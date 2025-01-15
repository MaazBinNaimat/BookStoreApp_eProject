import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDescriptionScreen extends StatefulWidget {
  final String userid;
  final String productid;

  const ProductDescriptionScreen({
    super.key,
    required this.userid,
    required this.productid,
  });

  @override
  State<ProductDescriptionScreen> createState() => _ProductDescriptionScreenState();
}

class _ProductDescriptionScreenState extends State<ProductDescriptionScreen> {
  int _quantity = 1;
  Map<String, dynamic>? productData;
  Map<String, dynamic>? categoryData;
  bool _isInCart = false;
  List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
    checkIfInCart();
    fetchReviews();
  }

  Future<void> fetchProductDetails() async {
    try {
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productid)
          .get();

      if (productSnapshot.exists) {
        setState(() {
          productData = productSnapshot.data() as Map<String, dynamic>?;
        });

        String? categoryId = productData?['categoryid'];
        if (categoryId != null) {
          DocumentSnapshot categorySnapshot = await FirebaseFirestore.instance
              .collection('categories')
              .doc(categoryId)
              .get();

          if (categorySnapshot.exists) {
            setState(() {
              categoryData = categorySnapshot.data() as Map<String, dynamic>?;
            });
          }
        }
      }
    } catch (e) {
      print("Error fetching product or category details: $e");
    }
  }

  Future<void> checkIfInCart() async {
    try {
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .where('userid', isEqualTo: widget.userid)
          .where('productid', isEqualTo: widget.productid)
          .get();

      if (cartSnapshot.docs.isNotEmpty) {
        setState(() {
          _isInCart = true;
        });
      }
    } catch (e) {
      print("Error checking cart: $e");
    }
  }

  Future<void> addToCart() async {
    try {
      final cartRef = FirebaseFirestore.instance.collection('cart').doc();

      await cartRef.set({
        'cartquantity': _quantity.toString(),
        'cartid': cartRef.id,
        'productid': widget.productid,
        'userid': widget.userid,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to cart successfully!'),
          backgroundColor: Colors.blue,
        ),
      );

      setState(() {
        _isInCart = true;
      });
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }

  Future<void> fetchReviews() async {
    try {
      QuerySnapshot reviewSnapshots = await FirebaseFirestore.instance
          .collection('reviews')
          .where('productid', isEqualTo: widget.productid)
          .get();

      List<Map<String, dynamic>> reviews = [];
      for (var reviewDoc in reviewSnapshots.docs) {
        Map<String, dynamic> reviewData = reviewDoc.data() as Map<String, dynamic>;
        String userId = reviewData['userid'];

        // Fetch user details
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userSnapshot.exists) {
          Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
          reviewData['username'] = userData['username'];
          reviewData['userimage'] = userData['image'];
        }

        // Convert rating from string to integer
        int rating = 0;
        try {
          rating = int.parse(reviewData['rating'].toString());
        } catch (e) {
          print("Error parsing rating: $e");
        }

        reviewData['rating'] = rating;
        reviews.add(reviewData);
      }

      setState(() {
        _reviews = reviews;
      });
    } catch (e) {
      print("Error fetching reviews: $e");
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
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: Text(
          "Product Description",
          style: TextStyle(
            color: Colors.deepPurpleAccent,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: productData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            // Product Image and Short Info
            Container(
              height: 250,
              color: Colors.white,
              child: Row(
                children: [
                  // Product Image Column
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: InstaImageViewer(
                          child: Image.network(
                            productData?['productimage'] ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Product Short Info Column
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productData?['productname'] ?? 'Product Name',
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    productData?['productbrand'] ?? 'Brand Name',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.shopping_bag,color: Colors.deepPurpleAccent,),
                                onPressed: () {
                                  // Handle wishlist toggle
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    categoryData?['categoryname'] ?? 'Category Name',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "Rs. ${productData?['productprice'] ?? '0'}",
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    productData?['prodcuctavailibility'] ?? '',
                                    style: TextStyle(
                                        color: productData?['prodcuctavailibility'] == 'In Stock'
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          // Quantity Selector and Add to Cart Button or Availability Message
                          if (_isInCart)
                            Container(
                              color: Colors.green,
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Product already in cart',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          else if (productData?['prodcuctavailibility'] == 'Out of Stock')
                            Container(
                              color: Colors.red,
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Item is out of stock, can\'t add to cart',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          else
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Quantity Selector
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (_quantity > 1) _quantity--;
                                          });
                                        },
                                        icon: Icon(Icons.remove),
                                      ),
                                      Text(
                                        '$_quantity',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _quantity++;
                                          });
                                        },
                                        icon: Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                  // Add to Cart Button
                                  ElevatedButton(
                                    onPressed: addToCart,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurpleAccent,
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                    ),
                                    child: Text('Add to Cart',style: TextStyle(color: Colors.white),),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Description
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent.withOpacity(0.3),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    productData?['productdescription'] ?? 'No description available.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            // Reviews Section
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  Text(
                    "Reviews",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  for (var review in _reviews)
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              review['userimage'] ?? 'https://via.placeholder.com/150',
                            ),
                            radius: 30,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review['username'] ?? 'Anonymous',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  review['review'] ?? 'No review',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: List.generate(
                                    review['rating'] ?? 0,
                                        (index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  review['date'],
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
