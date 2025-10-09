class Validators {
  static String? validateCPF(String? cpf) {
    if (cpf == null || cpf.isEmpty) {
      return 'CPF é obrigatório';
    }

    // Remove caracteres não numéricos
    String cleanedCpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanedCpf.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1+$').hasMatch(cleanedCpf)) {
      return 'CPF inválido';
    }

    // Validação do primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cleanedCpf[i]) * (10 - i);
    }
    int firstDigit = (sum * 10) % 11;
    if (firstDigit == 10) firstDigit = 0;

    if (firstDigit != int.parse(cleanedCpf[9])) {
      return 'CPF inválido';
    }

    
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cleanedCpf[i]) * (11 - i);
    }
    int secondDigit = (sum * 10) % 11;
    if (secondDigit == 10) secondDigit = 0;

    if (secondDigit != int.parse(cleanedCpf[10])) {
      return 'CPF inválido';
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