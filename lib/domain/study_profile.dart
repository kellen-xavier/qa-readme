class StudyProfile {
  const StudyProfile({
    this.name = '',
    this.hair = '7549c9',
    this.background = 'dfd3fb',
  });

  static const hairColors = {
    '7549c9': 'Violeta',
    'bd4d4c': 'Coral',
    '262139': 'Preto',
  };
  static const backgrounds = {
    'dfd3fb': 'Lavanda',
    'e5f884': 'Lima',
    'ffd8c9': 'Pêssego',
  };
  final String name;
  final String hair;
  final String background;

  Map<String, dynamic> toJson() => {
    'name': name,
    'hair': hair,
    'background': background,
  };

  factory StudyProfile.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String;
    final hair = json['hair'] as String;
    final background = json['background'] as String;
    if (name.length > 100 ||
        !hairColors.containsKey(hair) ||
        !backgrounds.containsKey(background)) {
      throw const FormatException('Perfil inválido.');
    }
    return StudyProfile(name: name, hair: hair, background: background);
  }
}
