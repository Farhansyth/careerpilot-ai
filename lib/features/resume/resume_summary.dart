import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

class ResumeSummaryScreen extends StatefulWidget {
  const ResumeSummaryScreen({super.key});

  @override
  State<ResumeSummaryScreen> createState() => _ResumeSummaryScreenState();
}

class _ResumeSummaryScreenState extends State<ResumeSummaryScreen> {
  final FirestoreService firestore = FirestoreService();

  final TextEditingController summaryController = TextEditingController();

  bool loading = false;
  bool initialLoading = true;

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
      debugPrint(e.toString());
    }

    if (mounted) {
      setState(() {
        initialLoading = false;
      });
    }
  }

  Future<void> saveSummary() async {
    if (summaryController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(e.toString())),
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
    if (initialLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Professional Summary"),

        backgroundColor: Colors.indigo,

        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Professional Summary",

              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "Write a concise ATS-friendly professional summary highlighting your experience, achievements, and career goals.",
            ),

            const SizedBox(height: 25),

            TextField(
              controller: summaryController,

              maxLines: 10,

              decoration: const InputDecoration(
                labelText: "Professional Summary",

                hintText:
                    "Example: Results-driven Software Engineer with 5+ years of experience...",

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

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
                    : const Text("Save Professional Summary"),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
