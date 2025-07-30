import 'package:flutter/material.dart';

class NotifPage extends StatefulWidget {
  const NotifPage({super.key});

  @override
  State<NotifPage> createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  List<Map<String, dynamic>> notifications = [
    {
      'id': '1',
      'workerName': 'Ahmed Ben Ali',
      'workerJob': 'Plumber',
      'message': 'Your request has been accepted!',
      'status': 'accepted',
      'date': 'May 24, 2025',
      'time': '2:30 PM',
      'isRead': false,
    },
    {
      'id': '2',
      'workerName': 'Ahmed Mansouri',
      'workerJob': 'Electrician',
      'message': 'Your request is waiting for confirmation.',
      'status': 'pending',
      'date': 'May 23, 2025',
      'time': '10:15 AM',
      'isRead': false,
    },
    {
      'id': '3',
      'workerName': 'Yacine',
      'workerJob': 'Repair & Maintenance',
      'message': 'Your request has been rejected. The worker is not available.',
      'status': 'rejected',
      'date': 'May 22, 2025',
      'time': '4:45 PM',
      'isRead': true,
    },
    {
      'id': '4',
      'workerName': 'Fatima Zahra',
      'workerJob': 'Housekeeper',
      'message': 'Your request has been accepted!',
      'status': 'accepted',
      'date': 'May 21, 2025',
      'time': '9:20 AM',
      'isRead': true,
    },
    {
      'id': '5',
      'workerName': 'Karim Benali',
      'workerJob': 'Painter',
      'message': 'Your request is being processed.',
      'status': 'pending',
      'date': 'May 20, 2025',
      'time': '11:30 AM',
      'isRead': true,
    },
  ];

  void _markAsRead(String notificationId) {
    setState(() {
      final index = notifications.indexWhere(
        (notif) => notif['id'] == notificationId,
      );
      if (index != -1) {
        notifications[index]['isRead'] = true;
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notif in notifications) {
        notif['isRead'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All notifications marked as read'),
        backgroundColor: Colors.amber[600],
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteNotification(String notificationId) {
    setState(() {
      notifications.removeWhere((notif) => notif['id'] == notificationId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification deleted'),
        backgroundColor: Colors.red[400],
        duration: const Duration(seconds: 2),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'accepted':
        return Icons.check_circle;
      case 'pending':
        return Icons.hourglass_top;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.notifications;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'accepted':
        return 'Accepted';
      case 'pending':
        return 'Pending';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  Widget _buildSectionTitle(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;
    final isTablet = screenWidth > 600;
    final unreadCount = notifications.where((notif) => !notif['isRead']).length;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    fontSize: isTablet ? 24 : 20,
                  ),
                ),
                if (unreadCount > 0)
                  Text(
                    '$unreadCount new notification${unreadCount > 1 ? 's' : ''}',
                    style: TextStyle(
                      color: Colors.amber[600],
                      fontWeight: FontWeight.w600,
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
              ],
            ),
          ),
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Mark all as read',
                style: TextStyle(
                  color: Colors.amber[600],
                  fontWeight: FontWeight.w600,
                  fontSize: isTablet ? 16 : 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;
    final isTablet = screenWidth > 600;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final isRead = notification['isRead'] as bool;

        return Dismissible(
          key: Key(notification['id']),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.red[400],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.delete, color: Colors.white, size: 28),
          ),
          onDismissed: (direction) {
            _deleteNotification(notification['id']);
          },
          child: GestureDetector(
            onTap: () {
              if (!isRead) {
                _markAsRead(notification['id']);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isRead ? Colors.white : Colors.amber[50],
                borderRadius: BorderRadius.circular(16),
                border:
                    isRead
                        ? null
                        : Border.all(color: Colors.amber[200]!, width: 1),
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
                    Row(
                      children: [
                        Container(
                          width: isTablet ? 60 : 50,
                          height: isTablet ? 60 : 50,
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              notification['status'],
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getStatusIcon(notification['status']),
                            color: _getStatusColor(notification['status']),
                            size: isTablet ? 30 : 24,
                          ),
                        ),
                        SizedBox(width: isTablet ? 16 : 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      notification['workerName'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: isTablet ? 18 : 16,
                                        color: Colors.grey[800],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isTablet ? 12 : 8,
                                      vertical: isTablet ? 6 : 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(
                                        notification['status'],
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _getStatusText(notification['status']),
                                      style: TextStyle(
                                        color: _getStatusColor(
                                          notification['status'],
                                        ),
                                        fontWeight: FontWeight.w600,
                                        fontSize: isTablet ? 12 : 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: isTablet ? 4 : 2),
                              Text(
                                notification['workerJob'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: isTablet ? 14 : 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: isTablet ? 12 : 10,
                            height: isTablet ? 12 : 10,
                            decoration: BoxDecoration(
                              color: Colors.amber[600],
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: isTablet ? 16 : 12),
                    Text(
                      notification['message'],
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: isTablet ? 16 : 14,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: isTablet ? 12 : 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.grey[500],
                          size: isTablet ? 18 : 16,
                        ),
                        SizedBox(width: isTablet ? 6 : 4),
                        Text(
                          '${notification['date']} at ${notification['time']}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: isTablet ? 14 : 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                Icons.notifications_none,
                size: isTablet ? 60 : 50,
                color: Colors.amber[400],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              'No notifications',
              style: TextStyle(
                fontSize: isTablet ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.015),
            Text(
              'You will receive notifications\nwhen your requests are processed',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: isTablet ? 18 : 16,
                height: 1.5,
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
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: isTablet ? 24 : 20,
          ),
        ),
        backgroundColor: Colors.amber[600],
        actions: [
          if (notifications.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.delete_sweep_outlined,
                color: Colors.white,
                size: isTablet ? 28 : 24,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete all notifications'),
                      content: const Text(
                        'Are you sure you want to delete all notifications?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              notifications.clear();
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red[600]),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
        ],
      ),
      body:
          notifications.isEmpty
              ? _buildEmptyState()
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.03),
                    _buildSectionTitle(context),
                    SizedBox(height: screenHeight * 0.015),
                    _buildNotificationsList(),
                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),
    );
  }
}
