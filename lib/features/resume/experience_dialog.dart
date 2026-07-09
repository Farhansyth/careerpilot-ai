import 'package:flutter/material.dart';

import 'work_experience_model.dart';

class ExperienceDialog extends StatefulWidget {
  final WorkExperience? experience;

  const ExperienceDialog({super.key, this.experience});

  @override
  State<ExperienceDialog> createState() => _ExperienceDialogState();
}

class _ExperienceDialogState extends State<ExperienceDialog> {
  final formKey = GlobalKey<FormState>();

  final jobTitleController = TextEditingController();

  final companyController = TextEditingController();

  final locationController = TextEditingController();

  final descriptionController = TextEditingController();

  String employmentType = "Full-time";

  bool currentlyWorking = false;

  DateTime? startDate;

  DateTime? endDate;
  @override
  void initState() {
    super.initState();

    if (widget.experience != null) {
      final exp = widget.experience!;

      jobTitleController.text = exp.jobTitle;

      companyController.text = exp.companyName;

      locationController.text = exp.location;

      descriptionController.text = exp.description;

      employmentType = exp.employmentType;

      currentlyWorking = exp.currentlyWorking;

      startDate = exp.startDate;

      endDate = exp.endDate;
    }
  }

  Future<void> pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        endDate = picked;
      });
    }
  }

  @override
  void dispose() {
    jobTitleController.dispose();
    companyController.dispose();
    locationController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.experience == null
            ? "Add Work Experience"
            : "Edit Work Experience",
      ),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: jobTitleController,
                  decoration: const InputDecoration(
                    labelText: "Job Title",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: companyController,
                  decoration: const InputDecoration(labelText: "Company"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: "Location"),
                ),

                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  initialValue: employmentType,
                  decoration: const InputDecoration(
                    labelText: "Employment Type",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "Full-time",
                      child: Text("Full-time"),
                    ),
                    DropdownMenuItem(
                      value: "Part-time",
                      child: Text("Part-time"),
                    ),
                    DropdownMenuItem(
                      value: "Contract",
                      child: Text("Contract"),
                    ),
                    DropdownMenuItem(
                      value: "Internship",
                      child: Text("Internship"),
                    ),
                    DropdownMenuItem(
                      value: "Freelance",
                      child: Text("Freelance"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      employmentType = value!;
                    });
                  },
                ),

                const SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    startDate == null
                        ? "Select Start Date"
                        : "Start: ${startDate!.day}/${startDate!.month}/${startDate!.year}",
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: pickStartDate,
                ),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    currentlyWorking
                        ? "Present"
                        : endDate == null
                        ? "Select End Date"
                        : "End: ${endDate!.day}/${endDate!.month}/${endDate!.year}",
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: currentlyWorking ? null : pickEndDate,
                ),

                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: currentlyWorking,
                  title: const Text("I currently work here"),
                  onChanged: (value) {
                    setState(() {
                      currentlyWorking = value!;
                    });
                  },
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: descriptionController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: "Job Description",
                    hintText:
                        "Describe your achievements, responsibilities and impact...",
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) {
              return;
            }

            if (startDate == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please select a start date.")),
              );

              return;
            }

            if (!currentlyWorking && endDate == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please select an end date.")),
              );

              return;
            }

            final experience = WorkExperience(
              id:
                  widget.experience?.id ??
                  DateTime.now().millisecondsSinceEpoch.toString(),

              jobTitle: jobTitleController.text.trim(),

              companyName: companyController.text.trim(),

              location: locationController.text.trim(),

              employmentType: employmentType,

              startDate: startDate!,

              endDate: currentlyWorking ? null : endDate,

              currentlyWorking: currentlyWorking,

              description: descriptionController.text.trim(),
            );

            Navigator.pop(context, experience);
          },
          child: Text(
            widget.experience == null ? "Add Experience" : "Update Experience",
          ),
        ),
      ],
    );
  }
}
