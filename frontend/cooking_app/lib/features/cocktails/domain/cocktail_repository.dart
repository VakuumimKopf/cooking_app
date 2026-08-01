import './cocktail.dart';

abstract class CocktailRepository {
  Future<List<Cocktail>> fetchCocktails();
}