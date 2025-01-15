import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MyreviewsDisplayScreen extends StatefulWidget {
  final String userid;
  const MyreviewsDisplayScreen({super.key, required this.userid});

  @override
  State<MyreviewsDisplayScreen> createState() => _MyreviewsDisplayScreenState();
}

class _MyreviewsDisplayScreenState extends State<MyreviewsDisplayScreen> {
  List<Map<String, dynamic>> reviews = [];

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    try {
      QuerySnapshot reviewSnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('userid', isEqualTo: widget.userid)
          .get();

      List<Map<String, dynamic>> fetchedReviews = [];

      for (var reviewDoc in reviewSnapshot.docs) {
        var reviewData = reviewDoc.data() as Map<String, dynamic>;

        DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .doc(reviewData['productid'])
            .get();

        var productData = productSnapshot.data() as Map<String, dynamic>;

        fetchedReviews.add({
          'productImageUrl': productData['productimage'],
          'productName': productData['productname'],
          'rating': int.parse(reviewData['rating']),
          'orderId': reviewData['orderid'],
          'review': reviewData['review'],
          'date': reviewData['date'],
        });
      }

      setState(() {
        reviews = fetchedReviews;
      });
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }

  String getStars(int rating) {
    return '⭐' * rating;
  }

  Color getStarColor(int rating, int starIndex) {
    return starIndex < rating ? Colors.yellow : Colors.grey;
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
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      color: getStarColor(review['rating'], index),
                    );
                  }),
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
          "My Reviews",
          style: TextStyle(
            color: Colors.deepPurpleAccent,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
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
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              color: getStarColor(review['rating'], index),
                            );
                          }),
                        ),
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
      ),
    );
  }
}
