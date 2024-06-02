import 'package:flutter/material.dart';
import 'package:owpet/src/models/pet.dart';
import 'package:owpet/src/services/pet_service.dart';
import 'package:provider/provider.dart';

class SearchProvider with ChangeNotifier {
  List<Pet> _allPets = [];
  List<Pet> _filteredPets = [];

  List<Pet> get pets => _filteredPets.isEmpty ? _allPets : _filteredPets;

  Future<void> fetchPets(BuildContext context, String userId) async {
    _allPets = await context.read<PetService>().getMyPets(userId);
    _filteredPets = _allPets;
    notifyListeners();
  }

  void search(String query) {
    if (query.isEmpty) {
      _filteredPets = _allPets;
    } else {
      _filteredPets = _allPets.where((pet) {
        return pet.name.toLowerCase().contains(query.toLowerCase()) ||
               pet.species!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
