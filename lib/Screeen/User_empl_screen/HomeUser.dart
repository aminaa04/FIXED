import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_page/Provider/UserProvider.dart';
import 'package:screen_page/Screeen/User_screen/OrderBookingPage.dart';
import 'package:screen_page/Screeen/User_screen/SearchPage.dart';

class Homeuser extends StatefulWidget {
  const Homeuser({super.key});

  @override
  State<Homeuser> createState() => _HomePageState();
}

class _HomePageState extends State<Homeuser> {
  Set<String> _favoriteWorkers = {};

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    var allservise =
        Provider.of<UserProvider>(context, listen: false).getallservise;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchAndPostBar(context),
            SizedBox(height: screenHeight * 0.03),
            _buildSectionTitle(context, "Popular Categories"),
            SizedBox(height: screenHeight * 0.015),
            _buildCategoryList([
              {
                'name': 'Plumbing',
                'icon': Icons.plumbing,
                'color': Colors.blue[400],
              },
              {
                'name': 'Electrical',
                'icon': Icons.electrical_services,
                'color': Colors.orange[400],
              },
              {
                'name': 'Cleaning',
                'icon': Icons.cleaning_services,
                'color': Colors.green[400],
              },
              {
                'name': 'Paint',
                'icon': Icons.format_paint,
                'color': Colors.purple[400],
              },
              {
                'name': 'Paint',
                'icon': Icons.format_paint,
                'color': Colors.purple[400],
              },
            ]),
            SizedBox(height: screenHeight * 0.04),
            _buildSectionTitle(context, "Recommended Worker"),
            SizedBox(height: screenHeight * 0.015),
            _buildWorkerSuggestions(allservise),
            SizedBox(height: screenHeight * 0.03),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndPostBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05; // 5% of screen width
    final isTablet = screenWidth > 600;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 20,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                readOnly: true,
                onTap: () {
                  // Navigate to SearchPage
                },
                style: TextStyle(fontSize: isTablet ? 18 : 16),
                decoration: InputDecoration(
                  hintText: 'Search a service...',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: isTablet ? 18 : 16,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                    size: isTablet ? 28 : 24,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: isTablet ? 20 : 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: isTablet ? 60 : 56,
            height: isTablet ? 60 : 56,
            decoration: BoxDecoration(
              color: Colors.amber[600],
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: isTablet ? 32 : 28,
              ),
              onPressed: () {
                // Navigate to NewPostPage
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;
    final isTablet = screenWidth > 600;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
                fontSize: isTablet ? 24 : 20,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            child: Text(
              'See All',
              style: TextStyle(
                color: Colors.amber[600],
                fontWeight: FontWeight.w600,
                fontSize: isTablet ? 18 : 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(var list_categories) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final cardWidth = isTablet ? 140.0 : 100.0;
    final cardHeight = isTablet ? 160.0 : 120.0;
    var categories = list_categories;
    return SizedBox(
      height: cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Container(
            width: cardWidth,
            margin: EdgeInsets.only(right: screenWidth * 0.04),
            child: GestureDetector(
              onTap: () {
                // Navigate to category workers
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isTablet ? 20 : 16),
                      decoration: BoxDecoration(
                        color: (cat['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        cat['icon'] as IconData,
                        size: isTablet ? 40 : 32,
                        color: cat['color'] as Color,
                      ),
                    ),
                    SizedBox(height: isTablet ? 12 : 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        cat['name'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWorkerSuggestions(var list_workers) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;
    final isTablet = screenWidth > 600;
    var workers = list_workers;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      itemCount: workers.length,
      itemBuilder: (context, index) {
        final worker = workers[index];
        final workerId = "${worker['_id']}";
        final isFavorite = _favoriteWorkers.contains(workerId);
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Row(
              children: [
                Container(
                  width: isTablet ? 100 : 80,
                  height: isTablet ? 100 : 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Colors.amber[300]!, Colors.amber[600]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: isTablet ? 50 : 40,
                  ),
                ),
                SizedBox(width: isTablet ? 20 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${worker['createdByName']}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 20 : 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isTablet ? 8 : 4),
                      Text(
                        "${worker['category']}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isTablet ? 16 : 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isTablet ? 12 : 8),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber[600],
                            size: isTablet ? 20 : 16,
                          ),
                          SizedBox(width: isTablet ? 6 : 4),
                          Text(
                            '${worker['ratingsAverage']}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: isTablet ? 16 : 14,
                            ),
                          ),
                          SizedBox(width: isTablet ? 6 : 4),
                        ],
                      ),
                      SizedBox(height: isTablet ? 8 : 4),
                      Row(
                        children: [
                          Text(
                            "${worker['startingPrice']}",
                            style: TextStyle(
                              color: Colors.amber[600],
                              fontWeight: FontWeight.w600,
                              fontSize: isTablet ? 16 : 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${worker['location']["type"]}',
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontSize: isTablet ? 12 : 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: isTablet ? 16 : 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red[400],
                        size: isTablet ? 28 : 24,
                      ),
                      onPressed: () {
                        setState(() {
                          if (isFavorite) {
                            _favoriteWorkers.remove(workerId);
                          } else {
                            _favoriteWorkers.add(workerId);
                          }
                        });
                      },
                    ),
                    SizedBox(height: isTablet ? 8 : 4),
                    ElevatedButton(
                      onPressed: () {
                        var workers = {
                          'name': '${worker['createdByName']}',
                          'job': '${worker['createdByName']}',
                          'rating': '${worker['ratingsAverage']}',
                          'price': '${worker['startingPrice']}',
                        };
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => OrderBookingPage(worker: workers),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[600],
                        foregroundColor: Colors.white,
                        minimumSize: Size(
                          isTablet ? 100 : 80,
                          isTablet ? 40 : 32,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Contact',
                        style: TextStyle(fontSize: isTablet ? 14 : 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
