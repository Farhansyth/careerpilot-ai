class OnboardingData {
  final String title;
  final String description;
  final String image;

  const OnboardingData({
    required this.title,
    required this.description,
    required this.image,
  });
}

const onboardingPages = [
  OnboardingData(
    title: "Find Your Dream Job",
    description:
        "Search thousands of jobs tailored to your skills and experience.",
    image: "assets/images/onboarding1.png",
  ),
  OnboardingData(
    title: "Build ATS-Friendly Resume",
    description:
        "Create professional resumes with AI that pass ATS systems.",
    image: "assets/images/onboarding2.png",
  ),
  OnboardingData(
    title: "Track Every Application",
    description:
        "Stay organized and monitor every interview and job application.",
    image: "assets/images/onboarding3.png",
  ),
];