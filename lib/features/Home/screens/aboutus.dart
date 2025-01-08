import 'package:flutter/material.dart';
import 'package:pets/utils/colors.dart';

class Aboutus extends StatelessWidget {
  const Aboutus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryLightColor4,
      appBar: AppBar(backgroundColor: secondaryLightColor),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Us',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Who We Are',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We are passionate about animals and dedicated to providing healthy, well-cared-for pets to loving homes. Our platform connects animal lovers with reputable breeders and shelters to find their perfect companion.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Why Buy From Us?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '1. **Healthy Animals**: All our animals are raised with the utmost care and meet health standards.\n'
              '2. **Verified Sellers**: We ensure that every seller on our platform is verified and committed to the well-being of their animals.\n'
              '3. **Wide Variety**: Whether you’re looking for a pet dog, cat, bird, or something more exotic, we offer a wide range of species.\n'
              '4. **Transparent Process**: You can view detailed information about each animal, including health history, temperament, and more before making a purchase.\n',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Our Mission',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Our mission is to foster a love for animals by making it easy for people to find and buy the right pet, ensuring the welfare of animals and satisfaction of customers.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Have any questions or concerns? Feel free to reach out to us at sabahmushtaq002@gmail.com or call us at 6006503121.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
