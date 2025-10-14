class Validators {
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Nome é obrigatório';
    }
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'E-mail é obrigatório';
    }

    // Regex simples para validação de e-mail
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(email)) {
      return 'E-mail inválido';
    }

    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (password.length > 8) {
      return 'Senha deve ter no máximo 8 caracteres';
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Senha deve conter pelo menos um número';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'Senha deve conter pelo menos um caractere especial';
    }

    return null;
  }

  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }

    if (password != confirmPassword) {
      return 'As senhas não coincidem';
    }

    return null;
  }
}