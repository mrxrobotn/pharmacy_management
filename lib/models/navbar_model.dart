class NavBarModel {
  final int id;
  final String imagePath;
  final String name;

  NavBarModel({
    required this.id,
    required this.imagePath,
    required this.name,
  });
}

List<NavBarModel> navBtn = [
  NavBarModel(id: 0, imagePath: 'assets/icon/home.png', name: 'Home'),
  NavBarModel(id: 1, imagePath: 'assets/icon/search.png', name: 'Search'),
  NavBarModel(id: 2, imagePath: 'assets/icon/heart.png', name: 'Like'),
  NavBarModel(id: 3, imagePath: 'assets/icon/notification.png', name: 'notification'),
  NavBarModel(id: 4, imagePath: 'assets/icon/user.png', name: 'Profile'),
];