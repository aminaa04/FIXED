import 'package:flutter/material.dart';

class Review {
  final String id;
  final String name;
  final String date;
  int stars;
  final String review;
  int likes;
  bool likedByEmployee;

  Review({
    required this.id,
    required this.name,
    required this.date,
    required this.stars,
    required this.review,
    this.likes = 0,
    this.likedByEmployee = false,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    final id = '${map['name']}-${map['date']}-${map['stars']}';
    return Review(
      id: id,
      name: map['name'] as String,
      date: map['date'] as String,
      stars: map['stars'] as int,
      review: map['review'] as String,
      likes: map['likes'] as int? ?? 0,
      likedByEmployee: map['likedByEmployee'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'stars': stars,
      'review': review,
      'likes': likes,
      'likedByEmployee': likedByEmployee,
    };
  }
}

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});
  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final List<Review> allReviews = [
    Review.fromMap({
      'name': 'Amina Bouidarene',
      'date': '2025-04-24',
      'stars': 5,
      'review': 'Best service , thank you!',
      'likes': 6,
      'likedByEmployee': false,
    }),
    Review.fromMap({
      'name': 'Youssef K.',
      'date': '2025-04-23',
      'stars': 4,
      'review': 'employer tres competant ',
      'likes': 1,
      'likedByEmployee': true,
    }),
    Review.fromMap({
      'name': 'Amina B.',
      'date': '2025-04-22',
      'stars': 3,
      'review': '',
      'likes': 0,
      'likedByEmployee': false,
    }),
    Review.fromMap({
      'name': 'Nabil M.',
      'date': '2025-04-21',
      'stars': 5,
      'review': 'il y avait un peux de retard',
      'likes': 4,
      'likedByEmployee': false,
    }),
    Review.fromMap({
      'name': 'Lina D.',
      'date': '2025-04-20',
      'stars': 2,
      'review': 'bien',
      'likes': 3,
      'likedByEmployee': true,
    }),
    Review.fromMap({
      'name': 'Omar F.',
      'date': '2025-04-19',
      'stars': 4,
      'review': 'Très bon rapport qualité/prix.',
      'likes': 5,
      'likedByEmployee': true,
    }),
    Review.fromMap({
      'name': 'Fatima Z.',
      'date': '2025-04-18',
      'stars': 5,
      'review': 'Parfait, comme toujours.',
      'likes': 2,
      'likedByEmployee': false,
    }),
  ];
  String filterOption = 'All';
  static const int _initialVisibleCount = 3;
  int visibleCount = _initialVisibleCount;
  final List<String> filterOptionsList = ['All', 'By Stars', 'By Likes'];

  List<Review> get filteredReviews {
    List<Review> filtered = List.from(allReviews);
    switch (filterOption) {
      case 'By Stars':
        filtered.sort((a, b) {
          int starCompare = b.stars.compareTo(a.stars);
          if (starCompare != 0) return starCompare;
          return b.date.compareTo(a.date);
        });
        break;
      case 'By Likes':
        filtered.sort((a, b) {
          int likeCompare = b.likes.compareTo(a.likes);
          if (likeCompare != 0) return likeCompare;
          return b.date.compareTo(a.date);
        });
        break;
      case 'All':
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
    }
    return filtered;
  }

  void toggleLike(Review reviewToToggle) {
    final indexInAllReviews = allReviews.indexWhere(
      (r) => r.id == reviewToToggle.id,
    );
    if (indexInAllReviews != -1) {
      setState(() {
        final review = allReviews[indexInAllReviews];
        if (review.likedByEmployee) {
          review.likes--;
          review.likedByEmployee = false;
        } else {
          review.likes++;
          review.likedByEmployee = true;
        }
      });
    }
  }

  double calculateAverageRating() {
    if (allReviews.isEmpty) return 0;
    double total = allReviews.fold(0.0, (sum, review) => sum + review.stars);
    return total / allReviews.length;
  }

  Map<int, int> calculateRatingDistribution() {
    Map<int, int> distribution = {for (var i = 5; i >= 1; i--) i: 0};
    for (var review in allReviews) {
      distribution[review.stars] = (distribution[review.stars] ?? 0) + 1;
    }
    return distribution;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final horizontalPadding = screenWidth * 0.05;

    final averageRating = calculateAverageRating();
    final ratingDist = calculateRatingDistribution();
    final currentFilteredReviews = filteredReviews;
    final bool canShowMore = visibleCount < currentFilteredReviews.length;
    final bool canShowLess =
        visibleCount > _initialVisibleCount &&
        currentFilteredReviews.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.03),

            // Reviews Summary Card
            _buildSummaryCard(
              context,
              averageRating,
              ratingDist,
              horizontalPadding,
              isTablet,
            ),

            SizedBox(height: screenHeight * 0.03),

            // Filter Section
            _buildSectionTitle(context, "Filters", horizontalPadding, isTablet),
            SizedBox(height: screenHeight * 0.015),
            _buildFilterSection(horizontalPadding, isTablet),

            SizedBox(height: screenHeight * 0.03),

            // Reviews List
            _buildSectionTitle(
              context,
              "Reviews (${currentFilteredReviews.length})",
              horizontalPadding,
              isTablet,
            ),
            SizedBox(height: screenHeight * 0.015),

            if (currentFilteredReviews.isEmpty)
              _buildEmptyState(horizontalPadding, isTablet)
            else
              _buildReviewsList(
                currentFilteredReviews,
                horizontalPadding,
                isTablet,
              ),

            // View More/Less Buttons
            if (canShowMore || canShowLess)
              _buildViewMoreButtons(
                canShowMore,
                canShowLess,
                horizontalPadding,
                isTablet,
              ),

            SizedBox(height: screenHeight * 0.03),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    double averageRating,
    Map<int, int> ratingDist,
    double horizontalPadding,
    bool isTablet,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Container(
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
          padding: EdgeInsets.all(isTablet ? 24 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reviews Summary',
                style: TextStyle(
                  fontSize: isTablet ? 22 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: isTablet ? 20 : 16),

              // Rating section
              Row(
                children: [
                  Text(
                    averageRating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: isTablet ? 32 : 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(5, (i) {
                            double ratingFloor = averageRating;
                            IconData iconData;
                            if (i < ratingFloor.floor()) {
                              iconData = Icons.star;
                            } else if (i < ratingFloor.ceil() &&
                                (ratingFloor - i) > 0.2) {
                              iconData = Icons.star_half;
                            } else {
                              iconData = Icons.star_border;
                            }
                            return Icon(
                              iconData,
                              color: Colors.amber[600],
                              size: isTablet ? 24 : 20,
                            );
                          }),
                        ),
                        SizedBox(height: isTablet ? 8 : 4),
                        Text(
                          'Based on ${allReviews.length} reviews',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: isTablet ? 16 : 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 24 : 20),

              // Rating distribution
              for (int star = 5; star >= 1; star--)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: isTablet ? 4 : 2),
                  child: Row(
                    children: [
                      SizedBox(
                        width: isTablet ? 40 : 35,
                        child: Text(
                          '$star ★',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: isTablet ? 12 : 8),
                      Expanded(
                        child: LinearProgressIndicator(
                          value:
                              (ratingDist[star] ?? 0) /
                              (allReviews.isEmpty ? 1 : allReviews.length),
                          backgroundColor: Colors.grey[200],
                          color: Colors.amber[600],
                          minHeight: isTablet ? 8 : 6,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(width: isTablet ? 12 : 8),
                      SizedBox(
                        width: 30,
                        child: Text(
                          '${ratingDist[star] ?? 0}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    double horizontalPadding,
    bool isTablet,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
          fontSize: isTablet ? 24 : 20,
        ),
      ),
    );
  }

  Widget _buildFilterSection(double horizontalPadding, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Wrap(
        spacing: isTablet ? 12.0 : 8.0,
        runSpacing: 8.0,
        children:
            filterOptionsList.map((option) {
              final isSelected = filterOption == option;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    filterOption = option;
                    visibleCount = _initialVisibleCount;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 20 : 16,
                    vertical: isTablet ? 12 : 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.amber[600] : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(double horizontalPadding, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 40,
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: isTablet ? 80 : 60,
              color: Colors.grey[400],
            ),
            SizedBox(height: isTablet ? 16 : 12),
            Text(
              'No reviews found',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsList(
    List<Review> currentFilteredReviews,
    double horizontalPadding,
    bool isTablet,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      itemCount: visibleCount.clamp(0, currentFilteredReviews.length),
      itemBuilder: (context, index) {
        final review = currentFilteredReviews[index];
        return Container(
          margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Review header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: isTablet ? 60 : 50,
                      height: isTablet ? 60 : 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [Colors.amber[300]!, Colors.amber[600]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          review.name.isNotEmpty
                              ? review.name[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet ? 24 : 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: isTablet ? 16 : 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isTablet ? 18 : 16,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: isTablet ? 4 : 2),
                          Text(
                            review.date,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: isTablet ? 14 : 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < review.stars ? Icons.star : Icons.star_border,
                          color: Colors.amber[600],
                          size: isTablet ? 20 : 18,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: isTablet ? 16 : 12),

                // Review text
                if (review.review.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(
                      left: (isTablet ? 60 : 50) + (isTablet ? 16 : 12),
                    ),
                    child: Text(
                      review.review,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: isTablet ? 16 : 14,
                        height: 1.4,
                      ),
                    ),
                  ),

                if (review.review.isNotEmpty)
                  SizedBox(height: isTablet ? 16 : 12),

                // Like button
                Padding(
                  padding: EdgeInsets.only(
                    left: (isTablet ? 60 : 50) + (isTablet ? 16 : 12),
                  ),
                  child: GestureDetector(
                    onTap: () => toggleLike(review),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 16 : 12,
                        vertical: isTablet ? 8 : 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            review.likedByEmployee
                                ? Colors.red[50]
                                : Colors.grey[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              review.likedByEmployee
                                  ? Colors.red[200]!
                                  : Colors.grey[300]!,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            review.likedByEmployee
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                review.likedByEmployee
                                    ? Colors.red[400]
                                    : Colors.grey[600],
                            size: isTablet ? 20 : 18,
                          ),
                          SizedBox(width: isTablet ? 8 : 6),
                          Text(
                            '${review.likes}',
                            style: TextStyle(
                              color:
                                  review.likedByEmployee
                                      ? Colors.red[400]
                                      : Colors.grey[600],
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildViewMoreButtons(
    bool canShowMore,
    bool canShowLess,
    double horizontalPadding,
    bool isTablet,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: isTablet ? 24 : 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (canShowLess) ...[
            TextButton(
              onPressed: () {
                setState(() {
                  visibleCount = _initialVisibleCount;
                });
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 20,
                  vertical: isTablet ? 12 : 10,
                ),
              ),
              child: Text(
                'View Less',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: isTablet ? 16 : 12),
          ],
          if (canShowMore)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  visibleCount = (visibleCount + 3).clamp(
                    0,
                    filteredReviews.length,
                  );
                });
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
                elevation: 4,
              ),
              child: Text(
                'View More',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
