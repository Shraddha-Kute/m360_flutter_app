import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_constants.dart';
import '../core/token_storage.dart';

class MachineService {
  static Future<List<Map<String, dynamic>>> getAllMachines() async {
    final token = await TokenStorage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Token missing');
    }

    final response = await http.get(
      Uri.parse('${ApiConstants.getmachine}?pageNumber=1&pageSize=100'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('MACHINE STATUS => ${response.statusCode}');
    print('MACHINE BODY => ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is Map && decoded['data'] is List) {
        return List<Map<String, dynamic>>.from(decoded['data']);
      }

      throw Exception('Unexpected machine response');
    } else {
      throw Exception('Failed to load machines');
    }
  }
}
