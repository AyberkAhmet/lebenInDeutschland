import 'package:flutter/material.dart';
import 'package:leben_in_deutschland/constants/list_constants.dart';
import 'package:leben_in_deutschland/constants/string_constants.dart';
import 'package:leben_in_deutschland/extensions/context_extension.dart';
import 'package:leben_in_deutschland/models/exam_result_model.dart';
import 'package:leben_in_deutschland/screens/examPages/exam_result_questions_page.dart';
import 'package:leben_in_deutschland/screens/home_page.dart';
import 'package:pie_chart/pie_chart.dart';

class ExamResultPage extends StatelessWidget {
  final ExamResultModel examResult;
  const ExamResultPage(this.examResult, {super.key});

  @override
  Widget build(BuildContext context) {
    final double score = double.parse(((examResult.correctQuestionCount / 33) * 100).toStringAsFixed(2));
    final String status = score > 50 ? "Erfolgreich" : "Erfolglos";

    final Map<String, double> dataMap = {
      "Richtig": examResult.correctQuestionCount.toDouble(),
      "Falsch": examResult.falseQuestionCount.toDouble(),
      "Leerer": examResult.blankQuestionCount.toDouble(),
    };

    Duration chartAnimationDuration = const Duration(milliseconds: 800);

    List<String> tableTitles = [
      trueQuestionCountText,
      falseQuestionCountText,
      blankQuestionCountText,
      scoreCountText,
      timeCountText,
      statusText,
    ];

    List<String> tableCounts = [
      examResult.correctQuestionCount.toString(),
      examResult.falseQuestionCount.toString(),
      examResult.blankQuestionCount.toString(),
      score.toString(),
      "${examResult.time.minute}:${examResult.time.second}",
      status,
    ];

    return Scaffold(
      appBar: AppBar(
        leading: _buildBackButton(context),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: _buildPieChart(dataMap, chartAnimationDuration, context),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.normalValue),
              child: _buildExamResultInfoCard(context, tableTitles, tableCounts),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildExamResultQuestionButton(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildExamResultQuestionButton(BuildContext context) {
    return SizedBox(
      height: context.mediumValue,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ExamResultQuestionsPage()));
        },
        child: Text(
          "Siehe alle Prüfungsfragen",
          style: context.primaryTextTheme.titleLarge,
        ),
      ),
    );
  }

  BackButton _buildBackButton(BuildContext context) {
    return BackButton(
      onPressed: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
          (route) => false),
    );
  }

  Table _buildExamResultInfoCard(BuildContext context, List<String> tableTitles, List<String> tableCounts) {
    return Table(
      border: const TableBorder(horizontalInside: BorderSide(), bottom: BorderSide()),
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(flex: 1),
        1: IntrinsicColumnWidth(flex: 0.5),
      },
      children: List.generate(6, (index) => _buildTableRow(context, tableTitles[index], tableCounts[index])),
    );
  }

  TableRow _buildTableRow(BuildContext context, String tableTitle, String tableCount) {
    return TableRow(
      children: [
        _buildTableCellTitleOrCount(context, tableTitle),
        _buildTableCellTitleOrCount(context, tableCount),
      ],
    );
  }

  Widget _buildTableCellTitleOrCount(BuildContext context, String titleOrCount) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: SizedBox(
        height: context.mediumValue,
        child: Center(
          child: Text(titleOrCount, style: context.primaryTextTheme.titleLarge),
        ),
      ),
    );
  }

  PieChart _buildPieChart(Map<String, double> dataMap, Duration chartAnimationDuration, BuildContext context) {
    return PieChart(
      dataMap: dataMap,
      animationDuration: chartAnimationDuration,
      chartLegendSpacing: 32,
      chartRadius: context.width / 2,
      colorList: pieChartItemsColors,
      initialAngleInDegree: 0,
      chartType: ChartType.disc,
      ringStrokeWidth: 32,
      legendOptions: const LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
        decimalPlaces: 1,
      ),
    );
  }
}
