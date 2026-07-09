import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

class ResumeSkillsScreen extends StatefulWidget {
  const ResumeSkillsScreen({super.key});

  @override
  State<ResumeSkillsScreen> createState() => _ResumeSkillsScreenState();
}

class _ResumeSkillsScreenState extends State<ResumeSkillsScreen> {
  final FirestoreService firestore = FirestoreService();

  final TextEditingController skillController = TextEditingController();

  List<String> skills = [];

  bool loading = false;
  bool pageLoading = true;

  @override
  void initState() {
    super.initState();
    loadSkills();
  }

  Future<void> loadSkills() async {
    try {
      skills = await firestore.getSkills();
    } catch (e) {
      debugPrint(e.toString());
    }

    if (mounted) {
      setState(() {
        pageLoading = false;
      });
    }
  }

  Future<void> saveSkills() async {
    setState(() {
      loading = true;
    });

    try {
      await firestore.saveSkills(skills: skills);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Skills Saved Successfully"),
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

  void addSkill() {
    final value = skillController.text.trim();

    if (value.isEmpty) return;

    if (skills.contains(value)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Skill already added.")));
      return;
    }

    setState(() {
      skills.add(value);
    });

    skillController.clear();
  }

  void removeSkill(int index) {
    setState(() {
      skills.removeAt(index);
    });
  }

  @override
  void dispose() {
    skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Skills"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: pageLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: skillController,
                    decoration: InputDecoration(
                      labelText: "Add Skill",
                      hintText: "Example: Flutter",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: addSkill,
                      ),
                    ),
                    onSubmitted: (_) => addSkill(),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: skills.isEmpty
                        ? const Center(
                            child: Text(
                              "No skills added yet.",
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: skills.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                  title: Text(skills[index]),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => removeSkill(index),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: loading ? null : saveSkills,
                      icon: const Icon(Icons.save),
                      label: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Save Skills",
                              style: TextStyle(fontSize: 18),
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
