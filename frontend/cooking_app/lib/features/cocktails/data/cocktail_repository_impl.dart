import 'dart:convert';
import 'dart:developer';

import 'package:cooking_app/features/cocktails/domain/create_cocktail_dto.dart';
import 'package:cooking_app/features/cocktails/domain/update_cocktail_dto.dart';
import 'package:http/http.dart' as http;

import '../domain/cocktail.dart';
import '../domain/cocktail_repository.dart';

class CocktailRepositoryImpl implements CocktailRepository {
  
  final String baseUrl;

  CocktailRepositoryImpl({this.baseUrl = 'http://10.0.2.2:3000/api/cocktails'});

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

  @override
  Future<Cocktail> fetchCocktailById(int id) async {
    final url = Uri.parse('$baseUrl/$id');

    try {
      final response = await http.get(
        url,
        headers: {
          'Contenct-Type': 'json'
        },
      );

      log(id.toString());

      if (response.statusCode == 200) {
        return Cocktail.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Server-Fehler Statuscode ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Netzwerkfehler beim Laden der Cocktails: $e');
    }
  }

  @override
  Future<Cocktail> postCocktail(CreateCocktailDto dto) async {
    final url = Uri.parse(baseUrl);

    Map<String, dynamic> json = dto.toJson();

    log("Cocktail wird geschickt an Backend: $json");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode(dto.toJson()),
      );

      if (response.statusCode == 201) {
        return Cocktail.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Server-Fehler Statuscode ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Netzwerkfehler beim Erstellen des Cocktails $e');
    }
  }

  @override
  Future<void> deleteCocktail(int id) async {
    final url = Uri.parse('$baseUrl/$id');

    log("Schicke Delete Befehl an $url");

    try {
      final response = await http
        .delete(
          url,
          headers: {'Content-Type': 'application/json'},
        );

      log("Response Statuscode: ${response.statusCode}");

      // Manche Backends antworten mit 200 (OK), manche mit 204 (No Content)
      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      } else {
        throw Exception('Server-Fehler Statuscode ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      log("Fehler beim Löschen: $e");
      throw Exception('Netzwerkfehler beim Löschen des Cocktails: $e');
    }
  }

  @override
  Future<Cocktail> updateCocktail(CreateCocktailDto dto, int id) async {
    final url = Uri.parse('$baseUrl/$id');

    try {
      final response = await http
        .put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(dto.toJson()),
      );

      log(id.toString());
      log(dto.toJson().toString());
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return Cocktail.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Server-Fehler Statuscode ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      log("Fehler beim Löschen: $e");
      throw Exception('Netzwerkfehler beim Löschen des Cocktails: $e');
    }
  }
}