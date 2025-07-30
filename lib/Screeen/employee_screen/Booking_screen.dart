import 'package:flutter/material.dart';

class Booking_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Booking App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Roboto',
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      home: MainPage(),
    );
  }
}

class Booking {
  final String clientName;
  final String time;
  String status;

  Booking(this.clientName, this.time, this.status);
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 2;
  List<Booking> bookings = [
    Booking('Sarah James', '2025-06-15 at 10:00 AM', 'pending'),
    Booking('Michael Smith', '2025-06-15 at 11:30 AM', 'pending'),
    Booking('Anna Brown', '2025-06-16 at 09:00 AM', 'confirmed'),
    Booking('John Doe', '2025-06-16 at 02:00 PM', 'completed'),
  ];

  void updateStatus(Booking booking, String newStatus) {
    setState(() {
      booking.status = newStatus;
    });
  }

  int countStatus(String status) =>
      bookings.where((b) => b.status == status).length;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get pages => [
    Center(child: Text('Profile')),
    Center(child: Text('Reviews')),
    BookingPage(
      bookings: bookings,
      updateStatus: updateStatus,
      countStatus: countStatus,
    ),
    Center(child: Text('Settings')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: BookingPage(
        bookings: bookings,
        updateStatus: updateStatus,
        countStatus: countStatus,
      ),
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(30),
      //       topRight: Radius.circular(30),
      //     ),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.05),
      //         blurRadius: 10,
      //         offset: Offset(0, -5),
      //       ),
      //     ],
      //   ),
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(vertical: 10),
      //     child: BottomNavigationBar(
      //       backgroundColor: Colors.transparent,
      //       elevation: 0,
      //       currentIndex: _selectedIndex,
      //       onTap: _onItemTapped,
      //       selectedItemColor: Color(0xFF2A5BD7), // Professional blue
      //       unselectedItemColor: Colors.grey.shade400,
      //       showUnselectedLabels: true,
      //       type: BottomNavigationBarType.fixed,
      //       items: const [
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.person),
      //           label: 'Profile',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.reviews),
      //           label: 'Reviews',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.calendar_today),
      //           label: 'Booking',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.settings),
      //           label: 'Settings',
      //         ),
      //       ],
      //     ),
    );
  }
}

class BookingPage extends StatelessWidget {
  final List<Booking> bookings;
  final Function(Booking, String) updateStatus;
  final int Function(String) countStatus;

  // Professional color scheme
  final Color pendingColor = Color(0xFFE67E22); // Amber
  final Color confirmedColor = Color(0xFF2A5BD7); // Blue
  final Color completedColor = Color(0xFF27AE60); // Green
  final Color canceledColor = Color(0xFFE74C3C); // Red

  // Section colors for headers
  final Color confirmedSectionColor = Color(0xFF2A5BD7); // Blue
  final Color completedSectionColor = Color(0xFF27AE60); // Green
  final Color otherSectionColor = Color(0xFF9B59B6); // Purple

  BookingPage({
    required this.bookings,
    required this.updateStatus,
    required this.countStatus,
  });

  Widget buildStatusCard(String label, int count, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
          SizedBox(height: 4),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBookingItem(Booking booking) {
    Color statusColor;
    IconData? actionIcon;
    String? actionLabel;
    VoidCallback? action;

    switch (booking.status) {
      case 'pending':
        statusColor = pendingColor;
        actionIcon = Icons.check_circle;
        actionLabel = 'Confirm';
        action = () => updateStatus(booking, 'confirmed');
        break;
      case 'confirmed':
        statusColor = confirmedColor;
        actionIcon = Icons.done_all;
        actionLabel = 'Complete';
        action = () => updateStatus(booking, 'completed');
        break;
      case 'completed':
        statusColor = completedColor;
        break;
      case 'canceled':
        statusColor = canceledColor;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: statusColor.withOpacity(0.4), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking.clientName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    booking.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Text(
                  booking.time,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
            SizedBox(height: 15),
            if (actionIcon != null ||
                booking.status != 'completed' && booking.status != 'canceled')
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (actionIcon != null)
                    ElevatedButton.icon(
                      icon: Icon(actionIcon, size: 16),
                      label: Text(actionLabel!),
                      onPressed: action,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: statusColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  if (booking.status != 'completed' &&
                      booking.status != 'canceled')
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.cancel, size: 16),
                        label: Text('Cancel'),
                        onPressed: () => updateStatus(booking, 'canceled'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: canceledColor,
                          side: BorderSide(
                            color: canceledColor.withOpacity(0.5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionHeader(String title, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
              margin: EdgeInsets.only(right: 10),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: Text('See All'),
          style: TextButton.styleFrom(
            foregroundColor: color,
            textStyle: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Booking Status',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 247, 182, 2),
                ),
              ),
              SizedBox(height: 15),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
                children: [
                  buildStatusCard(
                    'Pending',
                    countStatus('pending'),
                    pendingColor,
                    Icons.access_time,
                  ),
                  buildStatusCard(
                    'Confirmed',
                    countStatus('confirmed'),
                    confirmedColor,
                    Icons.verified,
                  ),
                  buildStatusCard(
                    'Completed',
                    countStatus('completed'),
                    completedColor,
                    Icons.check_circle,
                  ),
                  buildStatusCard(
                    'Canceled',
                    countStatus('canceled'),
                    canceledColor,
                    Icons.cancel,
                  ),
                ],
              ),
              SizedBox(height: 30),
              if (bookings.any((b) => b.status == 'confirmed')) ...[
                buildSectionHeader('Confirmed Bookings', confirmedSectionColor),
                SizedBox(height: 10),
                ...bookings
                    .where((b) => b.status == 'confirmed')
                    .map(buildBookingItem),
                SizedBox(height: 25),
              ],
              if (bookings.any((b) => b.status == 'completed')) ...[
                buildSectionHeader('Completed Bookings', completedSectionColor),
                SizedBox(height: 10),
                ...bookings
                    .where((b) => b.status == 'completed')
                    .map(buildBookingItem),
                SizedBox(height: 25),
              ],
              if (bookings.any(
                (b) => b.status == 'pending' || b.status == 'canceled',
              )) ...[
                buildSectionHeader('Other Bookings', otherSectionColor),
                SizedBox(height: 10),
                ...bookings
                    .where(
                      (b) => b.status == 'pending' || b.status == 'canceled',
                    )
                    .map(buildBookingItem),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
