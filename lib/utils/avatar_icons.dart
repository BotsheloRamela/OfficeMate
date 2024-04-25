
class AvatarIcons {
  static const String avatar1 = 'assets/avatars/avatar_1.jpg';
  static const String avatar2 = 'assets/avatars/avatar_2.jpg';
  static const String avatar3 = 'assets/avatars/avatar_3.jpg';
  static const String avatar4 = 'assets/avatars/avatar_4.jpg';
  static const String avatar5 = 'assets/avatars/avatar_5.jpg';
  static const String avatar6 = 'assets/avatars/avatar_6.jpg';
  static const String avatar7 = 'assets/avatars/avatar_7.jpg';

  static String getAvatarById(String id) {
    switch(id) {
      case '1':
        return avatar1;
      case '2':
        return avatar2;
      case '3':
        return avatar3;
      case '4':
        return avatar4;
      case '5':
        return avatar5;
      case '6':
        return avatar6;
      case '7':
        return avatar7;
      default:
        return avatar1;
    }
  }
}