import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

class TestTimer extends StatefulWidget {
  final int time;
  const TestTimer({Key? key,required this.time}) : super(key: key);

  @override
  _TestTimerState createState() => _TestTimerState();
}

class _TestTimerState extends State<TestTimer> {
  int time =0;
  late Timer _timer;

  void startTimer() {
    const oneSec = Duration(seconds: 1);

    _timer = Timer.periodic(oneSec, (timer) {
      if (time >= 0) {
        setState(() {
          time = time - 1;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
    time = widget.time*60;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    try {
      _timer.cancel();
    } catch (e) {
      log(e.toString());
    }
  }

  String getParsedTime(String time) {
    if (time.length <= 1) return "0$time";
    return time;
  }

  @override
  Widget build(BuildContext context) {
    int min = time ~/ 60;
    int sec = time % 60;

    String parsedTime =
        getParsedTime(min.toString()) + " : " + getParsedTime(sec.toString());

    return (Text(
      parsedTime,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    ));
  }
}
