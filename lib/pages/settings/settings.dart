import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SectionHeader(title: "Account"),
          SettingsTile(
            icon: Icons.person,
            title: "Profile",
            onTap: () {
              // Navigate to profile settings
            },
          ),
          SettingsTile(
            icon: Icons.lock,
            title: "Change Password",
            onTap: () {
              // Navigate to change password screen
            },
          ),
          const Divider(),
          const SectionHeader(title: "Biometrics"),
          SwitchTile(
            icon: Icons.fingerprint,
            title: "Enable Biometric Login",
            value: true,
            onChanged: (bool value) {
              // Handle biometric toggle
            },
          ),
          const Divider(),
          const SectionHeader(title: "App Settings"),
          SettingsTile(
            icon: Icons.notifications,
            title: "Notifications",
            onTap: () {
              // Navigate to notification settings
            },
          ),
          SettingsTile(
            icon: Icons.dark_mode,
            title: "Dark Mode",
            onTap: () {
              // Toggle dark mode
            },
          ),
          SettingsTile(
            icon: Icons.language,
            title: "Language",
            onTap: () {
              // Navigate to language settings
            },
          ),
          const Divider(),
          const SectionHeader(title: "Support"),
          SettingsTile(
            icon: Icons.help,
            title: "Help & Support",
            onTap: () {
              // Navigate to help & support screen
            },
          ),
          SettingsTile(
            icon: Icons.info,
            title: "About",
            onTap: () {
              // Navigate to about screen
            },
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
      onTap: onTap,
    );
  }
}

class SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.deepPurple,
      ),
    );
  }
}
