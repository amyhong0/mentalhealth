import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/emotion.dart';

class EmotionPieChart extends StatelessWidget {
  final Map<String, int> emotionCounts;
  final List<Emotion> emotions;

  const EmotionPieChart({
    Key? key,
    required this.emotionCounts,
    required this.emotions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: emotionCounts.isEmpty
          ? Center(child: Text('데이터가 없습니다'))
          : PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: _getSections(),
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    // 터치 이벤트 처리
                  },
                ),
              ),
            ),
    );
  }

  List<PieChartSectionData> _getSections() {
    List<PieChartSectionData> sections = [];
    
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
      Colors.brown,
    ];
    
    int colorIndex = 0;
    emotionCounts.forEach((emotionName, count) {
      final emotion = emotions.firstWhere(
        (e) => e.name == emotionName,
        orElse: () => Emotion(
          id: 0,
          name: emotionName,
          category: '기타',
          imagePath: '',
        ),
      );
      
      sections.add(
        PieChartSectionData(
          color: colors[colorIndex % colors.length],
          value: count.toDouble(),
          title: '$emotionName\n${(count / emotionCounts.values.reduce((a, b) => a + b) * 100).toStringAsFixed(1)}%',
          radius: 100,
          titleStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      
      colorIndex++;
    });
    
    return sections;
  }
}

class EmotionBarChart extends StatelessWidget {
  final Map<String, int> emotionCounts;
  final String title;

  const EmotionBarChart({
    Key? key,
    required this.emotionCounts,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: emotionCounts.isEmpty
          ? Center(child: Text('데이터가 없습니다'))
          : Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: emotionCounts.values.reduce((a, b) => a > b ? a : b).toDouble() * 1.2,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.blueGrey,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            String emotionName = emotionCounts.keys.elementAt(groupIndex);
                            return BarTooltipItem(
                              '$emotionName: ${rod.y.toInt()}회',
                              TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (context, value) => const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          getTitles: (double value) {
                            return emotionCounts.keys.elementAt(value.toInt());
                          },
                          rotateAngle: 45,
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (context, value) => const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          reservedSize: 30,
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: _getBarGroups(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    List<BarChartGroupData> barGroups = [];
    
    int index = 0;
    emotionCounts.forEach((emotionName, count) {
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              y: count.toDouble(),
              colors: [Colors.blue],
              width: 20,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
      
      index++;
    });
    
    return barGroups;
  }
}

class EmotionCategoryChart extends StatelessWidget {
  final Map<String, int> categoryCounts;

  const EmotionCategoryChart({
    Key? key,
    required this.categoryCounts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(16),
      child: categoryCounts.isEmpty
          ? Center(child: Text('데이터가 없습니다'))
          : Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 30,
                      sections: [
                        PieChartSectionData(
                          color: Colors.green,
                          value: categoryCounts['긍정']?.toDouble() ?? 0,
                          title: '긍정',
                          radius: 80,
                          titleStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          color: Colors.red,
                          value: categoryCounts['부정']?.toDouble() ?? 0,
                          title: '부정',
                          radius: 80,
                          titleStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegendItem('긍정', Colors.green, categoryCounts['긍정'] ?? 0),
                      SizedBox(height: 16),
                      _buildLegendItem('부정', Colors.red, categoryCounts['부정'] ?? 0),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLegendItem(String title, Color color, int count) {
    final total = (categoryCounts['긍정'] ?? 0) + (categoryCounts['부정'] ?? 0);
    final percentage = total > 0 ? (count / total * 100).toStringAsFixed(1) : '0.0';
    
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        SizedBox(width: 8),
        Text(
          '$title: $count회 ($percentage%)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
