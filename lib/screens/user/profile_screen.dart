// lib/screens/user/profile_screen.dart
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required bool isCustomer}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _picker = ImagePicker();
  bool _isEditing = false;
  bool _isLoading = false;
  late User _currentUser;
  late Map<String, dynamic> _userData;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    _userData = {
      'name': '',
      'email': _currentUser.email,
      'phone': '',
      'bio': '',
      'photoUrl': _currentUser.photoURL,
    };
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final doc = await _firestore.collection('users').doc(_currentUser.uid).get();
      if (doc.exists) {
        setState(() {
          _userData = doc.data()!;
          _nameController.text = _userData['name'] ?? '';
          _phoneController.text = _userData['phone'] ?? '';
          _bioController.text = _userData['bio'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _firestore.collection('users').doc(_currentUser.uid).update({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'bio': _bioController.text,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      setState(() {
        _isEditing = false;
        _userData = {
          ..._userData,
          'name': _nameController.text,
          'phone': _phoneController.text,
          'bio': _bioController.text,
        };
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _changeProfilePicture(dynamic ImageSource) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      setState(() => _isLoading = true);
      // Here you would typically upload to Firebase Storage
      // and update the user's photoURL
      // This is a simplified version:
      setState(() {
        _userData['photoUrl'] = pickedFile.path; // Temporary local path
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      Navigator.pushNamedAndRemoveUntil(
        context, 
        '/login', 
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
          if (_isEditing)
            TextButton(
              onPressed: _updateProfile,
              child: const Text('SAVE'),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile Picture
                  GestureDetector(
                    onTap: _isEditing
                        ? () => _changeProfilePicture(ImageSource)
                        : null,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _userData['photoUrl'] != null
                              ? NetworkImage(_userData['photoUrl']!)
                              : const AssetImage('assets/default_avatar.png')
                                  as ImageProvider,
                        ),
                        if (_isEditing)
                          const CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.edit, size: 18, color: Colors.white),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Profile Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Name Field
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: Icon(Icons.person),
                          ),
                          enabled: _isEditing,
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter your name' : null,
                        ),
                        const SizedBox(height: 16),

                        // Email Field (read-only)
                        TextFormField(
                          initialValue: _userData['email'],
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                          enabled: false,
                        ),
                        const SizedBox(height: 16),

                        // Phone Field
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            prefixIcon: Icon(Icons.phone),
                          ),
                          enabled: _isEditing,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),

                        // Bio Field
                        TextFormField(
                          controller: _bioController,
                          decoration: const InputDecoration(
                            labelText: 'About Me',
                            prefixIcon: Icon(Icons.info),
                          ),
                          enabled: _isEditing,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Logout Button
                  if (!_isEditing)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _logout,
                        child: const Text('LOG OUT'),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}

mixin ImageSource {
}