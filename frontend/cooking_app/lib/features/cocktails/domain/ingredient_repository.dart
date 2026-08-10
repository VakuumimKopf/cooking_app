import 'package:cooking_app/features/cocktails/domain/create_ingredient_dto.dart';

import './ingredient.dart';

abstract class IngredientRepository {
  Future<List<Ingredient>> fetchIngredient();

  Future<Ingredient> postIngredient(CreateIngredientDto dto);
}