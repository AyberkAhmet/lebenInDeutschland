import 'package:flutter/material.dart';
import 'package:leben_in_deutschland/constants/list_constants.dart';
import 'package:leben_in_deutschland/constants/string_constants.dart';
import 'package:leben_in_deutschland/enums/enums.dart';
import 'package:leben_in_deutschland/extensions/context_extension.dart';
import 'package:leben_in_deutschland/screens/examPages/exam_page.dart';
import 'package:leben_in_deutschland/screens/stateQuestionsPages/state_question_page.dart';

class ChooseStatePage extends StatefulWidget {
  final PageType pageType;
  const ChooseStatePage(this.pageType, {super.key});

  @override
  State<ChooseStatePage> createState() => _ChooseStatePageState();
}

class _ChooseStatePageState extends State<ChooseStatePage> {
  late int _selectedStateIndex;
  @override
  void initState() {
    super.initState();
    _selectedStateIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatesDropDown(),
            _buildStateQuestionsButton(),
          ],
        ),
      ),
    );
  }

  ElevatedButton _buildStateQuestionsButton() {
    return ElevatedButton(
      onPressed: () {
        widget.pageType == PageType.examPage
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExamPage(_selectedStateIndex),
                ))
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StateQuestionPage(_selectedStateIndex),
                ));
      },
      child: Text(
        chooseStateButtonText,
        style: context.primaryTextTheme.titleLarge,
      ),
    );
  }

  DropdownButton<int> _buildStatesDropDown() {
    return DropdownButton<int>(
      alignment: Alignment.center,
      value: _selectedStateIndex,
      items: List.generate(
          allStates.length,
          (index) => DropdownMenuItem(
              value: index,
              child: Text(
                allStates[index],
                style: context.primaryTextTheme.titleLarge,
              ))),
      onChanged: (value) {
        _selectedStateIndex = value!;
        setState(() {});
      },
    );
  }
}
