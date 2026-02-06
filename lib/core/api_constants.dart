class ApiConstants {
  // ✅ EXACT SAME URL THAT WORKS IN POSTMAN
  static const String baseUrl =
      'https://m360-bycwh7azcsc7bbd8.centralindia-01.azurewebsites.net/api';

  // 🔐 Auth
  static const String login = '$baseUrl/Auth/Login';

  // 📋 All Machine
  static const String getmachine = '$baseUrl/Machine/GetAll';

  // 👤 Add Ticket
  static const String addTicket = '$baseUrl/Ticket/Add';

  //All Ticket
  static const String getAllTickets = '$baseUrl/Ticket/GetAllTickets';

  //History
  static const String getTicketHistory = '$baseUrl/Ticket/History';

  //Initiate PTW
  static const String initiatePTW = '$baseUrl/Ticket/InitiatePTW';


  //fetch PTW pending
  static const String ptwPendingEvent = '$baseUrl/Ticket/GetAllPtwPendingTickets';

  //take PTW action
  static const String takePtwAction = '$baseUrl/Ticket/TakePtwAction';

  //start action
  static const String startAction = '$baseUrl/Ticket/StartWork';

  //request to closer
  static const String closeAction = '$baseUrl/Ticket/RequestToCloser';

  // GET all pending PTC tickets (ADMIN)
  static const String getPtcPending =
      '$baseUrl/Ticket/GetAllPtcPendingTickets';
// OR '$baseUrl/Ticket/PtcPendingEvent'

// POST approve / reject PTC (ADMIN action)
  static const String takePtcAction =
      '$baseUrl/Ticket/TakePtcAction';


}
