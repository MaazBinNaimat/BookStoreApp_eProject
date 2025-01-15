import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'contactus_screen.dart';
import 'edit_profile_screen.dart';
import 'faqs_display_screen.dart';
import 'feedback_submit_screen.dart';
import 'my_cart_screen.dart';
import 'my_wishlist_screen.dart';
import 'myorders_display_screen.dart';
import 'myreviews_display_screen.dart';

import 'login_screen.dart';

class MyprofileScreen extends StatefulWidget {
  final String userid;
  const MyprofileScreen({super.key, required this.userid});


  @override
  State<MyprofileScreen> createState() => _MyprofileScreenState();
}



class _MyprofileScreenState extends State<MyprofileScreen> {

  // User detail fetch code
  String profileImageUrl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnSA1zygA3rubv-VK0DrVcQ02Po79kJhXo_A&s'; // Default profile image
  String userName = 'user'; // Default user name
  String userEmail = 'user@example.com';
  String userShippingAddress = 'abc 123 address';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

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
          userEmail = data['useremail'];
          userShippingAddress = data['shippingaddress'];
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.deepPurpleAccent),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: Text(
          "My Account",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
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
                      // backgroundImage: NetworkImage(
                      //     'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg'),
                      backgroundImage: NetworkImage(profileImageUrl),
                      radius: 30,
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${userName}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "${userEmail}",
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
                              MaterialPageRoute(builder: (context) => EditProfileScreen(userid: widget.userid)),
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
                              MaterialPageRoute(builder: (context) => MyWishlistScreen(userid: widget.userid)),
                            );
                          },
                          child: _buildOptionContainer(
                            icon: Icons.favorite,
                            text: "My Wishlist",
                            avatarBackgroundColor: Colors.pinkAccent,
                          ),
                        ),
                        SizedBox(height: 20),
                        // My Cart Option
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyCartScreen(userid: widget.userid)),
                            );
                          },
                          child: _buildOptionContainer(
                            icon: Icons.shopping_cart,
                            text: "My Cart",
                            avatarBackgroundColor: Colors.amberAccent,
                          ),
                        ),
                        SizedBox(height: 20),
                        // My Orders Option
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyordersDisplayScreen(userid: widget.userid)),
                            );
                          },
                          child: _buildOptionContainer(
                            icon: Icons.list_alt,
                            text: "My Orders",
                            avatarBackgroundColor: Colors.purpleAccent,
                          ),
                        ),
                        SizedBox(height: 20),
                        // My Reviews Option
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyreviewsDisplayScreen(userid: widget.userid)),
                            );
                          },
                          child: _buildOptionContainer(
                            icon: Icons.star,
                            text: "My Reviews",
                            avatarBackgroundColor: Colors.orangeAccent,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Contact Us Option
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ContactusScreen(userid: widget.userid)),
                            );
                          },
                          child: _buildOptionContainer(
                            icon: Icons.contact_mail,
                            text: "Contact Us",
                            avatarBackgroundColor: Colors.black26,
                          ),
                        ),


                        SizedBox(height: 20),
                        // Submit Feedback Option
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FeedbackSubmitScreen(userid: widget.userid)),
                            );
                          },
                          child: _buildOptionContainer(
                            icon: Icons.message,
                            text: "Submit Feedback",
                            avatarBackgroundColor: Colors.brown,
                          ),
                        ),

                        SizedBox(height: 20),
                        // My Reviews Option
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FaqsDisplayScreen()),
                            );
                          },
                          child: _buildOptionContainer(
                            icon: Icons.question_mark_rounded,
                            text: "Frequently Asked Questions",
                            avatarBackgroundColor: Colors.teal,
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: avatarBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(text, style: TextStyle(fontSize: 18, color: textColor)),
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
          title: Text("My Profile", textAlign: TextAlign.center,style: TextStyle(color: Colors.deepPurpleAccent),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                // backgroundImage: NetworkImage(
                //     'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg'),
                backgroundImage: NetworkImage(profileImageUrl),
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
                  "${userName}",
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
                  "${userEmail}",
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
                  "*******",
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
                  "Shipping Address:",
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
                  "${userShippingAddress}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
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
