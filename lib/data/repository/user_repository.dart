import 'dart:convert';
import 'package:assessment/screens/User/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final String apiUrl = "https://dummyjson.com/users?limit=100&skip=0";

  Future<List<User>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        //final List data = jsonDecode(response.body);

        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> usersJson = body['users'];

        List<User> users = usersJson.map((json) => User.fromJson(json)).toList();

        // Cache the data
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('users_cache', jsonEncode(usersJson));

        return users;
      } else {
        throw Exception("Failed to load users");
      }
    } catch (e) {
      // Offline mode - load from cache
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('users_cache');
      if (cachedData != null) {
        final List data = jsonDecode(cachedData);
        return data.map<User>((json) => User.fromJson(json)).toList();
      } else {
        throw Exception("No Internet and No Cache Available");
      }
    }
  }
}
