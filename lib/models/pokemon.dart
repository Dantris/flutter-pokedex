class Pokemon {
  final String name;
  final String url;
  List<String> types;
  int height;
  int weight;


  Pokemon({
    required this.name,
    required this.url,
    required this.types,
    required this.height,
    required this.weight,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? typesList = json['types'];


    List<String> types = [];
    if (typesList != null) {
      types = typesList.map<String>((type) {
        final Map<String, dynamic>? typeMap = type['type'];
        return typeMap != null ? typeMap['name'].toString() : '';
      }).toList();
    }


    return Pokemon(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      types: types,
      height: json['height'] ?? 0,
      weight: json['weight'] ?? 0,
    );
  }
}
