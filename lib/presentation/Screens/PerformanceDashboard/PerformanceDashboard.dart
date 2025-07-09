import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/course_screen.dart';

class PerformanceDashboard extends StatefulWidget {
  final String token;

  const PerformanceDashboard({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  _PerformanceDashboardState createState() => _PerformanceDashboardState();
}

class _PerformanceDashboardState extends State<PerformanceDashboard> {
  List<PerformanceData> performanceData = [];
  bool isLoading = true;
  String errorMessage = '';

  // Base URL - same as PaymentPage
  final String baseUrl = 'https://elearnbackend-production.up.railway.app';

  @override
  void initState() {
    super.initState();
    fetchPerformanceData();
  }

  Future<void> fetchPerformanceData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final response = await http.get(
        Uri.parse('$baseUrl/api/users/profile/dashboard/performance'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 20));

      debugPrint('🔄 Performance Response: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Handle different response structures
        List<dynamic> jsonData;
        if (responseData is Map<String, dynamic>) {
          // If the response is wrapped in an object
          jsonData = responseData['data'] ?? responseData['performance'] ?? [];
        } else if (responseData is List) {
          // If the response is directly a list
          jsonData = responseData;
        } else {
          throw Exception('Unexpected response format');
        }

        setState(() {
          performanceData = jsonData.map((item) => PerformanceData.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          errorMessage = errorData['message'] ?? 'Failed to load data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ fetchPerformanceData failed: $e');
      setState(() {
        errorMessage = 'Network error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Performance Dashboard'),
        backgroundColor: const Color(0xFF49BBBD),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CoursesScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF49BBBD),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('View Courses'),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF49BBBD)))
          : errorMessage.isNotEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchPerformanceData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF49BBBD),
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: fetchPerformanceData,
        color: const Color(0xFF49BBBD),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistics Cards
              _buildStatisticsCards(),
              const SizedBox(height: 24),

              // Score Trend Chart
              _buildScoreTrendChart(),
              const SizedBox(height: 24),

              // Time Used Chart
              _buildTimeUsedChart(),
              const SizedBox(height: 24),

              // Pass/Fail Chart
              _buildPassFailChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsCards() {
    final totalQuizzes = performanceData.length;
    final averageScore = totalQuizzes > 0
        ? performanceData.map((e) => double.parse(e.percentageScore)).reduce((a, b) => a + b) / totalQuizzes
        : 0.0;
    final totalQuestions = performanceData.fold(0, (sum, item) => sum + item.totalQuestions);
    final passCount = performanceData.where((item) => item.passFail == 'Pass').length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildStatItem('Total Quizzes', totalQuizzes.toString(), Icons.quiz)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatItem('Average Score', '${averageScore.toStringAsFixed(1)}%', Icons.trending_up)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildStatItem('Questions Attempted', totalQuestions.toString(), Icons.help_outline)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatItem('Passed Quizzes', passCount.toString(), Icons.check_circle)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF49BBBD).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF49BBBD), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF49BBBD),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreTrendChart() {
    if (performanceData.isEmpty) {
      return _buildEmptyChart('Score Trend');
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Score Trend',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF49BBBD).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up, color: Color(0xFF49BBBD), size: 16),
                    SizedBox(width: 4),
                    Text('Score (%)', style: TextStyle(fontSize: 12, color: Color(0xFF49BBBD))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < performanceData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Quiz ${value.toInt() + 1}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}%');
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: performanceData.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), double.parse(entry.value.percentageScore));
                    }).toList(),
                    isCurved: true,
                    color: const Color(0xFF49BBBD),
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeUsedChart() {
    if (performanceData.isEmpty) {
      return _buildEmptyChart('Time Used per Quiz');
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Time Used per Quiz',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer, color: Colors.orange, size: 16),
                    SizedBox(width: 4),
                    Text('Time (s)', style: TextStyle(fontSize: 12, color: Colors.orange)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: performanceData.isNotEmpty
                    ? performanceData.map((e) => e.timeUsed.toDouble()).reduce((a, b) => a > b ? a : b) + 10
                    : 100,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < performanceData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Quiz ${value.toInt() + 1}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}s');
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(show: true),
                barGroups: performanceData.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.timeUsed.toDouble(),
                        color: Colors.orange,
                        width: 20,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassFailChart() {
    if (performanceData.isEmpty) {
      return _buildEmptyChart('Pass/Fail');
    }

    final passCount = performanceData.where((item) => item.passFail == 'Pass').length;
    final failCount = performanceData.where((item) => item.passFail == 'Fail').length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Pass/Fail Distribution',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        SizedBox(width: 4),
                        Text('Pass', style: TextStyle(fontSize: 12, color: Colors.green)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cancel, color: Colors.red, size: 16),
                        SizedBox(width: 4),
                        Text('Fail', style: TextStyle(fontSize: 12, color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  if (passCount > 0)
                    PieChartSectionData(
                      color: Colors.green,
                      value: passCount.toDouble(),
                      title: '$passCount\nPass',
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  if (failCount > 0)
                    PieChartSectionData(
                      color: Colors.red,
                      value: failCount.toDouble(),
                      title: '$failCount\nFail',
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                ],
                centerSpaceRadius: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChart(String title) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          Icon(
            Icons.bar_chart,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No data available',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class PerformanceData {
  final String courseTitle;
  final String quizTitle;
  final int score;
  final int timeUsed;
  final String completedAt;
  final String percentageScore;
  final String passFail;
  final int totalQuestions;

  PerformanceData({
    required this.courseTitle,
    required this.quizTitle,
    required this.score,
    required this.timeUsed,
    required this.completedAt,
    required this.percentageScore,
    required this.passFail,
    required this.totalQuestions,
  });

  factory PerformanceData.fromJson(Map<String, dynamic> json) {
    return PerformanceData(
      courseTitle: json['courseTitle']?.toString() ?? 'Unknown',
      quizTitle: json['quizTitle']?.toString() ?? 'Unknown',
      score: int.tryParse(json['score']?.toString() ?? '0') ?? 0,
      timeUsed: int.tryParse(json['timeUsed']?.toString() ?? '0') ?? 0,
      completedAt: json['completedAt']?.toString() ?? '',
      percentageScore: json['percentageScore']?.toString() ?? '0.00',
      passFail: json['passFail']?.toString() ?? 'Fail',
      totalQuestions: int.tryParse(json['totalQuestions']?.toString() ?? '0') ?? 0,
    );
  }
}