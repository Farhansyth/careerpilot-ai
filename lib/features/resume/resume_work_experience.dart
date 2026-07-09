import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

class ResumeWorkExperienceScreen extends StatefulWidget {
  const ResumeWorkExperienceScreen({super.key});

  @override
  State<ResumeWorkExperienceScreen> createState() =>
      _ResumeWorkExperienceScreenState();
}

class _ResumeWorkExperienceScreenState
    extends State<ResumeWorkExperienceScreen> {
  final FirestoreService firestore = FirestoreService();

  bool loading = true;
  bool saving = false;

  List<Map<String, dynamic>> experiences = [];

  @override
  void initState() {
    super.initState();
    loadExperiences();
  }

  Future<void> loadExperiences() async {
    try {
      experiences = await firestore.getWorkExperience();

      if (experiences.isEmpty) {
        experiences.add({
          "jobTitle": "",
          "company": "",
          "location": "",
          "startDate": "",
          "endDate": "",
          "currentlyWorking": false,
          "description": "",
        });
      }
    } catch (e) {
      debugPrint(e.toString());

      experiences = [
        {
          "jobTitle": "",
          "company": "",
          "location": "",
          "startDate": "",
          "endDate": "",
          "currentlyWorking": false,
          "description": "",
        },
      ];
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  void addExperience() {
    setState(() {
      experiences.add({
        "jobTitle": "",
        "company": "",
        "location": "",
        "startDate": "",
        "endDate": "",
        "currentlyWorking": false,
        "description": "",
      });
    });
  }

  void removeExperience(int index) {
    setState(() {
      experiences.removeAt(index);

      if (experiences.isEmpty) {
        addExperience();
      }
    });
  }

  Future<void> saveExperiences() async {
    setState(() {
      saving = true;
    });

    try {
      await firestore.saveWorkExperience(experiences: experiences);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Work Experience Saved Successfully"),
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
        saving = false;
      });
    }
  }

  Widget buildExperienceCard(int index) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Experience ${index + 1}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                if (experiences.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      removeExperience(index);
                    },
                  ),
              ],
            ),

            const SizedBox(height: 20),

            TextFormField(
              initialValue: experiences[index]["jobTitle"],
              decoration: const InputDecoration(
                labelText: "Job Title",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                experiences[index]["jobTitle"] = value;
              },
            ),

            const SizedBox(height: 15),

            TextFormField(
              initialValue: experiences[index]["company"],
              decoration: const InputDecoration(
                labelText: "Company",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                experiences[index]["company"] = value;
              },
            ),

            const SizedBox(height: 15),

            TextFormField(
              initialValue: experiences[index]["location"],
              decoration: const InputDecoration(
                labelText: "Location",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                experiences[index]["location"] = value;
              },
            ),

            const SizedBox(height: 15),

            TextFormField(
              initialValue: experiences[index]["startDate"],
              decoration: const InputDecoration(
                labelText: "Start Date",
                hintText: "Jan 2023",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                experiences[index]["startDate"] = value;
              },
            ),

            const SizedBox(height: 15),

            TextFormField(
              initialValue: experiences[index]["endDate"],
              decoration: const InputDecoration(
                labelText: "End Date",
                hintText: "Present",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                experiences[index]["endDate"] = value;
              },
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: experiences[index]["currentlyWorking"] ?? false,
              title: const Text("I currently work here"),
              onChanged: (value) {
                setState(() {
                  experiences[index]["currentlyWorking"] = value ?? false;
                });
              },
            ),

            const SizedBox(height: 15),

            TextFormField(
              initialValue: experiences[index]["description"],
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: "Job Description",
                hintText:
                    "Describe your responsibilities, achievements, technologies used, and impact.",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                experiences[index]["description"] = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Work Experience"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            for (int i = 0; i < experiences.length; i++) buildExperienceCard(i),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: addExperience,
                icon: const Icon(Icons.add),
                label: const Text("Add Another Experience"),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: saving ? null : saveExperiences,
                child: saving
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Save Work Experience"),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
