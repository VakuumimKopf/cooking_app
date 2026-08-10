import 'dart:convert';

import 'package:cooking_app/features/cocktails/domain/create_ingredient_dto.dart';
import 'package:cooking_app/features/cocktails/domain/ingredient.dart';
import 'package:http/http.dart' as http;

import '../domain/ingredient_repository.dart';

class IngredientRepositoryImpl implements IngredientRepository {
  
  final String baseUrl;

  IngredientRepositoryImpl({this.baseUrl = 'http://10.0.2.2:3000/api/items'});

  @override
  Future<List<Ingredient>> fetchIngredient() async {

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

        return jsonList.map((json) => Ingredient.fromJson(json)).toList();
      } else {
        throw Exception('Server-Fehler Statuscode ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Netzwerkfehler beim Laden der Cocktails: $e');
    }
  }

  @override
  Future<Ingredient> postIngredient(CreateIngredientDto dto) async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode(dto.toJson()),
      );

      if (response.statusCode == 201) {
        return Ingredient.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Server-Fehler Statuscode ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Netzwerkfehler beim Erstellen des Cocktails $e');
    }
  }
}