import 'package:cooking_app/features/cocktails/data/cocktail_repository_impl.dart';
import 'package:cooking_app/features/cocktails/domain/cocktail.dart';
import 'package:cooking_app/features/cocktails/domain/ingredient.dart';
import 'package:flutter/material.dart';

class CocktailDetailScreen extends StatefulWidget {
  final Cocktail cocktail;
  final CocktailRepositoryImpl cocktailRepository;

  const CocktailDetailScreen({
    super.key,
    required this.cocktail,
    required this.cocktailRepository,
  });

  @override
  State<CocktailDetailScreen> createState() => _CocktailDetailScreenState();
}

class _CocktailDetailScreenState extends State<CocktailDetailScreen> {
  bool _isDeleting = false;

  // Bestätigungs-Dialog & Lösch-Logik
  Future<void> _deleteCocktail() async {
    // 1. Sichere Nachfrage per Dialog
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cocktail löschen'),
        content: Text('Möchtest du "${widget.cocktail.name}" wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    // Wenn der Nutzer nicht bestätigt hat -> Abbrechen
    if (confirm != true) return;

    setState(() => _isDeleting = true);

    try {
      // 2. HTTP DELETE Anfrage ausführen
      await widget.cocktailRepository.deleteCocktail(widget.cocktail.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cocktail erfolgreich gelöscht!')),
        );
        // 3. Zurück zur Liste navigieren und `true` für Refresh zurückgeben
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Löschen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cocktail = widget.cocktail;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cocktail.name),
        actions: [
          // Ladeindikator oder Mülleimer-Icon in der AppBar
          _isDeleting
              ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  tooltip: 'Cocktail löschen',
                  onPressed: _deleteCocktail,
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header-Bereich mit Bild & Details
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.local_bar,
                        size: 48,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cocktail.name,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cocktail.taste,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                '${cocktail.rating}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Überschrift Zutaten
            Text(
              'Zutaten',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Zutaten-Liste
            if (cocktail.ingredients.isEmpty)
              const Text('Keine Zutaten angegeben.')
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cocktail.ingredients.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final ingredient = cocktail.ingredients[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                    title: Text(ingredient.name),
                    trailing: Text(
                      ingredient.amount,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}