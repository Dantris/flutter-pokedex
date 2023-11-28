import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../services/api_service.dart';

class PokemonDetailScreen extends StatefulWidget {
  final Pokemon pokemon;

  PokemonDetailScreen({required this.pokemon});

  @override
  _PokemonDetailScreenState createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  late Future<String> _spriteUrl = Future.value('');

  @override
  void initState() {
    super.initState();
    _fetchPokemonDetails();
    _fetchSpriteUrl();
  }

  void _fetchPokemonDetails() async {
    try {
      final details = await ApiService.fetchPokemonDetails(widget.pokemon.name.toLowerCase());
      setState(() {
        widget.pokemon.height = details['height'];
        widget.pokemon.types = List<String>.from(details['types']);
        widget.pokemon.weight = details['weight'];
      });
    } catch (e) {
      print('Failed to fetch Pokemon details: $e');
    }
  }

  void _fetchSpriteUrl() async {
    try {
      final spriteUrl =
      await ApiService.fetchPokemonSpriteUrl(widget.pokemon.name.toLowerCase());
      setState(() {
        _spriteUrl = Future.value(spriteUrl);
      });
    } catch (e) {
      print('Failed to fetch Pokemon image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokemon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${widget.pokemon.name}'.toUpperCase(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            FutureBuilder<String>(
              future: _spriteUrl,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return Text('Error loading sprite');
                } else if (snapshot.hasData) {
                  return Column(
                    children: [
                      Image.network(
                        snapshot.data!,
                        width: 150,
                        height: 150,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Height: ${widget.pokemon.height} Dm',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Types: ${widget.pokemon.types.join(', ')}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      // Add more info as needed
                    ],
                  );
                } else {
                  return Text('No image available');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
