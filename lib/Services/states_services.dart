import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:two_covid_tracker/Services/Utilies/app_url.dart';
import '../Model/World_state_model.dart';

class StateServices {
  Future<World_states_model> fetchWorkedStatesRecords() async {
    final response = await http.get(Uri.parse(AppUrl.worldStatesApi));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return World_states_model.fromJson(data);
    } else {
      throw Exception("Error");
    }
  }

  Future<List<dynamic>> countriesListApi() async {
    final response = await http.get(Uri.parse(AppUrl.countriesList));
    var data;
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      //print(data);

      // Check if the data is a list (JSON array)
      // Convert each item in the list to a country_model object

      print("countrylist");
      //List<country_model> countryList =
      // data.map((item) => country_model.fromJson(item));
      return data;
    } else {
      print("error ");
      throw Exception("Error");
    }
  }
}
