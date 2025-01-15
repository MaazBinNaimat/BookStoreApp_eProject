import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_description_screen.dart';

class ProductsDisplayScreen extends StatefulWidget {
  final String userid;
  const ProductsDisplayScreen({super.key, required this.userid});

  @override
  State<ProductsDisplayScreen> createState() => _ProductsDisplayScreenState();
}

class _ProductsDisplayScreenState extends State<ProductsDisplayScreen> {
  String searchName = '';
  String minPrice = '';
  String maxPrice = '';
  String? selectedCategory;

  List<Map<String, dynamic>> products = [];
  Map<String, String> categoryNames = {};
  Set<String> wishlistProductIds = {};

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchCategories();
    fetchWishlist();
  }

  Future<void> fetchProducts() async {
    try {
      Query query = FirebaseFirestore.instance.collection('products');

      // Apply name filter
      if (searchName.isNotEmpty) {
        query = query.where('productname', isGreaterThanOrEqualTo: searchName)
            .where('productname', isLessThanOrEqualTo: searchName + '\uf8ff');
      }

      // Fetch products based on the query
      final productsSnapshot = await query.get();
      final List<Map<String, dynamic>> fetchedProducts = productsSnapshot.docs.map((doc) {
        return {
          'productid': doc.get('productid') ?? '',
          'productname': doc.get('productname') ?? 'Unknown Product',
          'productimage': doc.get('productimage') ?? 'https://default_image_url',
          'productbrand': doc.get('productbrand') ?? 'Unknown Brand',
          'productavailability': doc.get('prodcuctavailibility') ?? 'Not Available',
          'productprice': doc.get('productprice')?.toString() ?? '0',
          'categoryid': doc.get('categoryid') ?? '',
          'productdescription': doc.get('productdescription') ?? 'No Description',
        };
      }).toList();

      setState(() {
        products = fetchedProducts;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<void> fetchCategories() async {
    try {
      final categoriesSnapshot = await FirebaseFirestore.instance.collection('categories').get();
      final Map<String, String> fetchedCategoryNames = {
        for (var doc in categoriesSnapshot.docs)
          doc.get('categoryid'): doc.get('categoryname') ?? 'Unknown Category'
      };

      setState(() {
        categoryNames = fetchedCategoryNames;
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> fetchWishlist() async {
    try {
      final wishlistSnapshot = await FirebaseFirestore.instance
          .collection('wishlist')
          .where('userid', isEqualTo: widget.userid)
          .get();

      final Set<String> fetchedWishlistProductIds = wishlistSnapshot.docs
          .map((doc) => doc.get('productid') as String)
          .toSet();

      setState(() {
        wishlistProductIds = fetchedWishlistProductIds;
      });
    } catch (e) {
      print('Error fetching wishlist: $e');
    }
  }

  Future<void> toggleWishlist(String productId, bool isFavorite) async {
    final wishlistCollection = FirebaseFirestore.instance.collection('wishlist');

    if (isFavorite) {
      // Remove from wishlist
      final query = wishlistCollection
          .where('userid', isEqualTo: widget.userid)
          .where('productid', isEqualTo: productId)
          .limit(1);

      final querySnapshot = await query.get();
      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
        setState(() {
          wishlistProductIds.remove(productId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item removed from wishlist'), backgroundColor: Colors.red),
        );
      }
    } else {
      // Add to wishlist
      final docRef = wishlistCollection.doc(); // Generate a new document reference
      await docRef.set({
        'productid': productId,
        'userid': widget.userid,
        'wishlistid': docRef.id,
      });
      setState(() {
        wishlistProductIds.add(productId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item added to wishlist'), backgroundColor: Colors.pink),
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
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: Text(
          "Products",
          style: TextStyle(
            color: Colors.deepPurpleAccent,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final categoryName = categoryNames[product['categoryid']] ?? 'Unknown Category';
              final productId = product['productid'];
              final isFavorite = wishlistProductIds.contains(productId);

              return GestureDetector(
                onTap: () {
                  // Navigate to Product Description Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDescriptionScreen(userid: widget.userid, productid: product['productid']),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: Column(
                    children: [
                      // Image Container
                      Container(
                        height: 135,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(product['productimage']),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                        ),
                      ),
                      // Product Details Container
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['productname'],
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        categoryName,
                                        style: TextStyle(fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        product['productbrand'],
                                        style: TextStyle(fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorite ? Colors.pink : Colors.grey,
                                    ),
                                    onPressed: () async {
                                      await toggleWishlist(productId, isFavorite);
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Rs ${product['productprice']}",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    product['productavailability'],
                                    style: TextStyle(
                                      color: product['productavailability'] == "In Stock"
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search by Name
                    Text("Search by Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent)),
                    TextFormField(
                      initialValue: searchName,
                      decoration: InputDecoration(
                        hintText: "Enter product name",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchName = value;
                          // Fetch products with the updated search name
                          fetchProducts();
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    // Add other filter fields here if needed
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: Colors.deepPurpleAccent,
        child: Icon(Icons.filter_alt, color: Colors.white),
      ),
    );
  }
}
