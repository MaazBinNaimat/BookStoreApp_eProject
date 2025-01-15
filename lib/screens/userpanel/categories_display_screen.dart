import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // Import Firestore

class CategoriesDisplayScreen extends StatefulWidget {
  const CategoriesDisplayScreen({super.key});

  @override
  State<CategoriesDisplayScreen> createState() => _CategoriesDisplayScreenState();
}

class _CategoriesDisplayScreenState extends State<CategoriesDisplayScreen> {
  // Fetch categories from Firestore
  final CollectionReference categories = FirebaseFirestore.instance.collection('categories');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Scaffold(
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
            "Watches Categories",
            style: TextStyle(
              color: Colors.deepPurpleAccent,
              fontSize: 22,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          // Use StreamBuilder to fetch and display data
          child: StreamBuilder<QuerySnapshot>(
            stream: categories.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Error loading categories"));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              // Fetch data from the snapshot
              final List<DocumentSnapshot> categoryDocs = snapshot.data!.docs;

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.80,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: categoryDocs.length,
                itemBuilder: (context, index) {
                  // Get category data
                  var category = categoryDocs[index];
                  String categoryName = category['categoryname'];
                  String categoryImage = category['categoryimage'];
                  String categoryShortInfo = category['categoryshortinfo'];

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.deepPurpleAccent.withOpacity(0.1),
                    ),
                    width: 200,
                    height: 240,
                    child: Column(
                      children: [
                        Container(
                          height: 145,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(categoryImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            height: 50,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          categoryName,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _showCategoryInfo(context, categoryImage, categoryName, categoryShortInfo);
                                          },
                                          child: Icon(Icons.info_outline, color: Colors.green,),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // Modified _showCategoryInfo to accept dynamic category data
  void _showCategoryInfo(BuildContext context, String image, String name, String shortInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Category Info",style: TextStyle(color: Colors.deepPurpleAccent),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Name: $name",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Short Info: $shortInfo",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
