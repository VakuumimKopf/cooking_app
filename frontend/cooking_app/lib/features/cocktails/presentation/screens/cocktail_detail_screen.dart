import 'package:cooking_app/features/cocktails/data/cocktail_repository_impl.dart';
import 'package:cooking_app/features/cocktails/data/ingredient_repository_impl.dart';
import 'package:cooking_app/features/cocktails/domain/cocktail.dart';
import 'package:cooking_app/features/cocktails/domain/ingredient.dart';
import 'package:cooking_app/features/cocktails/presentation/screens/cocktail_add_screen.dart';
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
  // 1. Lokaler State für den veränderbaren Cocktail
  late Cocktail _currentCocktail;

  bool _isDeleting = false;
  bool _isLoading = false;
  bool _hasBeenUpdated = false; // Merkt sich, ob für den ListScreen neu geladen werden muss

  @override
  void initState() {
    super.initState();
    // Startet mit dem übergebenen Cocktail
    _currentCocktail = widget.cocktail;
  }

  Future<void> _refreshCocktail() async {
    setState(() => _isLoading = true);

    try {
      // Lädt die frischen Daten vom Repository
      // (Falls deine Methode im Repo anders heißt, z.B. fetchCocktailById, hier anpassen)
      final updatedCocktail = await widget.cocktailRepository.fetchCocktailById(_currentCocktail.id);

      if (mounted) {
        setState(() {
          _currentCocktail = updatedCocktail;
          _hasBeenUpdated = true; // Signal für den übergeordneten ListScreen
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cocktail erfolgreich aktualisiert!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Aktualisieren: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
    // 3. PopScope stellt sicher, dass beim Drücken des Zurück-Pfeils
    // das _hasBeenUpdated-Signal an den CocktailListScreen übergeben wird
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _hasBeenUpdated);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_currentCocktail.name),
          actions: [
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
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final bool? cocktailUpdated = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CocktailAddScreen(
                      cocktailRepository: widget.cocktailRepository,
                      ingredientRepository: IngredientRepositoryImpl(),
                      cocktail: _currentCocktail, // Aktuelle Daten übergeben
                    ),
                  ),
                );

                // Wenn im AddScreen gespeichert wurde -> Details neu laden!
                if (cocktailUpdated == true) {
                  await _refreshCocktail();
                }
              },
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header-Bereich
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
                                    _currentCocktail.name,
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _currentCocktail.taste,
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
                                        '${_currentCocktail.rating}',
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
                    if (_currentCocktail.ingredients.isEmpty)
                      const Text('Keine Zutaten angegeben.')
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _currentCocktail.ingredients.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final ingredient = _currentCocktail.ingredients[index];
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
      ),
    );
  }
}