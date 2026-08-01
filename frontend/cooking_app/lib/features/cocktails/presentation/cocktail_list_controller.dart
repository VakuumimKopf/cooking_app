import 'package:flutter/foundation.dart';
import '../domain/cocktail.dart';
import '../domain/cocktail_repository.dart';

enum CocktailListStatus { initial, loading, success, error }

class CocktailListController extends ChangeNotifier {
  final CocktailRepository _repository;

  CocktailListController(this._repository);

  CocktailListStatus _status = CocktailListStatus.initial;
  List<Cocktail> _cocktails = [];
  String? _errorMessage;

  // Getter für die UI
  CocktailListStatus get status => _status;
  List<Cocktail> get cocktails => _cocktails;
  String? get errorMessage => _errorMessage;

  Future<void> loadCocktails() async {
    _status = CocktailListStatus.loading;
    notifyListeners(); // Benachrichtigt die UI: "Zeige Ladeindikator"

    try {
      _cocktails = await _repository.fetchCocktails();
      _status = CocktailListStatus.success;
    } catch (e) {
      _errorMessage = 'Fehler beim Laden der Cocktails: $e';
      _status = CocktailListStatus.error;
    }

    notifyListeners(); // Benachrichtigt die UI: "Zeige Liste oder Fehler"
  }
}