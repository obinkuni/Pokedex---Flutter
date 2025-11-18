import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonService {
  static const String baseUrl = "https://pokeapi.co/api/v2";

  // List Pokedex
  static Future<List<Pokemon>> fetchPokemonList({int limit = 50}) async {
    final url = Uri.parse("$baseUrl/pokemon?limit=$limit");
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Gagal mengambil list pokemon");
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>;

    final futures = results.map((item) async {
      final detailUrl = item['url'] as String;
      final detailResponse = await http.get(Uri.parse(detailUrl));

      if (detailResponse.statusCode != 200) {
        throw Exception("Gagal mengambil detail pokemon");
      }

      final detailData =
          jsonDecode(detailResponse.body) as Map<String, dynamic>;
      return Pokemon.fromDetailJson(detailData);
    }).toList();

    return Future.wait(futures);
  }

  // 🔹 Evolution chain
  static Future<List<String>> fetchEvolutionChain(String speciesUrl) async {
    // 1. Data species
    final speciesRes = await http.get(Uri.parse(speciesUrl));
    if (speciesRes.statusCode != 200) {
      throw Exception("Gagal mengambil species");
    }
    final speciesData =
        jsonDecode(speciesRes.body) as Map<String, dynamic>;

    // 2. URL evolution chain
    final evoUrl = speciesData['evolution_chain']['url'] as String;

    // 3. Data evolution chain
    final evoRes = await http.get(Uri.parse(evoUrl));
    if (evoRes.statusCode != 200) {
      throw Exception("Gagal mengambil evolution chain");
    }
    final evoData = jsonDecode(evoRes.body) as Map<String, dynamic>;

    final List<String> chainNames = [];

    void traverse(Map<String, dynamic> node) {
      final species = node['species'] as Map<String, dynamic>;
      final name = species['name'] as String;
      chainNames.add(name);

      final evolvesTo = node['evolves_to'] as List<dynamic>;
      for (final e in evolvesTo) {
        traverse(e as Map<String, dynamic>);
      }
    }

    traverse(evoData['chain'] as Map<String, dynamic>);

    return chainNames;
  }
}
