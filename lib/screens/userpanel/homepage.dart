import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_product_card/flutter_product_card.dart';
import 'categories_display_screen.dart';
import 'myprofile_screen.dart';
import 'product_display_screen.dart';

class HomepageScreen extends StatefulWidget {
  final String userid;
  const HomepageScreen({super.key, required this.userid});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  int cartItemCount = 5; // Example cart item count

  List imagesList = [
    {"id": 1, "image_path": "images/banners/watchbanner1.jpg"},
    {"id": 2, "image_path": "images/banners/watchbanner2.jpeg"},
    {"id": 3, "image_path": "images/banners/watchbanner3.jpg"},
  ];

  final CarouselSliderController carouselController = CarouselSliderController();
  int currentIndex = 0;

  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> products = [];

  // Declare user profile-related variables here
  String profileImageUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnSA1zygA3rubv-VK0DrVcQ02Po79kJhXo_A&s'; // Default profile image
  String userName = 'User'; // Default user name

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchCategoriesAndProducts();
    cartItemCountStream();
  }

  // Fetch categories and products
  Future<void> fetchCategoriesAndProducts() async {
    try {
      // Fetch categories
      final categoriesSnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .get();

      List<Map<String, dynamic>> fetchedCategories = [];
      for (var doc in categoriesSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        fetchedCategories.add({
          'id': doc.id,
          'image': data['categoryimage'] ?? '',
          'name': data['categoryname'] ?? '',
        });
      }

      // Fetch products
      final productsSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .limit(5)
          .get();

      List<Map<String, dynamic>> fetchedProducts = [];
      for (var productDoc in productsSnapshot.docs) {
        final productData = productDoc.data() as Map<String, dynamic>;

        // Find the matching category based on categoryid
        String categoryId = productData['categoryid'];
        String categoryName = fetchedCategories
            .firstWhere(
                (category) => category['id'] == categoryId,
            orElse: () => {'name': 'Unknown Category'})['name'];

        fetchedProducts.add({
          'id': productDoc.id,
          'name': productData['productname'] ?? '',
          'image': productData['productimage'] ?? '',
          'price': productData['productprice'] ?? '',
          'brand': productData['productbrand'] ?? '',
          'availability': productData['prodcuctavailibility'] ?? '',
          'description': productData['productdescription'] ?? '',
          'categoryName': categoryName,
        });
      }

      setState(() {
        categories = fetchedCategories;
        products = fetchedProducts;
      });
    } catch (e) {
      print('Error fetching categories and products: $e');
    }
  }

  // Fetch user details
  Future<void> fetchUserData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userid)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        setState(() {
          profileImageUrl = data['image'] ?? profileImageUrl;
          userName = data['username'] ?? userName;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }


// Stream to listen to changes in the cart collection for the user
  Stream<int> cartItemCountStream() {
    return FirebaseFirestore.instance
        .collection('cart')
        .where('userid', isEqualTo: widget.userid)
        .snapshots()
        .map((snapshot) => snapshot.docs.length); // Return the number of cart items
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile display container
              Container(
                height: 140,
                color: Colors.deepPurpleAccent,
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Profile Pic Column
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyprofileScreen(userid: widget.userid),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(profileImageUrl),
                              radius: 20,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Text Column
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Hello! $userName",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Have a good time",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Cart Icon Column with StreamBuilder
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.shopping_cart,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              // StreamBuilder to display real-time cart item count
                              Positioned(
                                right: -8,
                                top: -8,
                                child: StreamBuilder<int>(
                                  stream: cartItemCountStream(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error');
                                    }
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Container(); // Loading state
                                    }
                                    int cartItemCount = snapshot.data ?? 0;
                                    return Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$cartItemCount',  // Dynamic count from Stream
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Carousel Container
              Container(
                height: 200, // Set a fixed height for the carousel container
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Stack(
                  children: [
                    CarouselSlider(
                      items: imagesList
                          .map(
                            (item) => ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            item['image_path'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      )
                          .toList(),
                      carouselController: carouselController,
                      options: CarouselOptions(
                        scrollPhysics: const BouncingScrollPhysics(),
                        autoPlay: true,
                        aspectRatio: 16/9, // Adjust aspect ratio to fit the container
                        viewportFraction: 1.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imagesList.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => carouselController.animateToPage(entry.key),
                            child: Container(
                              width: currentIndex == entry.key ? 17 : 7,
                              height: 7.0,
                              margin: const EdgeInsets.symmetric(horizontal: 3.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: currentIndex == entry.key
                                      ? Colors.deepPurpleAccent
                                      : Colors.white),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              // Third Container with Categories Carousel
              Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    color: Colors.deepPurpleAccent.withOpacity(0.6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Browse Categories",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),

                              // Redirect to Categories Display Screen
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => CategoriesDisplayScreen ()),
                                  );
                                },
                                child: Text("See All",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Categories Manual Infinite Carousel
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return Container(
                                margin: EdgeInsets.only(right: 15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      // backgroundColor: Color(0xffFDCF09),
                                      backgroundColor: Colors.deepPurpleAccent.withOpacity(0.6),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(category['image']),

                                        radius: 28,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      category['name'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white.withOpacity(0.8)
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Fourth Container Latest Products
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  width: double.infinity,
                  height: 270, // Adjust the height as needed
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Latest Products",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurpleAccent.withOpacity(0.6),
                            ),
                          ),
                          // Redirect to Shop Screen
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductsDisplayScreen(userid: widget.userid),
                                ),
                              );
                            },
                            child: Text(
                              "See All",
                              style: TextStyle(
                                color: Colors.deepPurpleAccent.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: Colors.deepPurpleAccent.withOpacity(0.1),
                                ),
                                width: 150,
                                height: 200,
                                child: Column(
                                  children: [
                                    // Image Row
                                    Container(
                                      height: 130,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(product['image']), // Use NetworkImage for URL-based images
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Container(
                                        height: 90,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(product['name'], // Match the fetched product data key
                                                style: TextStyle(fontWeight: FontWeight.bold)),
                                            Text(
                                              product['categoryName'],
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            Text(
                                              product['brand'], // Ensure the keys match the fetched data
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Rs ${product['price']}', // Match product price key
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                                // Conditional text for availability
                                                Text(
                                                  product['availability'] == "In Stock"
                                                      ? "In Stock"
                                                      : "Out of Stock",
                                                  style: TextStyle(
                                                    color: product['availability'] == "In Stock"
                                                        ? Colors.green
                                                        : Colors.red,
                                                    fontSize: 13,
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
                    ],
                  ),
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
}


