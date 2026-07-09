import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

class ProfessionalSummaryScreen extends StatefulWidget {
  const ProfessionalSummaryScreen({super.key});

  @override
  State<ProfessionalSummaryScreen> createState() =>
      _ProfessionalSummaryScreenState();
}

class _ProfessionalSummaryScreenState extends State<ProfessionalSummaryScreen> {
  final FirestoreService firestore = FirestoreService();

  final TextEditingController summaryController = TextEditingController();

  bool loading = false;
  bool pageLoading = true;

  @override
  void initState() {
    super.initState();
    loadSummary();
  }

  Future<void> loadSummary() async {
    try {
      final data = await firestore.getProfessionalSummary();

      if (data != null) {
        summaryController.text = data["summary"] ?? "";
      }
    } catch (e) {
      debugPrint("LOAD ERROR: $e");
    }

    if (mounted) {
      setState(() {
        pageLoading = false;
      });
    }
  }

  Future<void> saveSummary() async {
    if (summaryController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text("Please enter your professional summary."),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await firestore.saveProfessionalSummary(
        summary: summaryController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Professional Summary Saved Successfully"),
        ),
      );
    } catch (e) {
      debugPrint("SAVE ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text("Save Failed\n$e")),
      );
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Professional Summary"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: pageLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: summaryController,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      labelText: "Professional Summary",
                      hintText: "Write your professional summary...",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: loading ? null : saveSummary,
                      child: loading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Save Summary",
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
