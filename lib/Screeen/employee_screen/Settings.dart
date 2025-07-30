import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_page/Model/User.dart';
import 'package:screen_page/Provider/UserProvider.dart';
import 'package:screen_page/Screeen/auth_screen/Login.dart';
import 'package:screen_page/Screeen/employee_screen/EditProfilepage.dart';
import 'package:screen_page/service/Worker.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // State variables
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English'];
  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveSettings(String key, dynamic value) async {
    setState(() {
      switch (key) {
        case 'notifications':
          _notificationsEnabled = value;

          break;
        case 'location':
          _locationEnabled = value;

          break;

        case 'language':
          _selectedLanguage = value;

          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isClientMode =
        Provider.of<UserProvider>(context, listen: false).getisClientMode;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const _SettingsSectionHeader(title: 'App Preferences'),
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Receive alerts and updates'),
            value: _notificationsEnabled,
            activeColor: Colors.amber,
            onChanged: (value) => _saveSettings('notifications', value),
            secondary: const Icon(Icons.notifications),
          ),
          SwitchListTile(
            title: const Text('Location Services'),
            subtitle: const Text('Allow app to access your location'),
            value: _locationEnabled,
            activeColor: Colors.amber,
            onChanged: (value) => _saveSettings('location', value),
            secondary: const Icon(Icons.location_on),
          ),
          const Divider(),
          const _SettingsSectionHeader(title: 'Language'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Language',
                prefixIcon: Icon(Icons.language),
              ),
              value: _selectedLanguage,
              items:
                  _languages.map((language) {
                    return DropdownMenuItem(
                      value: language,
                      child: Text(language),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  _saveSettings('language', value);
                }
              },
            ),
          ),
          const Divider(),
          const _SettingsSectionHeader(title: 'Mode'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Select Mode',
                    prefixIcon: Icon(Icons.mode),
                  ),
                  value: userProvider.getisClientMode ? 'Client' : 'Worker',
                  items:
                      ['Client', 'Worker'].map((mode) {
                        return DropdownMenuItem<String>(
                          value: mode,
                          child: Text(mode),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      bool modeBool = (value == 'Client');
                      userProvider.SetisClientMode(modeBool);
                      // No need for setState here - Consumer will rebuild
                    }
                  },
                );
              },
            ),
          ),
          const Divider(),
          const _SettingsSectionHeader(title: 'Account'),
          ListTile(
            title: const Text('Delete Account'),
            subtitle: const Text('Permanently delete your account and data'),
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            onTap: () => _showDeleteAccountDialog(),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Account?'),
            content: const Text(
              'This action cannot be undone. All your data will be permanently deleted.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle account deletion logic
                  Navigator.pop(context);
                  _showAccountDeletedConfirmation();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('DELETE'),
              ),
            ],
          ),
    );
  }

  void _showAccountDeletedConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Account Deletion Initiated'),
            content: const Text(
              'Your account deletion process has started. You will receive a confirmation email shortly.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  User datauser =
                      Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).get_user;
                  String token =
                      Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).get_token;
                  Worker.deleteService(datauser.id, token);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}

// Custom section header widget
class _SettingsSectionHeader extends StatelessWidget {
  final String title;

  const _SettingsSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  // Control states
  bool darkModeEnabled = false;
  double volumeLevel = 0.7;
  double brightnessLevel = 0.5;
  String selectedLanguage = 'English';
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context, listen: false).get_user;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        foregroundColor: Colors.black,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 10),
          // User Profile Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    "assets/Images/avtarImag.jpg",
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        '${user.name}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '${user.email}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  onPressed: () {
                    // Edit profile action
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Editprofilpage()),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),
          Divider(height: 1, endIndent: 10, indent: 10),
          const SizedBox(height: 5),

          ListTile(
            title: const Text('Settings'),
            trailing: const Icon(Icons.chevron_right),
            leading: Icon(Icons.settings),
            onTap: () {
              // Open address selection
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => Settings()));
            },
          ),
          const SizedBox(height: 5),
          Divider(height: 1, endIndent: 10, indent: 10),
          const SizedBox(height: 5),
          ListTile(
            title: const Text('help'),
            trailing: const Icon(Icons.chevron_right),
            leading: Icon(Icons.help),
            onTap: () {
              // Open address selection
            },
          ),
          // Audio Section
          const SizedBox(height: 5),
          Divider(height: 1, endIndent: 10, indent: 10),
          const SizedBox(height: 5),
          ListTile(
            title: const Text('logout'),
            trailing: const Icon(Icons.chevron_right),
            leading: Icon(Icons.logout),
            onTap: () {
              // Open address selection
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Log_out?'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'LOG_OUT',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
              );
            },
          ),
          const SizedBox(height: 5),
          Divider(height: 1, endIndent: 10, indent: 10),
        ],
      ),
    );
  }
}
