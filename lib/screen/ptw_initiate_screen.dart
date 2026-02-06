import 'package:flutter/material.dart';
import '../services/ticket_service.dart';

class InitiatePTWScreen extends StatefulWidget {
  final int eventId;

  const InitiatePTWScreen({
    super.key,
    required this.eventId,
  });

  @override
  State<InitiatePTWScreen> createState() => _InitiatePTWScreenState();
}

class _InitiatePTWScreenState extends State<InitiatePTWScreen> {
  bool isGuidelineChecked = false;
  bool isPPEKitChecked = false;
  bool isLoading = false;

  Future<void> _submitPTW() async {
    if (!isGuidelineChecked || !isPPEKitChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please confirm all safety checks'),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    final success = await TicketService.initiatePTW(
      eventId: widget.eventId,
      isGuidelineChecked: isGuidelineChecked,
      isPPEKitChecked: isPPEKitChecked,
    );

    setState(() => isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PTW initiated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        elevation: 0,
        centerTitle: true,

        /// 🔹 LEFT → APP ICON
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Image.asset(
            'images/appBarIcon.png',
            height: 36,
            fit: BoxFit.contain,
          ),
        ),

        title: const Text(
          'Initiate PTW',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      /// ===== BODY =====
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            elevation: 6,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 HEADER
                  const Text(
                    'Safety Confirmation',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Please confirm the following before initiating PTW',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 CHECK 1
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: const Color(0xFF1E88E5),
                    title: const Text(
                      'Safety guidelines read & understood',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    value: isGuidelineChecked,
                    onChanged: (v) =>
                        setState(() => isGuidelineChecked = v!),
                  ),

                  /// 🔹 CHECK 2
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: const Color(0xFF1E88E5),
                    title: const Text(
                      'PPE Kit is available and worn',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    value: isPPEKitChecked,
                    onChanged: (v) =>
                        setState(() => isPPEKitChecked = v!),
                  ),

                  const SizedBox(height: 30),

                  /// 🔹 SUBMIT BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitPTW,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xFF1E88E5),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text('Submit PTW'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
