import 'package:flutter/material.dart';
import 'package:leben_in_deutschland/models/exam_result_model.dart';
import 'package:leben_in_deutschland/screens/examPages/exam_result_page.dart';
import 'package:leben_in_deutschland/viewModels/exam_result_view_model.dart';
import 'package:provider/provider.dart';

class AllExamResultsPage extends StatelessWidget {
  const AllExamResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ExamResultViewModel examResultViewModel = Provider.of<ExamResultViewModel>(context);
    examResultViewModel.getExamResult();
    List<ExamResultModel> allExamResults = examResultViewModel.allExamResults;
    allExamResults = allExamResults.reversed.toList();
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: allExamResults.length,
        itemBuilder: (context, index) {
          double score = ((allExamResults[index].correctQuestionCount / 33) * 100).roundToDouble();
          String status = score > 50 ? "Erfolgreich" : "Erfolglos";
          String time = "${allExamResults[index].time.minute}:${allExamResults[index].time.second}";
          return Card(
            child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Richtig: ${allExamResults[index].correctQuestionCount}"),
                    Text("Falsch: ${allExamResults[index].falseQuestionCount}"),
                    Text("Leer: ${allExamResults[index].blankQuestionCount}")
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Dauer: $time"),
                    Text("Punkt: $score"),
                    Text("Situation: $status"),
                  ],
                ),
                onTap: () {
                  examResultViewModel.setExamResult = allExamResults[index];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExamResultPage(
                        allExamResults[index],
                      ),
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}
