import 'package:flutter/material.dart';

enum TicketStatus {
  open,
  ptwPending,
  ptwApproved,
  ptwRejected,
  inProgress,
  ptcPending,
  ptcApproved,
  ptcRejected,
  closed,
}

/// ================= DISPLAY TEXT + COLOR =================
extension TicketStatusExt on TicketStatus {
  String get displayText {
    switch (this) {
      case TicketStatus.open:
        return 'Open';

      case TicketStatus.ptwPending:
        return 'PTW - Pending';

      case TicketStatus.ptwApproved:
        return 'PTW - Approved';

      case TicketStatus.ptwRejected:
        return 'PTW - Rejected';

      case TicketStatus.inProgress:
        return 'In Progress';

      case TicketStatus.ptcPending:
        return 'PTC - Pending';

      case TicketStatus.ptcApproved:
        return 'PTC - Approved';

      case TicketStatus.ptcRejected:
        return 'PTC - Rejected';

      case TicketStatus.closed:
        return 'Closed';
    }
  }

  Color get color {
    switch (this) {
      case TicketStatus.open:
      case TicketStatus.ptwPending:
      case TicketStatus.ptcPending:
        return Colors.orange;

      case TicketStatus.ptwApproved:
      case TicketStatus.ptcApproved:
        return Colors.green;

      case TicketStatus.inProgress:
        return Colors.blue;

      case TicketStatus.ptwRejected:
      case TicketStatus.ptcRejected:
        return Colors.red;

      case TicketStatus.closed:
        return Colors.grey;
    }
  }
}

/// ================= ACTION LOGIC =================
extension TicketStatusActionExt on TicketStatus {
  /// Should action button be visible
  bool get hasAction {
    switch (this) {
      case TicketStatus.open:
      case TicketStatus.ptwRejected:
      case TicketStatus.ptwApproved:
      case TicketStatus.inProgress:
      case TicketStatus.ptcRejected:
        return true;

      case TicketStatus.ptwPending:
      case TicketStatus.ptcPending:
      case TicketStatus.ptcApproved:
      case TicketStatus.closed:
        return false;
    }
  }

  /// Action button label
  String get actionLabel {
    switch (this) {
      case TicketStatus.open:
      case TicketStatus.ptwRejected:
        return 'Initiate PTW';

      case TicketStatus.ptwApproved:
        return 'Start Work';

      case TicketStatus.inProgress:
        return 'Initiate PTC';

      case TicketStatus.ptcRejected:
        return 'Resume Work';

      default:
        return '';
    }
  }
}
