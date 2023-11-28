import 'package:flutter/material.dart';
import 'package:test01/screens/pokemon_details_screen.dart';
import '../models/pokemon.dart';
import '../services/api_service.dart';

class PokedexScreen extends StatefulWidget {
  @override
  _PokedexScreenState createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  late Future<List<Pokemon>> _pokemonList;
  List<Pokemon> _filteredPokemonList = [];

  @override
  void initState() {
    super.initState();
    _pokemonList = ApiService.fetchPokemonList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokedex'),
        actions: [
          IconButton(
            onPressed: () => _showSearch(context),
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: FutureBuilder<List<Pokemon>>(
        future: _pokemonList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            _filteredPokemonList = snapshot.data!;
            return ListView.builder(
              itemCount: _filteredPokemonList.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildPokemonListItem(_filteredPokemonList[index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildPokemonListItem(Pokemon pokemon) {
    return FutureBuilder<String>(
      future: ApiService.fetchPokemonSpriteUrl(pokemon.name.toLowerCase()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading sprite');
        } else {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PokemonDetailScreen(pokemon: pokemon),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    if (snapshot.hasData)
                      Image.network(
                        snapshot.data!,
                        width: 50,
                        height: 50,
                      ),
                    SizedBox(width: 12),
                    Text(
                      pokemon.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  void _showSearch(BuildContext context) async {
    final result = await showSearch<String>(
      context: context,
      delegate: PokemonSearchDelegate(_filteredPokemonList),
    );
    // Handle search result
    if (result != null && result.isNotEmpty) {
      setState(() {
        _filteredPokemonList = _filteredPokemonList
            .where((pokemon) => pokemon.name.toLowerCase().contains(result.toLowerCase()))
            .toList();
      });
    }
  }
}

class PokemonSearchDelegate extends SearchDelegate<String> {
  final List<Pokemon> pokemonList;

  PokemonSearchDelegate(this.pokemonList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = pokemonList.where((pokemon) => pokemon.name.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(results[index].name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PokemonDetailScreen(pokemon: results[index]),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = pokemonList.where((pokemon) => pokemon.name.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(results[index].name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PokemonDetailScreen(pokemon: results[index]),
              ),
            );
          },
        );
      },
    );
  }
}

