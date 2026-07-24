import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ShipmentBarChart extends StatelessWidget {
  final int delivered;
  final int pending;

  const ShipmentBarChart({
    super.key,
    required this.delivered,
    required this.pending,
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
              "Shipment Statistics",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (delivered > pending
                      ? delivered
                      : pending)
                      .toDouble() +
                      5,
                  barGroups: [

                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: delivered.toDouble(),
                          width: 30,
                          color: Colors.green,
                        ),
                      ],
                    ),

                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: pending.toDouble(),
                          width: 30,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ],

                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget:
                            (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text(
                                  "Delivered");
                            case 1:
                              return const Text(
                                  "Pending");
                            default:
                              return const Text("");
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}