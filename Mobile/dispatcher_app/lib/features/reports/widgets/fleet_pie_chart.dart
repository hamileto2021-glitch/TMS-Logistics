import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class FleetPieChart extends StatelessWidget {
  final int available;
  final int busy;
  final int maintenance;

  const FleetPieChart({
    super.key,
    required this.available,
    required this.busy,
    required this.maintenance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const Text(
              "Fleet Status",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 45,
                  sections: [

                    PieChartSectionData(
                      value: available.toDouble(),
                      color: Colors.green,
                      title: available.toString(),
                    ),

                    PieChartSectionData(
                      value: busy.toDouble(),
                      color: Colors.orange,
                      title: busy.toString(),
                    ),

                    PieChartSectionData(
                      value: maintenance.toDouble(),
                      color: Colors.red,
                      title: maintenance.toString(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                _Legend(
                  color: Colors.green,
                  text: "Available",
                ),

                _Legend(
                  color: Colors.orange,
                  text: "Busy",
                ),

                _Legend(
                  color: Colors.red,
                  text: "Maintenance",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;

  const _Legend({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Container(
          width: 12,
          height: 12,
          color: color,
        ),

        const SizedBox(width: 6),

        Text(text),
      ],
    );
  }
}