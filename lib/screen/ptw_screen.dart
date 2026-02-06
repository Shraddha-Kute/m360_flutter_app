import 'package:flutter/material.dart';
import '../services/ticket_service.dart';
import '../utils/ticket_status.dart';

class PtwScreen extends StatefulWidget {
  const PtwScreen({super.key});

  @override
  State<PtwScreen> createState() => _PtwScreenState();
}

class _PtwScreenState extends State<PtwScreen> {
  late Future<List<Map<String, dynamic>>> _ptwFuture;

  @override
  void initState() {
    super.initState();
    _ptwFuture = TicketService.getPendingPTW();
  }

  void _refresh() {
    setState(() {
      _ptwFuture = TicketService.getPendingPTW();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// ✅ SAME AS PTC
      backgroundColor: Colors.white,

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _ptwFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No PTW pending requests',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final ptwList = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: ptwList.length,
            itemBuilder: (context, index) {
              final p = ptwList[index];
              return _ptwCard(context, p);
            },
          );
        },
      ),
    );
  }

  /// ================= PTW CARD =================
  Widget _ptwCard(BuildContext context, Map<String, dynamic> p) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 5,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===== ROW 1: TITLE + HISTORY ICON =====
            Row(
              children: [
                Expanded(
                  child: Text(
                    p['eventCode'] ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.history, color: Colors.blueGrey),
                  tooltip: 'View History',
                  onPressed: () => _showHistory(
                    context,
                    ticketId: p['id'],
                    ticketCode: p['eventCode'] ?? 'TCK_${p['id']}',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              p['machineName'] ?? '-',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 14),

            /// 🔹 DETAILS (UNCHANGED)
            _infoRow(Icons.person, 'Raised By', p['createdBy']),
            _infoRow(
                Icons.rule, 'Guidelines', _boolText(p['isGuidelineChecked'])),
            _infoRow(
                Icons.security, 'PPE Kit', _boolText(p['isPPEKitChecked'])),

            const SizedBox(height: 18),

            /// 🔹 ACTION BUTTONS (UNCHANGED)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,

                      /// 👇 TEXT STYLE
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _takeAction(context, p, true),
                    child: const Text('Approve'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _takeAction(context, p, false),
                    child: const Text('Reject'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ================= INFO ROW =================
  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _boolText(dynamic value) {
    if (value == true) return 'Yes';
    if (value == false) return 'No';
    return '-';
  }

  /// ================= TAKE ACTION =================
  Future<void> _takeAction(
      BuildContext context,
      Map<String, dynamic> ptw,
      bool approve,
      ) async {
    final success = await TicketService.takePtwAction(
      eventId: ptw['id'],
      comment: approve
          ? 'Reviewed PTW request. Approved to proceed.'
          : 'PTW rejected due to safety concerns.',
      isApproved: approve,
      raisedBy: ptw['createdBy'],
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: approve ? Colors.green : Colors.red,
          content: Text(
            approve
                ? 'PTW is Approved Successfully'
                : 'PTW is Rejected',
          ),
        ),
      );
      _refresh();
    }
  }

  /// ================= HISTORY =================
  Future<void> _showHistory(
      BuildContext context, {
        required int ticketId,
        required String ticketCode,
      }) async {
    final history = await TicketService.getTicketHistory(ticketId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.fromLTRB(16, 14, 8, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ticket History',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ticket: $ticketCode',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () =>
                          Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child:
                _HistoryDataTable(history: history),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// ================= HISTORY TABLE =================
class _HistoryDataTable extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  const _HistoryDataTable({required this.history});

  TicketStatus _parseHistoryStatus(String? status) {
    switch (status) {
      case 'Open':
        return TicketStatus.open;
      case 'Ptw_Pending':
        return TicketStatus.ptwPending;
      case 'Ptw_Approved':
        return TicketStatus.ptwApproved;
      case 'Ptw_Rejected':
        return TicketStatus.ptwRejected;
      case 'InProgress':
        return TicketStatus.inProgress;
      case 'Ptc_Pending':
        return TicketStatus.ptcPending;
      case 'Ptc_Rejected':
        return TicketStatus.ptcRejected;
      case 'Closed':
        return TicketStatus.closed;
      default:
        return TicketStatus.open;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor:
        MaterialStateProperty.all(
            Colors.blueAccent.shade100),
        columns: const [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Action By')),
          DataColumn(label: Text('Comment')),
        ],
        rows: history.map((h) {
          final statusEnum =
          _parseHistoryStatus(h['status']);
          return DataRow(cells: [
            DataCell(Text(formatDate(h['actionDate']))),
            DataCell(
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color:
                  statusEnum.color.withOpacity(0.15),
                  borderRadius:
                  BorderRadius.circular(12),
                ),
                child: Text(
                  statusEnum.displayText,
                  style: TextStyle(
                    color: statusEnum.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            DataCell(
                Text(h['actionByName'] ?? '--')),
            DataCell(
              SizedBox(
                width: 260,
                child: Text(
                  h['actionComment'] ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }
}

/// ================= FORMATTER =================
String formatDate(dynamic date) {
  if (date == null) return '--';
  final d = date.toString();
  return d.length >= 10 ? d.substring(0, 10) : d;
}
