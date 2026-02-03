class OnboardingContent {
  final String image;
  final String title;
  final String description;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<OnboardingContent> contents = [
  OnboardingContent(
    image: 'assets/images/page2.png',
    title: 'Easy Time Management',
    description: 'With management based on priority and daily tasks, it will give you convenience in managing and determining the tasks that must be done first',
  ),
  OnboardingContent(
    image: 'assets/images/page3.png',
    title: 'Increase Work Effectiveness',
    description: 'Time management and the determination of more important tasks will give your job statistics better and always improve',
  ),
  OnboardingContent(
    image: 'assets/images/page4.png',
    title: 'Reminder Notification',
    description: "The advantage of this application is that it also provides reminders for you so you don't forget to keep doing your assignments well and according to the time you have set",
  ),
];