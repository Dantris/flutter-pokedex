import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class ApiService {
  static const String baseUrl = 'https://pokeapi.co/api/v2/';

  static Future<Map<String, dynamic>> fetchPokemonDetails(String pokemonName) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$pokemonName'));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> typesList = decoded['types'];
      final List<String> types = typesList.map<String>((type) => type['type']['name'].toString()).toList();

      return {
        'height': decoded['height'],
        'weight': decoded['weight'],
        'types': types,
      };
    } else {
      throw Exception('Failed to load details for $pokemonName');
    }
  }

  static Future<List<Pokemon>> fetchPokemonList() async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon'));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List<dynamic> results = decoded['results'];
      return results.map((json) => Pokemon.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<String> fetchPokemonSpriteUrl(String pokemonName) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$pokemonName'));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      print('JSON Response: $json'); // Log the JSON response

      return decoded['sprites']['front_default'];
    } else {
      throw Exception('Failed to load sprite for $pokemonName');
    }
  }
}




