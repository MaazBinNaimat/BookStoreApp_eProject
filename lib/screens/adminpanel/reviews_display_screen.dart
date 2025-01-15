import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewsDisplayScreen extends StatefulWidget {
  const ReviewsDisplayScreen({super.key});

  @override
  State<ReviewsDisplayScreen> createState() => _ReviewsDisplayScreenState();
}

class _ReviewsDisplayScreenState extends State<ReviewsDisplayScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchReviews() async {
    List<Map<String, dynamic>> reviewList = [];

    // Fetch reviews
    QuerySnapshot reviewSnapshot = await _firestore.collection('reviews').get();

    for (var doc in reviewSnapshot.docs) {
      Map<String, dynamic> reviewData = doc.data() as Map<String, dynamic>;
      String productId = reviewData['productid'];
      String userId = reviewData['userid'];

      // Fetch product details
      DocumentSnapshot productDoc = await _firestore.collection('products').doc(productId).get();
      Map<String, dynamic> productData = productDoc.data() as Map<String, dynamic>;

      // Fetch user details
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Combine all data
      reviewList.add({
        'username': userData['username'],
        'email': userData['useremail'],
        'productImageUrl': productData['productimage'],
        'productName': productData['productname'],
        'rating': int.parse(reviewData['rating']),
        'orderId': reviewData['orderid'],
        'review': reviewData['review'],
        'date': reviewData['date'],
      });
    }

    return reviewList;
  }

  Widget getStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.yellow,
          size: 20,
        );
      }),
    );
  }

  void showReviewModal(BuildContext context, Map<String, dynamic> review) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Review', style: TextStyle(color: Colors.deepPurpleAccent)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      review['productImageUrl']!,
                      height: 100.0,
                      width: 100.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text('Order ID: ${review['orderId']}'),
                const SizedBox(height: 8),
                Text('Product Name: ${review['productName']}'),
                const SizedBox(height: 8),
                Text('Username: ${review['username']}'),
                const SizedBox(height: 8),
                Text('Email: ${review['email']}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Rating: '),
                    getStars(review['rating']),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Review: ${review['review']}'),
                const SizedBox(height: 8),
                Text('Date: ${review['date']}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
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
          "See Reviews",
          style: TextStyle(
            color: Colors.deepPurpleAccent,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No reviews available.'));
          } else {
            final reviews = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: reviews.map((review) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                        // Square avatar with border radius
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            review['productImageUrl']!,
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
                                review['productName']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text('by: ${review['username']}'),
                              const SizedBox(height: 4.0),
                              Text(review['email']!),
                              const SizedBox(height: 4.0),
                              getStars(review['rating']),
                            ],
                          ),
                        ),
                        // Eye icon to open modal
                        IconButton(
                          icon: const Icon(Icons.remove_red_eye, color: Colors.deepPurpleAccent),
                          onPressed: () => showReviewModal(context, review),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
