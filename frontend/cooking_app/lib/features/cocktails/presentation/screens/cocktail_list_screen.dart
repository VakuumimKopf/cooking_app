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
      appBar: AppBar(title: const Text('Cocktail Rezepte')),
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
                  return CocktailCard(cocktail: cocktail);
                },
              );
          }
        },
      ),
    );
  }
}