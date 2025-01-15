import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _products = [];

  void _fetchCategories() async {
    final categorySnapshot = await _firestore.collection('categories').get();
    setState(() {
      _categories = categorySnapshot.docs.map((doc) {
        return {
          'categoryid': doc['categoryid'],
          'categoryname': doc['categoryname'],
        };
      }).toList();
    });
  }

  void _fetchProducts() async {
    final productSnapshot = await _firestore.collection('products').get();
    setState(() {
      _products = productSnapshot.docs.map((doc) {
        return {
          'productId': doc.id,
          'productName': doc['productname'],
          'category': doc['categoryid'],
          'imageUrl': doc['productimage'],
          'description': doc['productdescription'],
          'availability': doc['prodcuctavailibility'],
          'price': doc['productprice'],
          'brand': doc['productbrand'],
        };
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchProducts();
  }

  void _showAddProductDialog() {
    String? selectedCategory;
    String? selectedAvailability;
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final imageController = TextEditingController();
    final brandController = TextEditingController();
    final descriptionController = TextEditingController();

    // Variable to hold the image URL
    String imageUrl = 'https://cdn-icons-png.flaticon.com/512/1375/1375106.png';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text(
                'Add Product',
                style: TextStyle(color: Colors.deepPurpleAccent),
              ),
              content: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CircleAvatar with image URL
                      Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(imageUrl),
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Product Name Field
                      const Text(
                        "Product Name",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Enter product name",
                          prefixIcon: const Icon(Icons.shopping_bag),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Price Field
                      const Text(
                        "Price",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: priceController,
                        decoration: InputDecoration(
                          hintText: "Enter price",
                          prefixIcon: const Icon(Icons.attach_money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Image Field
                      const Text(
                        "Image",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: imageController,
                        decoration: InputDecoration(
                          hintText: "Enter image URL",
                          prefixIcon: const Icon(Icons.image),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        onChanged: (url) {
                          setState(() {
                            imageUrl = url; // Update the image URL
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Brand Field
                      const Text(
                        "Brand Name",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: brandController,
                        decoration: InputDecoration(
                          hintText: "Enter brand name",
                          prefixIcon: const Icon(Icons.diamond),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Category Dropdown Field
                      const Text(
                        "Category",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        hint: const Text("Select category"),
                        items: _categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category['categoryid'],
                            child: Text(category['categoryname']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.shopping_cart),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Availability Dropdown Field
                      const Text(
                        "Availability",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedAvailability,
                        hint: const Text("Availability"),
                        items: const [
                          DropdownMenuItem(value: "In Stock", child: Text("In Stock")),
                          DropdownMenuItem(value: "Out of Stock", child: Text("Out of Stock")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedAvailability = value;
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.question_mark_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Product Description Field
                      const Text(
                        "Product Description",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "Enter product description",
                          prefixIcon: const Icon(Icons.description),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Add Product Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            final productId = _firestore.collection('products').doc().id;
                            await _firestore.collection('products').doc(productId).set({
                              'productid': productId,
                              'productname': nameController.text,
                              'productprice': priceController.text,
                              'productimage': imageController.text,
                              'productbrand': brandController.text,
                              'categoryid': selectedCategory,
                              'prodcuctavailibility': selectedAvailability,
                              'productdescription': descriptionController.text,
                            });
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Product added successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            _fetchProducts();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Add Product',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }


  void _showEditProductDialog(String productId) {
    final product = _products.firstWhere((prod) => prod['productId'] == productId);

    // Controllers with initial values
    final nameController = TextEditingController(text: product['productName']);
    final priceController = TextEditingController(text: product['price']);
    final imageController = TextEditingController(text: product['imageUrl']);
    final brandController = TextEditingController(text: product['brand']);
    final descriptionController = TextEditingController(text: product['description']);
    String? selectedCategory = product['category'];
    String? selectedAvailability = product['availability'];
    String imageUrl = product['imageUrl']; // Initialize imageUrl with the current URL

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text(
                'Edit Product',
                style: TextStyle(color: Colors.deepPurpleAccent),
              ),
              content: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CircleAvatar with dynamic image
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(imageUrl),
                              backgroundColor: Colors.grey[200], // Provide a default color while loading
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.edit, color: Colors.deepPurpleAccent),
                                onPressed: () {
                                  // Implement image picker or URL change logic here if needed
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Product Name Field
                      const Text(
                        "Product Name",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Enter product name",
                          prefixIcon: const Icon(Icons.shopping_bag),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Price Field
                      const Text(
                        "Price",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: priceController,
                        decoration: InputDecoration(
                          hintText: "Enter price",
                          prefixIcon: const Icon(Icons.attach_money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Image Field
                      const Text(
                        "Image",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: imageController,
                        decoration: InputDecoration(
                          hintText: "Enter image URL",
                          prefixIcon: const Icon(Icons.image),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        onChanged: (url) {
                          setState(() {
                            imageUrl = url; // Update the imageUrl state
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Brand Field
                      const Text(
                        "Brand Name",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: brandController,
                        decoration: InputDecoration(
                          hintText: "Enter brand name",
                          prefixIcon: const Icon(Icons.diamond),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Category Dropdown Field
                      const Text(
                        "Category",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        hint: const Text("Select category"),
                        items: _categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category['categoryid'],
                            child: Text(category['categoryname']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.shopping_cart),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Availability Dropdown Field
                      const Text(
                        "Availability",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedAvailability,
                        hint: const Text("Availability"),
                        items: const [
                          DropdownMenuItem(value: "In Stock", child: Text("In Stock")),
                          DropdownMenuItem(value: "Out of Stock", child: Text("Out of Stock")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedAvailability = value;
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.question_mark_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Product Description Field
                      const Text(
                        "Product Description",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "Enter product description",
                          prefixIcon: const Icon(Icons.description),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Update Product Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            await _firestore.collection('products').doc(productId).update({
                              'productname': nameController.text,
                              'productprice': priceController.text,
                              'productimage': imageController.text,
                              'productbrand': brandController.text,
                              'categoryid': selectedCategory,
                              'prodcuctavailibility': selectedAvailability,
                              'productdescription': descriptionController.text,
                            });
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Product updated successfully!', style: TextStyle(color: Colors.black)),
                                backgroundColor: Colors.yellow,
                              ),
                            );
                            _fetchProducts();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Update Product',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }



  void _deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Product deleted successfully!'),
        backgroundColor: Colors.red,
      ),
    );
    _fetchProducts();
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
          "Manage Products",
          style: TextStyle(
            color: Colors.deepPurpleAccent,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _products.length,
          itemBuilder: (context, index) {
            final product = _products[index];
            return Card(
              elevation: 4,
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(product['imageUrl']),
                ),
                title: Text(product['productName']),
                subtitle: Text(product['brand']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _showEditProductDialog(product['productId']);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteProduct(product['productId']);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog,
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}
