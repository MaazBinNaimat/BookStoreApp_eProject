import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_adminprofile_screen.dart';
import 'feedbacks_display_screen.dart';
import 'manage_categories_screen.dart';
import 'manage_faqs_screen.dart';
import 'manage_orders_screen.dart';
import 'manage_products_screen.dart';
import 'messages_display_screen.dart';
import 'reviews_display_screen.dart';
import 'users_display_screen.dart';
import '../userpanel/login_screen.dart';

class AdminHomepageScreen extends StatefulWidget {
  final String adminId; // Add this line to accept adminId

  const AdminHomepageScreen({super.key, required this.adminId}); // Update constructor

  @override
  State<AdminHomepageScreen> createState() => _AdminHomepageScreenState();
}

class _AdminHomepageScreenState extends State<AdminHomepageScreen> {
  late Future<DocumentSnapshot> adminData;

  @override
  void initState() {
    super.initState();
    adminData = FirebaseFirestore.instance
        .collection('admin')
        .doc(widget.adminId) // Use the passed adminId to fetch data
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: CircleAvatar(
        //     backgroundColor: Colors.white,
        //     child: IconButton(
        //       icon: Icon(Icons.arrow_back, color: Colors.deepPurpleAccent),
        //       onPressed: () => Navigator.of(context).pop(),
        //     ),
        //   ),
        // ),
        title: Text(
          "Admin Homepage",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: adminData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No data found'));
          }

          var admin = snapshot.data!;
          String name = admin['adminname'] ?? 'No Name';
          String email = admin['adminemail'] ?? 'No Email';
          String imageUrl = admin['image'] ?? 'https://static.vecteezy.com/system/resources/thumbnails/020/962/986/small_2x/software-engineer-graphic-clipart-design-free-png.png';

          return Container(
            width: double.infinity,
            color: Colors.deepPurpleAccent,
            child: Column(
              children: [
                // Profile image, name and email show
                Container(
                  height: 100,
                  color: Colors.deepPurpleAccent,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(imageUrl),
                          // backgroundImage: MemoryImage(imageUrl as Uint8List),
                          radius: 30,
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              email,
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                // Managing and viewing profile and more Container
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            // 1) view Profile Option
                            GestureDetector(
                              onTap: () {
                                _showProfileDialog(context);
                              },
                              child: _buildOptionContainer(
                                icon: Icons.person,
                                text: "View Profile",
                                avatarBackgroundColor: Colors.green,
                              ),
                            ),

                            // 2) Edit Profile Option
                            SizedBox(height: 20),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => EditAdminprofileScreen(adminId: widget.adminId)),
                                );
                              },
                              child: _buildOptionContainer(
                                icon: Icons.edit,
                                text: "Edit Profile",
                                avatarBackgroundColor: Colors.lightBlueAccent,
                              ),
                            ),
                            SizedBox(height: 20),
                            // My Wishlist Option
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ManageCategoriesScreen()),
                                );
                              },
                              child: _buildOptionContainer(
                                icon: Icons.shopping_cart,
                                text: "Manage Categories",
                                avatarBackgroundColor: Colors.pinkAccent,
                              ),
                            ),
                            SizedBox(height: 20),
                            // My Cart Option
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ManageProductsScreen()),
                                );
                              },
                              child: _buildOptionContainer(
                                icon: Icons.shopping_bag,
                                text: "Manage Products",
                                avatarBackgroundColor: Colors.amberAccent,
                              ),
                            ),
                            SizedBox(height: 20),
                            // My Orders Option
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ManageOrdersScreen()),
                                );
                              },
                              child: _buildOptionContainer(
                                icon: Icons.list_alt,
                                text: "Manage Orders",
                                avatarBackgroundColor: Colors.purpleAccent,
                              ),
                            ),
                            SizedBox(height: 20),
                            // My Reviews Option
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ManageFaqsScreen()),
                                );
                              },
                              child: _buildOptionContainer(
                                icon: Icons.question_mark_rounded,
                                text: "Manage Faq's",
                                avatarBackgroundColor: Colors.teal,
                              ),
                            ),
                            SizedBox(height: 20),
                            // My Reviews Option
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => UsersDisplayScreen()),
                                );
                              },
                              child: _buildOptionContainer(
                                icon: Icons.people_outline_rounded,
                                text: "See User's",
                                avatarBackgroundColor: Colors.tealAccent,
                              ),
                            ),
                            SizedBox(height: 20),
                            // My Reviews Option
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ReviewsDisplayScreen()),
                                );
                              },
                              child: _buildOptionContainer(
                                icon: Icons.star,
                                text: "See Reviews",
                                avatarBackgroundColor: Colors.orangeAccent,
                              ),
                            ),
                            SizedBox(height: 20),
                            // My Reviews Option
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MessagesDisplayScreen()),
                                );
                              },
                              child: _buildOptionContainer(
                                icon: Icons.contact_mail,
                                text: "See Messages",
                                avatarBackgroundColor: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 20),
                            // My Reviews Option
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => FeedbacksDisplayScreen()),
                                );
                              },
                              child: _buildOptionContainer(
                                icon: Icons.message_sharp,
                                text: "See Feedbacks",
                                avatarBackgroundColor: Colors.brown,
                              ),
                            ),
                            SizedBox(height: 10),
                            // Logout Option
                            GestureDetector(
                              onTap: (){
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen()),
                                      (route) => false,
                                );
                              },
                              child: _buildOptionContainer(
                                icon: Icons.logout,
                                text: "Logout",
                                avatarBackgroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOptionContainer({
    required IconData icon,
    required String text,
    Color avatarBackgroundColor = Colors.transparent,
    Color backgroundColor = const Color(0xffF0F0F0),
    Color textColor = Colors.black,
  }) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: avatarBackgroundColor,
              radius: 20,
              child: Icon(icon, color: Colors.white),
            ),
            SizedBox(width: 15),
            Text(text, style: TextStyle(color: textColor, fontSize: 16)),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.black, size: 18),
          ],
        ),
      ),
    );
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Admin Profile",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.deepPurpleAccent),
          ),
          content: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('admin')
                .doc(widget.adminId) // Fetch data using adminId
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text('No data found'));
              }

              var adminData = snapshot.data!;
              String adminName = adminData['adminname'] ?? 'No Name';
              String adminEmail = adminData['adminemail'] ?? 'No Email';
              String adminPassword = adminData['adminpassword'] ?? '*******';
              String imageUrl = adminData['image'] ?? 'https://static.vecteezy.com/system/resources/thumbnails/020/962/986/small_2x/software-engineer-graphic-clipart-design-free-png.png';

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl.toString()),
                    radius: 40,
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Name:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      adminName,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      adminEmail,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      adminPassword.replaceAll(RegExp(r'.'), '*'), // Mask password
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Divider(),


                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Image url:",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      imageUrl,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Divider(),
                ],
              );
            },
          ),
          actions: [
            Center(
              child: TextButton(
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

}
