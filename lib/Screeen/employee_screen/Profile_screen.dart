import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_page/Model/User.dart';
import 'package:screen_page/Provider/UserProvider.dart';

class Profile_screen extends StatelessWidget {
  const Profile_screen({super.key});

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context, listen: false).get_user;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 300,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/Images/avtarImag.jpg'),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "${user.name}",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '💼 Painter  \n\n📍From Blida  \n\n🕥 5 years experience\n\n★ ',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        TextSpan(
                          text: '4.7',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '/5.0',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: Text(
                'Quick Statistics',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildClickableStatCard(
                      context,
                      color: const Color.fromARGB(255, 107, 185, 248)!,
                      title: 'Completed\n Bookings',
                      value: '128',
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: _buildClickableStatCard(
                      context,
                      color: const Color.fromARGB(255, 102, 245, 107)!,
                      title: 'Pending \nBookings',
                      value: '22',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildClickableStatCard(
                      context,
                      color: const Color.fromARGB(255, 254, 168, 39)!,
                      title: 'Total \nClients',
                      value: '98',
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _buildClickableStatCard(
                      context,
                      color: const Color.fromARGB(255, 164, 78, 179)!,
                      title: 'Average\n Rating',
                      value: '4.7',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Cadre de performance cliquable
              _buildClickablePerformanceComparison(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClickableStatCard(
    BuildContext context, {
    required Color color,
    required String title,
    required String value,
  }) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title clicked!'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 5),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClickablePerformanceComparison(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Performance Comparison clicked!'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Comparison',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            _buildComparisonRow('This Month', '86%', Colors.green),
            _buildComparisonRow('Last Month', '15%', Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(String period, String percentage, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(period, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              percentage,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
