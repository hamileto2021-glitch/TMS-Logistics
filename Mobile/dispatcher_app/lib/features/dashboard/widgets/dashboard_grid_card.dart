import 'package:flutter/material.dart';

class DashboardGridCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const DashboardGridCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

@override
Widget build(BuildContext context) {
return LayoutBuilder(
builder: (context, constraints) {
final compact = constraints.maxHeight < 180;

final padding = compact ? 12.0 : 18.0;
final avatarRadius = compact ? 20.0 : 24.0;
final iconSize = compact ? 22.0 : 26.0;
final valueSize = compact ? 28.0 : 34.0;
final titleSize = compact ? 14.0 : 16.0;
final statusSize = compact ? 11.0 : 13.0;

return Card(
elevation: 8,
shadowColor: color.withValues(alpha: 0.25),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(22),
),
child: InkWell(
borderRadius: BorderRadius.circular(22),
onTap: onTap,
child: Padding(
padding: EdgeInsets.all(padding),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
CircleAvatar(
radius: avatarRadius,
backgroundColor: color.withValues(alpha: .15),
child: Icon(
icon,
color: color,
size: iconSize,
),
),
const Spacer(),
Container(
padding: const EdgeInsets.symmetric(
horizontal: 8,
vertical: 4,
),
decoration: BoxDecoration(
color: Colors.green.withValues(alpha: .15),
borderRadius: BorderRadius.circular(20),
),
child: const Text(
"LIVE",
style: TextStyle(
color: Colors.green,
fontSize: 10,
fontWeight: FontWeight.bold,
),
),
),
],
),

const SizedBox(height: 18),

Text(
value,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: TextStyle(
fontSize: valueSize,
fontWeight: FontWeight.bold,
height: 1,
),
),

const SizedBox(height: 6),

Text(
title,
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: TextStyle(
fontSize: titleSize,
fontWeight: FontWeight.w600,
),
),

const Spacer(),

Row(
children: [
Icon(
Icons.trending_up,
size: compact ? 16 : 18,
color: Colors.green.shade600,
),
const SizedBox(width: 6),
Expanded(
child: Text(
"Operational",
overflow: TextOverflow.ellipsis,
style: TextStyle(
color: Colors.grey.shade700,
fontSize: statusSize,
),
),
),
Icon(
Icons.arrow_forward_ios,
size: 14,
color: Colors.grey.shade500,
),
],
),
],
),
),
),
);
},
);
}
}
