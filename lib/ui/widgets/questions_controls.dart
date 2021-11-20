import 'dart:developer';

import 'package:flutter/material.dart';

class QuestionsControls extends StatefulWidget {
  final PageController pageController;
  final Function onSubmit;
  final int noOfQuestions;

  const QuestionsControls({Key? key, required this.pageController, required this.onSubmit, required this.noOfQuestions})
      : super(key: key);

  @override
  _QuestionsControlsState createState() => _QuestionsControlsState();
}

class _QuestionsControlsState extends State<QuestionsControls> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log(widget.pageController.page.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if ((widget.pageController.page ?? 0) > 0)
          TextButton(
              style: TextButton.styleFrom(padding: const EdgeInsets.only()),
              onPressed: () => {
                    widget.pageController
                        .previousPage(
                            duration: const Duration(milliseconds: 1),
                            curve: Curves.easeInOut)
                        .then((value) {
                      setState(() {});
                    })
                  },
              child: Row(children: const [
                Icon(Icons.arrow_back),
                SizedBox(
                  width: 10,
                ),
                Text("Previous Question")
              ])),
        if ((widget.pageController.page ?? 0) > 0 ||
            (widget.pageController.page ?? 0) < widget.noOfQuestions-1)
          const Spacer(),
        ((widget.pageController.page ?? 0) < widget.noOfQuestions-1)
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(left: 10, right: 7)),
                onPressed: () => {
                      widget.pageController
                          .nextPage(
                              duration: const Duration(milliseconds: 1),
                              curve: Curves.easeInOut)
                          .then((value) {
                        setState(() {});
                      })
                    },
                child: Row(mainAxisSize: MainAxisSize.min, children: const [
                  Text("Next Question"),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.arrow_forward)
                ]))
            : ElevatedButton(
                onPressed: () => {widget.onSubmit()},
                child: Row(
                  children: const [
                    Text("Submit Test"),
                    SizedBox(width: 10,),
                    Icon(Icons.check)
                  ],
                ),
                style: ElevatedButton.styleFrom(),
              )
      ],
    );
  }
}
