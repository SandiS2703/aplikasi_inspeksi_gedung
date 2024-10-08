class Validator {
  static String? validateName({required String? name}) {
    if (name == null) {
      return null;
    }

    if (name.isEmpty) {
      return 'Name can\'t be empty';
      return null;
    }
  }

  static String? validateUsername({required String? username }){
    if (username == null) {
      return null;
    }
    if (username.isEmpty) {
      return 'Ga Boleh Kosong Bang!';
    }
    return null;
  }

  static String? validatePassword({required String? password}) {
    if (password == null) {
      return null;
    }

    if (password.isEmpty) {
      return 'Ga Boleh Kosong Bang!';
    } else if (password.length < 6) {
      return 'Enter a password with length at least 6';
    }

    return null;
  }
}
