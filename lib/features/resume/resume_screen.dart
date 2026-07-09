import 'package:flutter/material.dart';

import 'professional_summary.dart';
import 'resume_personal.dart';
import 'resume_skills.dart';
import 'resume_work_experience.dart';

class ResumeScreen extends StatelessWidget {
  const ResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resume Builder"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Build your ATS-Friendly Resume",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const Text(
            "Complete each section to create a professional ATS-friendly resume.",
            style: TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 30),

          _sectionTile(
            context,
            Icons.person,
            "Personal Information",
            const ResumePersonalScreen(),
          ),

          _sectionTile(
            context,
            Icons.description,
            "Professional Summary",
            const ProfessionalSummaryScreen(),
          ),

          _sectionTile(
            context,
            Icons.psychology,
            "Skills",
            const ResumeSkillsScreen(),
          ),

          _sectionTile(
            context,
            Icons.work,
            "Work Experience",
            const ResumeWorkExperienceScreen(),
          ),

          _comingSoon(Icons.school, "Education"),

          _comingSoon(Icons.folder, "Projects"),

          _comingSoon(Icons.workspace_premium, "Certifications"),

          _comingSoon(Icons.language, "Languages"),

          _comingSoon(Icons.picture_as_pdf, "Export Resume"),
        ],
      ),
    );
  }

  Widget _sectionTile(
    BuildContext context,
    IconData icon,
    String title,
    Widget screen,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.shade50,
          child: Icon(icon, color: Colors.indigo),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
      ),
    );
  }

  Widget _comingSoon(IconData icon, String title) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: Icon(icon, color: Colors.grey),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: const Text("Coming Soon"),
        trailing: const Icon(Icons.lock_outline, color: Colors.grey),
      ),
    );
  }
}
