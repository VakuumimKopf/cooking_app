import 'package:cooking_app/features/cocktails/domain/ingredient.dart';

class CreateIngredientDto {
  final String name;

  const CreateIngredientDto({required this.name});

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}