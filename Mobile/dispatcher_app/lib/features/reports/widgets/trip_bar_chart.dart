import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TripBarChart extends StatelessWidget {
  final int completed;
  final int active;

  const TripBarChart({
    super.key,
    required this.completed,
    required this.active,
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
              "Trip Statistics",
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
                  alignment:
                  BarChartAlignment.spaceAround,

                  maxY: (completed > active
                      ? completed
                      : active)
                      .toDouble() +
                      5,

                  barGroups: [

                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: completed.toDouble(),
                          width: 30,
                          color: Colors.blue,
                        ),
                      ],
                    ),

                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: active.toDouble(),
                          width: 30,
                          color: Colors.red,
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
                                  "Completed");
                            case 1:
                              return const Text(
                                  "Active");
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