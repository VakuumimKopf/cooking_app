import 'package:cooking_app/features/cocktails/data/ingredient_repository_impl.dart';
import 'package:cooking_app/features/cocktails/presentation/screens/cocktail_add_screen.dart';
import 'package:cooking_app/features/cocktails/presentation/screens/cocktail_detail_screen.dart';
import 'package:flutter/material.dart';
import '../../data/cocktail_repository_impl.dart';
import '../cocktail_list_controller.dart';
import '../cocktail_card.dart';

class CocktailListScreen extends StatefulWidget {
  const CocktailListScreen({super.key});

  @override
  State<CocktailListScreen> createState() => _CocktailListScreenState();
}

class _CocktailListScreenState extends State<CocktailListScreen> {
  late final CocktailListController _controller;

  @override
  void initState() {
    super.initState();
    // 1. Controller mit Datenquelle verbinden
    _controller = CocktailListController(CocktailRepositoryImpl());
    // 2. Datenabruf beim Start auslösen
    _controller.loadCocktails();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cocktail Rezepte'), 
        actions: [
          IconButton(onPressed: _controller.loadCocktails, icon: Icon(Icons.replay_outlined))
         ],),
      // ListenableBuilder horcht auf notifyListeners() vom Controller
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          switch (_controller.status) {
            case CocktailListStatus.initial:
            case CocktailListStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case CocktailListStatus.error:
              return Center(
                child: Text(_controller.errorMessage ?? 'Unbekannter Fehler'),
              );

            case CocktailListStatus.success:
              return ListView.builder(
                itemCount: _controller.cocktails.length,
                itemBuilder: (context, index) {
                  final cocktail = _controller.cocktails[index];

                  return CocktailCard(
                    cocktail: cocktail,
                    onDelete: () async {
                      final bool? wasDeleted = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CocktailDetailScreen(
                            cocktail: cocktail, 
                            cocktailRepository: CocktailRepositoryImpl(),
                        ),
                      ),
                    );

                    if (wasDeleted == true) {
                      _controller.loadCocktails();
                    }
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Navigiert zum Add Screen
          final bool? cocktailAdded = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => CocktailAddScreen(
                cocktailRepository: CocktailRepositoryImpl(),
                ingredientRepository: IngredientRepositoryImpl(),
            )),
          );

          // Falls der Screen mit `true` geschlossen wurde, Liste neu laden!
          if (cocktailAdded == true) {
            _controller.loadCocktails();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Cocktail hinzufügen'),
      ),
    );
  }
}