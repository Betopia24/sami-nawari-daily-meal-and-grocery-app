import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';

class EarningsChartCard extends StatelessWidget {
  final double totalEarnings;
  final double percentage;
  final List<FlSpot> chartData;
  final List<String> bottomTitles;

  const EarningsChartCard({
    super.key,
    required this.totalEarnings,
    required this.percentage,
    required this.chartData,
    required this.bottomTitles,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate dynamic maxY and interval
    double highestY = 0;
    if (chartData.isNotEmpty) {
      highestY = chartData.map((e) => e.y).reduce(max);
    }
    double maxVal = highestY > 0 ? (highestY * 1.35) : 50.0;
    if (maxVal < 20) maxVal = 20;

    double yInterval = (maxVal / 4).ceilToDouble();
    if (yInterval <= 0) yInterval = 5;
    maxVal = yInterval * 4;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Earnings',
            style: GoogleFonts.outfit(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${totalEarnings.toStringAsFixed(2)}',
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                percentage >= 0 ? Icons.trending_up : Icons.trending_down,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${percentage.toStringAsFixed(1)}% from last month',
                style: GoogleFonts.outfit(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
            child: AspectRatio(
              aspectRatio: 1.5,
              child: Builder(
                builder: (context) {
                  final lineBarData = LineChartBarData(
                    spots: chartData.isNotEmpty
                        ? chartData
                        : const [FlSpot(0, 0)],
                    isCurved: false,
                    color: Colors.white,
                    barWidth: 1.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 2.5,
                          color: Colors.white,
                          strokeWidth: 0,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: false,
                    ),
                  );

                  return LineChart(
                    LineChartData(
                      showingTooltipIndicators: chartData.isNotEmpty
                          ? [
                              ShowingTooltipIndicators([
                                LineBarSpot(lineBarData, 0, chartData.last),
                              ]),
                            ]
                          : [],
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: yInterval,
                        verticalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.white.withValues(alpha: 0.2),
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.white.withValues(alpha: 0.2),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index >= 0 && index < bottomTitles.length) {
                                return Padding(
                                   padding: const EdgeInsets.only(top: 8.0),
                                   child: Text(
                                     bottomTitles[index],
                                     style: GoogleFonts.outfit(
                                       color:
                                           Colors.white.withValues(alpha: 0.9),
                                       fontSize: 10,
                                     ),
                                   ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: yInterval,
                            reservedSize: 32,
                            getTitlesWidget: (value, meta) {
                              if (value == 0) return const SizedBox.shrink();
                              return Text(
                                value.toInt().toString(),
                                style: GoogleFonts.outfit(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 10,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      minX: 0,
                      maxX: bottomTitles.isNotEmpty
                          ? (bottomTitles.length - 1).toDouble()
                          : 0,
                      minY: 0,
                      maxY: maxVal,
                      lineBarsData: [lineBarData],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (touchedSpot) => Colors.white,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((LineBarSpot touchedSpot) {
                              return LineTooltipItem(
                                '\$${touchedSpot.y.toStringAsFixed(2)}',
                                GoogleFonts.outfit(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              );
                            }).toList();
                          },
                        ),
                        handleBuiltInTouches: true,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
