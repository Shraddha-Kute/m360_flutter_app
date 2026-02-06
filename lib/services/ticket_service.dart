import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../core/api_constants.dart';
import '../core/token_storage.dart';
import '../core/api_client.dart';

class TicketService {

  // ===============================
  // CREATE TICKET (MULTIPART)
  // ===============================
  static Future<bool> createTicket({
    required String description,
    required String machineId,
    required String type,
    required File image,
  }) async {
    final token = await TokenStorage.getToken();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstants.addTicket),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['description'] = description;
    request.fields['machineId'] = machineId;
    request.fields['type'] = type;

    request.files.add(
      await http.MultipartFile.fromPath('file', image.path),
    );

    final response = await request.send();
    final body = await response.stream.bytesToString();

    print('ADD TICKET STATUS => ${response.statusCode}');
    print('ADD TICKET BODY => $body');

    return response.statusCode == 200 || response.statusCode == 201;
  }

  // ===============================
  // GET ALL TICKETS
  // ===============================
  static Future<List<Map<String, dynamic>>> getAllTickets() async {
    final response = await ApiClient.getWithToken(
      ApiConstants.getAllTickets,
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(decoded['data']);
    }
    throw Exception('Failed to load tickets');
  }

  // ===============================
  // TICKET HISTORY
  // ===============================
  static Future<List<Map<String, dynamic>>> getTicketHistory(int ticketId) async {
    final response = await ApiClient.getWithToken(
      '${ApiConstants.getTicketHistory}/$ticketId',
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    }
    throw Exception('Failed to load ticket history');
  }

  // ===============================
  // INITIATE PTW (TECHNICIAN)
  // ===============================
  static Future<bool> initiatePTW({
    required int eventId,
    required bool isGuidelineChecked,
    required bool isPPEKitChecked,
  }) async {
    final response = await ApiClient.postWithToken(
      ApiConstants.initiatePTW,
      {
        "eventId": eventId,
        "isGuidelineChecked": isGuidelineChecked,
        "isPPEKitChecked": isPPEKitChecked,
      },
    );

    return response.statusCode == 200;
  }

  // ===============================
  // GET PTW PENDING (ADMIN)
  // ===============================
  static Future<List<Map<String, dynamic>>> getPendingPTW() async {
    final response =
    await ApiClient.getWithToken(ApiConstants.ptwPendingEvent);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(decoded['data']);
    }
    throw Exception('Failed to load PTW pending events');
  }

  // ===============================
  // TAKE PTW ACTION (ADMIN)
  // ===============================
  static Future<bool> takePtwAction({
    required int eventId,
    required String comment,
    required bool isApproved,
    required String raisedBy,
  }) async {
    final response = await ApiClient.postWithToken(
      ApiConstants.takePtwAction,
      {
        "eventId": eventId,
        "comment": comment,
        "isApproved": isApproved,
        "raisedBy": raisedBy,
      },
    );

    return response.statusCode == 200;
  }

  // ===============================
  // START WORK (TECHNICIAN)
  // ===============================
  static Future<bool> startWork({
    required int eventId,
  }) async {
    final response = await ApiClient.postWithToken(
      ApiConstants.startAction,
      {
        "eventId": eventId,
      },
    );

    print('START WORK STATUS => ${response.statusCode}');
    print('START WORK BODY => ${response.body}');

    return response.statusCode == 200;
  }

  // ===============================
  // INITIATE PTC (TECHNICIAN)
  // ===============================
  static Future<bool> initiatePTC({
    required int eventId,
    required bool isSOPFollowed,
    required bool isMachineWorking,
    required bool isInjuryOccurred,
    File? closerImage,
  }) async {
    final token = await TokenStorage.getToken();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstants.closeAction),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['EventId'] = eventId.toString();
    request.fields['IsSOPFollowed'] = isSOPFollowed.toString();
    request.fields['IsMachineWorking'] = isMachineWorking.toString();
    request.fields['IsInjuryOccurred'] = isInjuryOccurred.toString();

    if (closerImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'CloserImage',
          closerImage.path,
        ),
      );
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();

    print('PTC REQUEST STATUS => ${response.statusCode}');
    print('PTC REQUEST BODY => $body');

    return response.statusCode == 200;
  }

  // ===============================
  // GET PTC PENDING (ADMIN)
  // ===============================
  static Future<List<Map<String, dynamic>>> getPendingPTC() async {
    final response =
    await ApiClient.getWithToken(ApiConstants.getPtcPending);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(decoded['data']);
    }
    throw Exception('Failed to load PTC pending tickets');
  }

  // ===============================
  // TAKE PTC ACTION (ADMIN)
  // ===============================
  static Future<bool> takePtcAction({
    required int eventId,
    required String comment,
    required bool isApproved,
    required String raisedBy,
  }) async {
    final response = await ApiClient.postWithToken(
      ApiConstants.takePtcAction,
      {
        "eventId": eventId,
        "comment": comment,
        "isApproved": isApproved,
        "raisedBy": raisedBy,
      },
    );

    return response.statusCode == 200;
  }
}
