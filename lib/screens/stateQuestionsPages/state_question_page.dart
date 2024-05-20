import 'package:flutter/material.dart';
import 'package:leben_in_deutschland/enums/enums.dart';
import 'package:leben_in_deutschland/models/question_model.dart';
import 'package:leben_in_deutschland/viewModels/question_view_model.dart';
import 'package:leben_in_deutschland/widgets/question_widget.dart';
import 'package:provider/provider.dart';

class StateQuestionPage extends StatefulWidget {
  final int _selectedStateIndex;
  const StateQuestionPage(this._selectedStateIndex, {super.key});

  @override
  State<StateQuestionPage> createState() => _StateQuestionPageState();
}

class _StateQuestionPageState extends State<StateQuestionPage> {
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final QuestionViewModel questionsViewModel = Provider.of<QuestionViewModel>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: PageView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return _buildQuestionPages(questionsViewModel.questions, 300 + (widget._selectedStateIndex * 10) + index);
          },
          allowImplicitScrolling: true,
          controller: controller,
          //children: _buildQuestionPages(questions!).toList(),
        ),
      ),
    );
  }

  Widget _buildQuestionPages(List<QuestionModel> questions, int i) {
    return QuestionWidget(questions[i].id, PageType.stateQuestionPage);
  }
}
