import 'package:cooking_app/features/cocktails/data/cocktail_repository_impl.dart';
import 'package:cooking_app/features/cocktails/data/ingredient_repository_impl.dart';
import 'package:cooking_app/features/cocktails/domain/create_cocktail_dto.dart';
import 'package:flutter/material.dart';
import '../../domain/ingredient.dart';

class CocktailAddScreen extends StatefulWidget {
  final CocktailRepositoryImpl _cocktailRepository;
  final IngredientRepositoryImpl _ingredientRepository;

  const CocktailAddScreen({super.key, required this._cocktailRepository, required this._ingredientRepository});

  @override
  State<CocktailAddScreen> createState() => _CocktailAddScreenState();
}

class _CocktailAddScreenState extends State<CocktailAddScreen> {
  final _formKey = GlobalKey<FormState>();

  List<Ingredient> _availableIngredients = [];
  bool _isLoadingIngredients = true;

  // Controller für Hauptfelder
  final _nameController = TextEditingController();
  final _tasteController = TextEditingController();
  final _ratingController = TextEditingController(text: '4.5');

  // Dynamische Controller-Liste für Zutaten
  final List<Map<String, TextEditingController>> _ingredientControllers = [];

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Startet direkt mit einer leeren Zutaten-Zeile
    _addIngredientRow();
    _loadIngredients();
  }

  void _addIngredientRow() {
    setState(() {
      _ingredientControllers.add({
        'amount': TextEditingController(),
        'name': TextEditingController(),
      });
    });
  }

  void _removeIngredientRow(int index) {
    if (_ingredientControllers.length > 1) {
      setState(() {
        _ingredientControllers[index]['amount']?.dispose();
        _ingredientControllers[index]['name']?.dispose();
        _ingredientControllers.removeAt(index);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tasteController.dispose();
    _ratingController.dispose();
    for (var controllers in _ingredientControllers) {
      controllers['amount']?.dispose();
      controllers['name']?.dispose();
    }
    super.dispose();
  }

  Future<void> _loadIngredients() async {
    try {
      final ingredients = await widget._ingredientRepository.fetchIngredient();

      if (mounted) {
        setState(() {
          _availableIngredients = ingredients;
          _isLoadingIngredients = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingIngredients = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Laden der Zutaten: $e')),
        );
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      // 1. Zutaten-Liste aus den Textfeldern zusammenbauen
      final ingredients = _ingredientControllers
          .where((row) => row['name']!.text.trim().isNotEmpty)
          .map((row) {
            final inputName = row['name']!.text.trim();
            final amount = row['amount']!.text.trim();

            // Suche nach einer existierenden Zutat mit demselben Namen (Case-Insensitive)
            final existing = _availableIngredients.cast<Ingredient?>().firstWhere(
              (ing) => ing!.name.toLowerCase() == inputName.toLowerCase(),
              orElse: () => null,
            );

            return Ingredient(
              id: existing?.id, // Nimmt die echte ID vom Backend, sonst 0
              amount: amount,
              name: inputName,
            );
          })
          .toList();

      // 2. Datenpaket fürs Backend schnüren
      final newCocktailData = CreateCocktailDto(
        name: _nameController.text.trim(),
        taste: _tasteController.text.trim(),
        rating: double.tryParse(_ratingController.text) ?? 5.0,
        ingredients: ingredients,
      );

      await widget._cocktailRepository.postCocktail(newCocktailData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cocktail erfolgreich gespeichert!')),
        );
        // Schließt den Screen und gibt `true` zurück, um ein Refresh der Liste auszulösen
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Speichern: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neuen Cocktail erstellen'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Feld
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name des Cocktails *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_bar),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Bitte Name eingeben' : null,
              ),
              const SizedBox(height: 16),

              // Geschmack / Taste
              TextFormField(
                controller: _tasteController,
                decoration: const InputDecoration(
                  labelText: 'Geschmack (z. B. Frisch & Spritzig)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.palette),
                ),
              ),
              const SizedBox(height: 16),

              // Rating
              TextFormField(
                controller: _ratingController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Bewertung (1.0 - 5.0)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.star),
                ),
                validator: (val) {
                  final num = double.tryParse(val ?? '');
                  if (num == null || num < 1.0 || num > 5.0) {
                    return 'Bitte Zahl zwischen 1.0 und 5.0 eingeben';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Zutaten Bereich
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Zutaten',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton.icon(
                    onPressed: _addIngredientRow,
                    icon: const Icon(Icons.add),
                    label: const Text('Zutat hinzufügen'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Dynamische Zutaten Zeilen
              ..._ingredientControllers.asMap().entries.map((entry) {
                final index = entry.key;
                final controllers = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      // Menge
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: controllers['amount'],
                          decoration: const InputDecoration(
                            labelText: 'Menge (z.B. 5 cl)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Zutat Name
                      // Zutat Name Spalte
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Das DropdownMenu (wird NICHT neu gebaut beim Tippen -> Fokus bleibt erhalten!)
                            _isLoadingIngredients
                                ? const SizedBox(
                                    height: 50,
                                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                  )
                                : DropdownMenu<String>(
                                    controller: controllers['name'],
                                    expandedInsets: EdgeInsets.zero,

                                    requestFocusOnTap: true,
                                    enableFilter: true,
                                    enableSearch: true,

                                    label: const Text('Zutat (z.B. Rum)'),
                                    dropdownMenuEntries: _availableIngredients.map((ingredient) {
                                      return DropdownMenuEntry<String>(
                                        value: ingredient.name,
                                        label: ingredient.name,
                                      );
                                    }).toList(),
                                    onSelected: (String? selectedValue) {
                                      if (selectedValue != null) {
                                        controllers['name']!.text = selectedValue;
                                      }
                                    },
                                  ),

                            // 2. Grüner Hinweis NUR unter dem Feld (horcht auf den Controller)
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: controllers['name']!,
                              builder: (context, textValue, _) {
                                final inputText = textValue.text.trim();

                                // Prüfen, ob der Text neu ist
                                final isNew = inputText.isNotEmpty &&
                                    !_availableIngredients.any(
                                      (ing) => ing.name.toLowerCase() == inputText.toLowerCase(),
                                    );

                                if (!isNew) return const SizedBox.shrink();

                                return const Padding(
                                  padding: EdgeInsets.only(top: 4.0, left: 2.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.add_circle, size: 14, color: Colors.green),
                                      SizedBox(width: 4),
                                      Text(
                                        'Neue Zutat – wird angelegt',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      // Löschen Button (nur anzeigen, wenn mehr als 1 Zeile existiert)
                      if (_ingredientControllers.length > 1)
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red),
                          onPressed: () => _removeIngredientRow(index),
                        ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 32),

              // Speichern Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submitForm,
                  icon: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(Icons.save),
                  label: Text(
                    _isSubmitting ? 'Speichert...' : 'Cocktail Speichern',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}