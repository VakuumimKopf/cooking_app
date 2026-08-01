import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/cocktail.dart';
import '../domain/cocktail_repository.dart';

class CocktailRepositoryImpl implements CocktailRepository {
  
  final String baseUrl;

  CocktailRepositoryImpl({this.baseUrl = 'http://10.0.2.2:3000/api/recipes'});

  @override
  Future<List<Cocktail>> fetchCocktails() async {

    final url = Uri.parse(baseUrl);

    try {
      final response = await http.get(
        url,
        headers: {
          'Contenct-Type': 'json'
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);

        return jsonList.map((json) => Cocktail.fromJson(json)).toList();
      } else {
        throw Exception('Server-Fehler Statuscode ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Netzwerkfehler beim Laden der Cocktails: $e');
    }
  }
}