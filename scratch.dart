import 'package:fl_chart/fl_chart.dart';
void main() {
  var data = LineChartBarData(spots: [FlSpot(0,0)]);
  ShowingTooltipIndicators indicators = ShowingTooltipIndicators([LineBarSpot(data, 0, FlSpot(0,0))]);
}
