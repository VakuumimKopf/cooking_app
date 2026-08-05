import 'package:cooking_app/features/cocktails/domain/cocktail.dart';
import 'package:cooking_app/features/cocktails/domain/ingredient.dart';
import 'package:flutter/material.dart';

class CocktailDetailScreen extends StatelessWidget{
  final Cocktail cocktail;

  const CocktailDetailScreen({super.key, required this.cocktail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cocktail.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.local_bar),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Chip(label: Text(cocktail.taste)),
                  const SizedBox(height: 16),

                  Text(
                    'Zutaten', 
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...cocktail.ingredients.map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        children: [
                          const Icon(Icons.check, size: 18, color: Colors.green),
                          const SizedBox(width: 8),
                          Text('• ${item.amount.toString()} ${item.name}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}