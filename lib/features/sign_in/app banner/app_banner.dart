class AppBanner {
  final int id;
  final String title;
  final String description;
  final String img;

  AppBanner({
    required this.id,
    required this.title,
    required this.description,
    required this.img,
  });
}

List<AppBanner> appBannerList = [
  AppBanner(
    id: 1,
    title: 'Selamat datang di River App!',
    img: 'assets/banner/undraw_welcome.svg',
    description: 'Aplikasi seluler GSJA Sungai Kehidupan Surabaya.',
  ),
  AppBanner(
    id: 2,
    title: 'WPDA dan Doa Tabernakel',
    img: 'assets/banner/undraw_reading.svg',
    description:
        'Bangun hubungan yang intim dengan Tuhan melalui firman dan doa.',
  ),
  AppBanner(
    id: 3,
    title: 'Menjadikan semua bangsa Murid Tuhan',
    img: 'assets/banner/undraw_people.svg',
    description: 'Menjadi murid yang memuridkan dan menjangkau banyak jiwa.',
  ),
];
