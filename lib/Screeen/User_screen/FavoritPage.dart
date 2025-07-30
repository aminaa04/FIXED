import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> favorites = [
    {
      'id': '1',
      'name': 'Ahmed Ben Ali',
      'job': 'Plumber',
      'rating': 4.5,
      'reviews': 127,
      'price': '250 DA/h',
    },
    {
      'id': '2',
      'name': 'Ahmed Mansouri',
      'job': 'Electrician',
      'rating': 4.8,
      'reviews': 89,
      'price': '300 DA/h',
    },
    {
      'id': '3',
      'name': 'Yacine',
      'job': 'Repair & Maintenance',
      'rating': 4.2,
      'reviews': 64,
      'price': '200 DA/h',
    },
    {
      'id': '4',
      'name': 'Fatima Zahra',
      'job': 'Housekeeper',
      'rating': 4.9,
      'reviews': 203,
      'price': '180 DA/h',
    },
    {
      'id': '5',
      'name': 'Karim Benali',
      'job': 'Painter',
      'rating': 4.6,
      'reviews': 156,
      'price': '220 DA/h',
    },
  ];

  void _removeFavorite(String workerId) {
    setState(() {
      favorites.removeWhere((worker) => worker['id'] == workerId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Removed from favorites'),
        backgroundColor: Colors.amber[600],
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _contactWorker(Map<String, dynamic> worker) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contact ${worker['name']}'),
        backgroundColor: Colors.green[600],
        duration: const Duration(seconds: 2),
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
          if (favorites.isNotEmpty)
            Text(
              '${favorites.length} worker${favorites.length > 1 ? 's' : ''}',
              style: TextStyle(
                color: Colors.amber[600],
                fontWeight: FontWeight.w600,
                fontSize: isTablet ? 18 : 16,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFavoriteWorkers() {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;
    final isTablet = screenWidth > 600;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final worker = favorites[index];
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
                        worker['name'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 20 : 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isTablet ? 8 : 4),
                      Text(
                        worker['job'] as String,
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
                            '${worker['rating']}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: isTablet ? 16 : 14,
                            ),
                          ),
                          SizedBox(width: isTablet ? 6 : 4),
                          Flexible(
                            child: Text(
                              '(${worker['reviews']} reviews)',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: isTablet ? 14 : 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 8 : 4),
                      Text(
                        worker['price'] as String,
                        style: TextStyle(
                          color: Colors.amber[600],
                          fontWeight: FontWeight.w600,
                          fontSize: isTablet ? 16 : 14,
                        ),
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
                        Icons.favorite,
                        color: Colors.red[400],
                        size: isTablet ? 28 : 24,
                      ),
                      onPressed: () {
                        _removeFavorite(worker['id'] as String);
                      },
                    ),
                    SizedBox(height: isTablet ? 8 : 4),
                    ElevatedButton(
                      onPressed: () {
                        _contactWorker(worker);
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

  Widget _buildEmptyState() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isTablet ? 120 : 100,
              height: isTablet ? 120 : 100,
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.favorite_outline,
                size: isTablet ? 60 : 50,
                color: Colors.amber[400],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: isTablet ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.015),
            Text(
              'Add workers to your favorites\nto find them easily',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: isTablet ? 18 : 16,
                height: 1.5,
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[600],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 24,
                  vertical: isTablet ? 16 : 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Discover workers',
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body:
          favorites.isEmpty
              ? _buildEmptyState()
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.03),
                    _buildSectionTitle(context, "My Favorite Workers"),
                    SizedBox(height: screenHeight * 0.015),
                    _buildFavoriteWorkers(),
                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),
    );
  }
}
