import 'package:mask_text_input_formatter/mask_text_input_formatter';

class Masks {
  static MaskTextInputFormatter cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
}