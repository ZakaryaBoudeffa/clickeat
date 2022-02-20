class Validator {
  static String? validateField(String? name) {
    if (name!.isEmpty) {
      return 'Le champ ne peut pas être vide'; //Field can\'t be empty
    }
    return null;
  }

  static String? validateEmail(String? email) {
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (email!.isEmpty) {
      return 'L\'e-mail ne peut pas être vide'; //Email can\'t be empty
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Entrez un email correct'; // Enter a correct email
    }
    return null;
  }

  static String? validatePassword(String? password) {

    if (password!.isEmpty) {
      return 'Le mot de passe ne peut pas être vide'; //Password can\'t be empty
    } else if (password.length < 6) {
      return 'Entrez un mot de passe avec une longueur d\'au moins 6'; //Enter a password with length at least 6
    }

    return null;
  }
}
