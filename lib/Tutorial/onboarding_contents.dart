//Written by PK

class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents(
      {required this.title, required this.image, required this.desc});
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Home Page",
    image: "assets/images/tutorial1.jpg",
    desc: "Navigate to different pages using the bottom navigation bar. Home Page contains a list of workouts scheduled for today as well as other useful information such as cardio tracking data",
  ),
  OnboardingContents(
    title: "Calender Page",
    image: "assets/images/tutorial2.jpg",
    desc:
    "Calender shows your workouts planned for the month. Select an individual day to modify your workout for the day.",
  ),
  OnboardingContents(
    title: "Workout Page",
    image: "assets/images/tutorial3.jpg",
    desc:
    "Workout Menu is where you create and share workouts. Select an existing workout to add to your calender or create a new one.",
  ),
  OnboardingContents(
    title: "Profile Page",
    image: "assets/images/tutorial4.jpg",
    desc:
    "Profile Page contains your biometric data that can be modyfied so that we can provide you with the more accurate calorie data.",
  ),
];