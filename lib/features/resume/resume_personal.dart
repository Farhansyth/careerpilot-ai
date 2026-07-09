import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

class ResumePersonalScreen extends StatefulWidget {
  const ResumePersonalScreen({super.key});

  @override
  State<ResumePersonalScreen> createState() => _ResumePersonalScreenState();
}

class _ResumePersonalScreenState extends State<ResumePersonalScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  final fullName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final city = TextEditingController();
  final linkedin = TextEditingController();

  bool _loading = false;
  bool _initialLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  Future<void> _loadExistingData() async {
    try {
      final data = await _firestoreService.getPersonalInformation();

      if (data != null) {
        fullName.text = data["fullName"] ?? "";
        email.text = data["email"] ?? "";
        phone.text = data["phone"] ?? "";
        city.text = data["address"] ?? "";
        linkedin.text = data["linkedin"] ?? "";
      }
    } catch (e) {
      debugPrint("Error loading personal information: $e");
    }

    if (mounted) {
      setState(() {
        _initialLoading = false;
      });
    }
  }

  Future<void> _savePersonalInformation() async {
    setState(() {
      _loading = true;
    });

    try {
      await _firestoreService.savePersonalInformation(
        fullName: fullName.text.trim(),
        jobTitle: "",
        email: email.text.trim(),
        phone: phone.text.trim(),
        address: city.text.trim(),
        linkedin: linkedin.text.trim(),
        github: "",
        portfolio: "",
        summary: "",
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Personal Information Saved"),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text("Save Failed: $e")),
      );
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    fullName.dispose();
    email.dispose();
    phone.dispose();
    city.dispose();
    linkedin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Information"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: _initialLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  TextField(
                    controller: fullName,
                    decoration: const InputDecoration(labelText: "Full Name"),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: email,
                    decoration: const InputDecoration(labelText: "Email"),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: phone,
                    decoration: const InputDecoration(labelText: "Phone"),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: city,
                    decoration: const InputDecoration(labelText: "City"),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: linkedin,
                    decoration: const InputDecoration(labelText: "LinkedIn"),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _savePersonalInformation,
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text("Save"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
