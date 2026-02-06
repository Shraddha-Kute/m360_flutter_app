import 'package:flutter/material.dart';

class M360AppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBack;
  final bool centerTitle;

  const M360AppBar({
    super.key,
    this.title,
    this.showBack = false,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1E88E5),
      elevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: showBack,

      /// 🔹 LEFT LOGO
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Image.asset(
          'images/appBarIcon.png',
          height: 48,
          fit: BoxFit.contain,
        ),
      ),

      /// 🔹 OPTIONAL TITLE
      title: title == null
          ? null
          : Text(
        title!,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
