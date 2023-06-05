import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/search_suggestion_model.dart';

class SharedPreferencesHelper {
  saveData(MovieSuggestionModel searchItem) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = await getJsonData();
    List jsonList = jsonDecode(json);
    bool contain = false;
    for (var item in jsonList) {
      if (item["id"] == searchItem.id) {
        contain = true;
        break;
      }
    }
    if (!contain) {
      jsonList.add(searchItem.toJson());
      prefs.setString("search_key", jsonEncode(jsonList));
    }
  }

  getJsonData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("search_key") ?? '[]';
  }

  Future<List<MovieSuggestionModel>> getSearchList() async {
    String json = await getJsonData();
    List<dynamic> list = jsonDecode(json);
    List<MovieSuggestionModel> movieList = [];
    for (var element in list) {
      movieList.add(MovieSuggestionModel.fromJson(element));
    }
    return movieList;
  }
}
