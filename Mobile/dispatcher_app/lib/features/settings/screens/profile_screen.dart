import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _service = ProfileService();

  late Future<UserProfile> _futureProfile;

  @override
  void initState() {
    super.initState();
    _futureProfile = _service.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
      body: FutureBuilder<UserProfile>(
        future: _futureProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final profile = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                const CircleAvatar(
                  radius: 55,
                  child: Icon(
                    Icons.person,
                    size: 60,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  profile.fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  profile.role,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                  ),
                ),

                const SizedBox(height: 30),

                Card(
                  elevation: 2,
                  child: Column(
                    children: [

                      ListTile(
                        leading: const Icon(Icons.badge),
                        title: const Text("User ID"),
                        subtitle: Text(profile.id.toString()),
                      ),

                      const Divider(height: 1),

                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text("Email"),
                        subtitle: Text(profile.email),
                      ),

                      const Divider(height: 1),

                      ListTile(
                        leading: const Icon(Icons.verified_user),
                        title: const Text("Role"),
                        subtitle: Text(profile.role),
                      ),

                      const Divider(height: 1),

                      ListTile(
                        leading: Icon(
                          profile.isActive
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: profile.isActive
                              ? Colors.green
                              : Colors.red,
                        ),
                        title: const Text("Status"),
                        subtitle: Text(
                          profile.isActive
                              ? "Active"
                              : "Inactive",
                        ),
                      ),

                      const Divider(height: 1),

                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: const Text("Member Since"),
                        subtitle: Text(
                          profile.createdAt.toLocal().toString(),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit Profile"),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Edit Profile will be implemented next.",
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}