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

List<NavBarModel> pharmacienNavBar = [
  NavBarModel(id: 0, imagePath: 'assets/icons/home.png', name: 'Acceuil'),
  NavBarModel(id: 1, imagePath: 'assets/icons/lists.png', name: 'Commandes'),
  NavBarModel(id: 2, imagePath: 'assets/icons/messenger.png', name: 'Messages'),
  NavBarModel(id: 3, imagePath: 'assets/icons/chats.png', name: 'Aide'),
  NavBarModel(id: 4, imagePath: 'assets/icons/user.png', name: 'Profile'),
];

List<NavBarModel> clientNavBar = [
  NavBarModel(id: 0, imagePath: 'assets/icons/home.png', name: 'Acceuil'),
  NavBarModel(id: 1, imagePath: 'assets/icons/lists.png', name: 'Commandes'),
  NavBarModel(id: 2, imagePath: 'assets/icons/messenger.png', name: 'Messages'),
  NavBarModel(id: 3, imagePath: 'assets/icons/chats.png', name: 'Aide'),
  NavBarModel(id: 4, imagePath: 'assets/icons/user.png', name: 'Profile'),
];

List<NavBarModel> adminNavBar = [
  NavBarModel(id: 0, imagePath: 'assets/icons/lists.png', name: 'Utilisateurs'),
  NavBarModel(id: 1, imagePath: 'assets/icons/add-user.png', name: 'Ajouter'),
  NavBarModel(id: 2, imagePath: 'assets/icons/user.png', name: 'Profile'),
];

List<NavBarModel> fournisseurNavBar = [
  NavBarModel(id: 0, imagePath: 'assets/icons/lists.png', name: 'Commandes'),
  NavBarModel(id: 2, imagePath: 'assets/icons/user.png', name: 'Profile'),
];