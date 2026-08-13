import 'package:cooking_app/features/cocktails/domain/create_cocktail_dto.dart';
import 'package:cooking_app/features/cocktails/domain/update_cocktail_dto.dart';

import './cocktail.dart';

abstract class CocktailRepository {
  Future<List<Cocktail>> fetchCocktails();

  Future<Cocktail> fetchCocktailById(int id);

  Future<Cocktail> postCocktail(CreateCocktailDto dto);

  Future deleteCocktail(int id);

  Future<Cocktail> updateCocktail(CreateCocktailDto dto, int id);
}