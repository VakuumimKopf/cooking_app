import 'package:cooking_app/features/cocktails/domain/create_cocktail_dto.dart';

import './cocktail.dart';

abstract class CocktailRepository {
  Future<List<Cocktail>> fetchCocktails();

  Future<Cocktail> postCocktail(CreateCocktailDto dto);

  Future deleteCocktail(int id);
}