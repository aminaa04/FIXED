import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_page/Provider/UserProvider.dart';
import 'package:screen_page/Screeen/User_screen/FavoritPage.dart';
import 'package:screen_page/Screeen/User_empl_screen/HomeUser.dart';
import 'package:screen_page/Screeen/User_screen/Notification.dart';
import 'package:screen_page/Screeen/User_screen/SearchPage.dart';
import 'package:screen_page/Screeen/employee_screen/Booking_screen.dart';
import 'package:screen_page/Screeen/employee_screen/Profile_screen.dart';
import 'package:screen_page/Screeen/employee_screen/Settings.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:screen_page/Screeen/employee_screen/reviews%20.dart';

class HomeEmployee extends StatefulWidget {
  const HomeEmployee({super.key});

  @override
  State<HomeEmployee> createState() => _MyappState();
}

class _MyappState extends State<HomeEmployee> {
  // Navigation items pour les travailleurs (worker)
  final items_worker = [
    Icon(Icons.home, size: 30, color: Colors.white),
    Icon(Icons.calendar_today, size: 30, color: Colors.white), // Booking
    Icon(Icons.reviews, size: 30, color: Colors.white),
    Icon(Icons.settings, size: 30, color: Colors.white),
  ];

  // Navigation items pour les clients
  final items_client = [
    Icon(Icons.home, size: 30, color: Colors.white),
    Icon(Icons.search, size: 30, color: Colors.white),
    Icon(Icons.favorite, size: 30, color: Colors.white),
    Icon(Icons.settings, size: 30, color: Colors.white),
  ];

  int index = 0; // Commencer par Home

  // Écrans pour les travailleurs
  final screens_worker = [
    Homeuser(), // Home
    Booking_screen(), // Booking
    ReviewsPage(), // Reviews
    ControlPage(), // Settings
  ];

  // Écrans pour les clients
  final screens_client = [
    Homeuser(), // Home
    SearchPage(), // Search
    FavoritesPage(), // Favoris
    ControlPage(), // Settings
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        bool isClientMode = userProvider.getisClientMode;

        return Scaffold(
          // AppBar en haut avec notifications et messages
          appBar: AppBar(
            backgroundColor: Colors.amber,
            elevation: 0,
            title: Text(
              isClientMode ? 'Client Dashboard' : 'Worker Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              // Icône des messages
              IconButton(
                onPressed: () {
                  // Naviguer vers la page des messages
                  _showMessagesDialog(context);
                },
                icon: Stack(
                  children: [
                    Icon(Icons.message, color: Colors.white, size: 26),
                    // Badge pour nouveaux messages (optionnel)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '3', // Nombre de nouveaux messages
                          style: TextStyle(color: Colors.white, fontSize: 8),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Icône des notifications
              IconButton(
                onPressed: () {
                  // Naviguer vers la page des notifications
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotifPage()),
                  );
                },
                icon: Stack(
                  children: [
                    Icon(Icons.notifications, color: Colors.white, size: 26),
                    // Badge pour nouvelles notifications
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '5', // Nombre de nouvelles notifications
                          style: TextStyle(color: Colors.white, fontSize: 8),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
            ],
          ),

          // Corps de l'application
          body: isClientMode ? screens_client[index] : screens_worker[index],

          // Navigation en bas
          bottomNavigationBar: CurvedNavigationBar(
            items: isClientMode ? items_client : items_worker,
            height: 60,
            backgroundColor: Colors.transparent,
            color: Colors.amber,
            buttonBackgroundColor: Colors.amber[600],
            index: index,
            onTap: (value) {
              setState(() {
                index = value;
              });
            },
          ),
        );
      },
    );
  }

  // Fonction pour afficher les messages
  void _showMessagesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Messages'),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: 3, // Nombre de messages
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: Text('${index + 1}'),
                  ),
                  title: Text('Message ${index + 1}'),
                  subtitle: Text('Contenu du message ${index + 1}...'),
                  trailing: Text('${index + 1}h'),
                  onTap: () {
                    Navigator.pop(context);
                    // Naviguer vers le détail du message
                    _openMessageDetail(context, index + 1);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fermer'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Naviguer vers la page complète des messages
                _openAllMessages(context);
              },
              child: Text('Voir tous'),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour ouvrir le détail d'un message
  void _openMessageDetail(BuildContext context, int messageId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message $messageId'),
          content: Text(
            'Contenu détaillé du message $messageId.\n\nCeci est un exemple de contenu de message plus long...',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fermer'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Fonction pour répondre au message
                _replyToMessage(context, messageId);
              },
              child: Text('Répondre'),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour répondre à un message
  void _replyToMessage(BuildContext context, int messageId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController replyController = TextEditingController();
        return AlertDialog(
          title: Text('Répondre au message $messageId'),
          content: TextField(
            controller: replyController,
            decoration: InputDecoration(
              hintText: 'Tapez votre réponse...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // Logique pour envoyer la réponse
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Réponse envoyée!')));
              },
              child: Text('Envoyer'),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour ouvrir tous les messages
  void _openAllMessages(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              appBar: AppBar(
                title: Text('Tous les messages'),
                backgroundColor: Colors.amber,
              ),
              body: ListView.builder(
                itemCount: 10, // Plus de messages
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.amber,
                        child: Text('${index + 1}'),
                      ),
                      title: Text('Message ${index + 1}'),
                      subtitle: Text('Contenu du message ${index + 1}...'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${index + 1}h'),
                          if (index < 3) // Marquer les 3 premiers comme non lus
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      onTap: () => _openMessageDetail(context, index + 1),
                    ),
                  );
                },
              ),
            ),
      ),
    );
  }
}
