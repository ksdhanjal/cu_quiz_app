import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  final Map question;
  final int questionIndex;
  final int totalQuestions;
  final Function(bool) isMarkedAnswerCorrect;

  const QuestionPage(
      {Key? key,
      required this.question,
      required this.questionIndex,
      required this.totalQuestions,
      required this.isMarkedAnswerCorrect})
      : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage>
    with AutomaticKeepAliveClientMixin {
  List<String> allOptions = [];
  int? selectedIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (var option in widget.question["incorrectOptions"]) {
      allOptions.add(option);
    }
    allOptions.add(widget.question["correctOption"].toString());
    allOptions.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey.shade300),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Question ${widget.questionIndex + 1} of ${widget.totalQuestions}",
                  style: const TextStyle(color: Colors.blue),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "${widget.question['question']}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 18),
                )
              ],
            ),
          ),
        ),
        buildOptions(options: allOptions),
      ],
    );
  }

  Widget buildOptions({required List<String> options}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: ListView.separated(
          separatorBuilder: (ctx, i) => const SizedBox(
                height: 15,
              ),
          shrinkWrap: true,
          itemCount: options.length,
          itemBuilder: (ctx, index) => OptionRadioButton(
                text: options[index],
                isSelected: selectedIndex == index ? true : false,
                index: index,
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                    bool isCorrect =
                        widget.question["correctOption"] == allOptions[index];
                    widget.isMarkedAnswerCorrect(isCorrect);
                  });
                },
              )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class OptionRadioButton extends StatelessWidget {
  final String text;
  final int index;
  final bool isSelected;
  final Function(int)? onTap;

  const OptionRadioButton(
      {Key? key,
      this.text = "",
      this.index = 1,
      this.isSelected = false,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
              width: 2,
              color: !isSelected ? Colors.grey.shade300 : Colors.blue)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          onTap!(index);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Row(
            children: [
              Text(
                "${index + 1}. $text",
                style:
                    TextStyle(color: isSelected ? Colors.blue : Colors.black),
              ),
              const Spacer(),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected ? Colors.blue : Colors.grey.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
