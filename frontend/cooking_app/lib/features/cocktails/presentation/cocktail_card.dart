import 'package:cooking_app/features/cocktails/presentation/screens/cocktail_detail_screen.dart';
import 'package:flutter/material.dart';
import '../domain/cocktail.dart';

class CocktailCard extends StatelessWidget {
  final Cocktail cocktail;

  const CocktailCard({super.key, required this.cocktail});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => CocktailDetailScreen(cocktail: cocktail),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Vorschaubild mit abgerundeten Ecken
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Icon(Icons.local_bar)
              ),
              const SizedBox(width: 16),
              // Text-Informationen
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cocktail.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      cocktail.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 6)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}