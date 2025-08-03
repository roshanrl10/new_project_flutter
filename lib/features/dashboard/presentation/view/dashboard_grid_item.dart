import 'package:flutter/material.dart';

class DashboardGridItem extends StatelessWidget {
  final IconData iconData;
  final String label;
  final Widget page;

  const DashboardGridItem({
    super.key,
    required this.iconData,
    required this.label,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          () =>
              Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEDE7F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: 60, color: Colors.black),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
