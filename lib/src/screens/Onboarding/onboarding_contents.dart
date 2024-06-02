class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Monitoring Hewan",
    image: "assets/images/onboarding1.png",
    desc: "Fitur ini  memungkinkan pengguna untuk melacak dan memantau kondisi serta aktivitas hewan secara real-time.",
  ),
  OnboardingContents(
    title: "Perawatan Kesehatan",
    image: "assets/images/onboarding2.png",
    desc: "Membantu pemilik hewan untuk merawat dan memantau kesehatan hewan peliharaan mereka.",
  ),
  OnboardingContents(
    title: "Komunitas Hewan",
    image: "assets/images/onboarding3.png",
    desc: "Forum diskusi antar pemilik hewan untuk terhubung, berbagi informasi, pengalaman atau tentang topik topik terkait hewan peliharaan.",
  ),
];