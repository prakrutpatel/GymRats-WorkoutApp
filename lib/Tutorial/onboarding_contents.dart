

class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents(
      {required this.title, required this.image, required this.desc});
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Navigate the app using sidebar",
    image: "assets/images/image1.png",
    desc: "To use sidebar swipe on the left edge. Sidebar contains different menus that you can navigate to.",
  ),
  OnboardingContents(
    title: "Calender Menu",
    image: "assets/images/image2.png",
    desc:
    "Calender shows your workouts planned for the month. Select an individual day to modify your workout for the day.",
  ),
  OnboardingContents(
    title: "Workout Menu",
    image: "assets/images/image3.png",
    desc:
    "Workout Menu is how you create and share workouts. Select an existing workout to add to your calender or create a new one.",
  ),
];