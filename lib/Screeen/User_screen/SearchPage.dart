import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_page/Provider/UserProvider.dart';
import 'package:screen_page/Screeen/User_screen/ManageServicesPage.dart';
import 'package:screen_page/Screeen/User_screen/OrderBookingPage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _favoriteWorkers = [];

  bool showCategories = false;
  String searchQuery = '';
  String selectedCategory = '';
  String selectedWilaya = 'All regions';

  final List<String> wilayas = [
    'All regions',
    'Adrar',
    'Chlef',
    'Laghouat',
    'Oum El Bouaghi',
    'Batna',
    'Béjaïa',
    'Biskra',
    'Béchar',
    'Blida',
    'Bouira',
    'Tamanrasset',
    'Tébessa',
    'Tlemcen',
    'Tiaret',
    'Tizi Ouzou',
    'Alger',
    'Djelfa',
    'Jijel',
    'Sétif',
    'Saïda',
    'Skikda',
    'Sidi Bel Abbès',
    'Annaba',
    'Guelma',
    'Constantine',
    'Médéa',
    'Mostaganem',
    'M\'Sila',
    'Mascara',
    'Ouargla',
    'Oran',
    'El Bayadh',
    'Illizi',
    'Bordj Bou Arréridj',
    'Boumerdès',
    'El Tarf',
    'Tindouf',
    'Tissemsilt',
    'El Oued',
    'Khenchela',
    'Souk Ahras',
    'Tipaza',
    'Mila',
    'Aïn Defla',
    'Naâma',
    'Aïn Témouchent',
    'Ghardaïa',
    'Relizane',
  ];

  final List<Map<String, dynamic>> categories = [
    {'name': 'Plumbing', 'icon': Icons.plumbing, 'color': Colors.blue[400]},
    {
      'name': 'Electricity',
      'icon': Icons.electrical_services,
      'color': Colors.orange[400],
    },
    {
      'name': 'Cleaning',
      'icon': Icons.cleaning_services,
      'color': Colors.green[400],
    },
    {
      'name': 'Painting',
      'icon': Icons.format_paint,
      'color': Colors.purple[400],
    },
    {'name': 'Carpentry', 'icon': Icons.carpenter, 'color': Colors.brown[400]},

    {'name': 'Repair', 'icon': Icons.build, 'color': Colors.red[400]},
    {
      'name': 'Air Conditioning',
      'icon': Icons.ac_unit,
      'color': Colors.cyan[400],
    },
  ];
  get filteredWorkers {
    var allServices =
        Provider.of<UserProvider>(context, listen: false).getallservise;
    var filtered =
        allServices.where((worker) {
          bool matchesSearch =
              searchQuery.isEmpty
                  ? worker['createdByName'].toString().toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  )
                  : worker['category'].toString().toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  );

          bool matchesCategory =
              selectedCategory.isEmpty ||
              worker['category'] == selectedCategory;

          bool matchesWilaya =
              (selectedWilaya == 'All regions') ||
              worker['location']["type"] == selectedWilaya;

          return matchesSearch && matchesCategory && matchesWilaya;
        }).toList();

    // Sort by descending rating
    filtered.sort(
      (a, b) => (b['ratingsAverage'] as double).compareTo(
        a['ratingsAverage'] as double,
      ),
    );
    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void selectCategory(String category) {
    setState(() {
      selectedCategory = selectedCategory == category ? '' : category;
      showCategories = false;
    });
  }

  void _clearAllFilters() {
    setState(() {
      _searchController.clear();
      searchQuery = '';
      selectedCategory = '';
      selectedWilaya = 'All regions';
      showCategories = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('All filters cleared')));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add some top padding to replace the AppBar space
            SizedBox(height: screenHeight * 0.02),

            _buildSearchAndPostBar(context),

            // Display categories if enabled
            if (showCategories) _buildCategoriesGrid(context),

            SizedBox(height: screenHeight * 0.02),

            // Show active filters chips
            if (selectedCategory.isNotEmpty || selectedWilaya != 'All regions')
              _buildActiveFiltersChips(context),

            _buildFilterRow(context),
            SizedBox(height: screenHeight * 0.03),
            _buildSectionTitle(
              context,
              "Search Results (${filteredWorkers.length})",
            ),
            SizedBox(height: screenHeight * 0.015),
            _buildWorkersList(),
            SizedBox(height: screenHeight * 0.03),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndPostBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;
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
                controller: _searchController,
                onTap: () {
                  setState(() {
                    showCategories = !showCategories;
                  });
                },
                style: TextStyle(fontSize: isTablet ? 18 : 16),
                decoration: InputDecoration(
                  hintText: 'Search for a service...',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: isTablet ? 18 : 16,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                    size: isTablet ? 28 : 24,
                  ),
                  suffixIcon:
                      searchQuery.isNotEmpty
                          ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey[600]),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                          : Icon(
                            showCategories
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.grey[600],
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Create new post')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;
    final isTablet = screenWidth > 600;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isTablet ? 4 : 2,
            childAspectRatio: isTablet ? 2.5 : 2.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = selectedCategory == category['name'];

            return GestureDetector(
              onTap: () => selectCategory(category['name'] as String),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.amber[50] : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.amber[600]! : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category['icon'] as IconData,
                      size: isTablet ? 24 : 20,
                      color:
                          isSelected
                              ? Colors.amber[600]
                              : category['color'] as Color,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        category['name'] as String,
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color:
                              isSelected ? Colors.amber[700] : Colors.grey[700],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActiveFiltersChips(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;
    final isTablet = screenWidth > 600;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Filters:',
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (selectedCategory.isNotEmpty)
                Chip(
                  label: Text(
                    'Category: $selectedCategory',
                    style: TextStyle(fontSize: isTablet ? 14 : 12),
                  ),
                  deleteIcon: Icon(Icons.close, size: isTablet ? 20 : 16),
                  onDeleted: () {
                    setState(() {
                      selectedCategory = '';
                    });
                  },
                  backgroundColor: Colors.amber[50],
                  deleteIconColor: Colors.amber[700],
                ),
              if (selectedWilaya != 'All regions')
                Chip(
                  label: Text(
                    'Region: $selectedWilaya',
                    style: TextStyle(fontSize: isTablet ? 14 : 12),
                  ),
                  deleteIcon: Icon(Icons.close, size: isTablet ? 20 : 16),
                  onDeleted: () {
                    setState(() {
                      selectedWilaya = 'All regions';
                    });
                  },
                  backgroundColor: Colors.blue[50],
                  deleteIconColor: Colors.blue[700],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;
    final isTablet = screenWidth > 600;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButton<String>(
                value: selectedWilaya,
                isExpanded: true,
                underline: const SizedBox(),
                icon: Icon(Icons.location_on, color: Colors.amber[600]),
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  color: Colors.grey[700],
                ),
                items:
                    wilayas
                        .map(
                          (wilaya) => DropdownMenuItem(
                            value: wilaya,
                            child: Text(wilaya),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedWilaya = value!;
                  });
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.amber[600],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageServicesPage()),
                );
              },
              icon: Icon(Icons.add, size: isTablet ? 20 : 18),
              label: Text(
                "Add Service",
                style: TextStyle(fontSize: isTablet ? 16 : 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[600],
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 20 : 16,
                  vertical: isTablet ? 16 : 12,
                ),
              ),
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
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
          fontSize: isTablet ? 24 : 20,
        ),
      ),
    );
  }

  Widget _buildWorkersList() {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;
    final isTablet = screenWidth > 600;
    if (filteredWorkers.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: isTablet ? 80 : 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try modifying your search criteria',
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      itemCount: filteredWorkers.length,
      itemBuilder: (context, index) {
        final worker = filteredWorkers[index];
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Contact ${worker['createdByName']}'),
                          ),
                        );
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
