class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;

  // About tab
  final int height; // decimeter
  final int weight; // hectogram
  final List<String> abilities;

  // Base stats tab
  final Map<String, int> stats; // hp, attack, defense, ...

  // Moves tab
  final List<String> moves;

  // Evolution tab
  final String speciesName;
  final String speciesUrl;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
    required this.abilities,
    required this.stats,
    required this.moves,
    required this.speciesName,
    required this.speciesUrl,
  });

  factory Pokemon.fromDetailJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final name = json['name'] as String;

    // types
    final typesJson = json['types'] as List<dynamic>;
    final types = typesJson
        .map((e) => e['type']['name'] as String)
        .toList(growable: false);

    // image
    final sprites = json['sprites'] as Map<String, dynamic>;
    final other = sprites['other'] as Map<String, dynamic>?;
    final officialArtwork = other?['official-artwork'] as Map<String, dynamic>?;
    final imageUrl =
        (officialArtwork?['front_default'] ?? sprites['front_default'])
            as String;

    // height & weight
    final height = json['height'] as int;
    final weight = json['weight'] as int;

    // abilities
    final abilitiesJson = json['abilities'] as List<dynamic>;
    final abilities = abilitiesJson
        .map((e) => e['ability']['name'] as String)
        .toList(growable: false);

    // stats (hp, attack, defense, sp-attack, sp-defense, speed)
    final statsJson = json['stats'] as List<dynamic>;
    final stats = <String, int>{};
    for (final s in statsJson) {
      final statName = s['stat']['name'] as String;
      final baseStat = s['base_stat'] as int;
      stats[statName] = baseStat;
    }

    // moves (batasi biar nggak kebanyakan, misal 40 moves pertama)
    final movesJson = json['moves'] as List<dynamic>;
    final moves = movesJson
        .map((m) => m['move']['name'] as String)
        .take(40)
        .toList(growable: false);

    // species info (untuk evolution chain)
    final species = json['species'] as Map<String, dynamic>;
    final speciesName = species['name'] as String;
    final speciesUrl = species['url'] as String;

    return Pokemon(
      id: id,
      name: name,
      imageUrl: imageUrl,
      types: types,
      height: height,
      weight: weight,
      abilities: abilities,
      stats: stats,
      moves: moves,
      speciesName: speciesName,
      speciesUrl: speciesUrl,
    );
  }

  String get formattedId => "#${id.toString().padLeft(3, '0')}";

  String get capitalizedName =>
      name.isEmpty ? name : name[0].toUpperCase() + name.substring(1);

  String get primaryType => types.isNotEmpty ? types.first : '';

  String get heightInMeters => "${(height / 10).toStringAsFixed(1)} m";

  String get weightInKg => "${(weight / 10).toStringAsFixed(1)} kg";

  String get abilitiesText =>
      abilities.map((a) => a[0].toUpperCase() + a.substring(1)).join(", ");

  int statValue(String key) => stats[key] ?? 0;
}
