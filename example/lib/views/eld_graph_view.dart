import 'package:eld_graph_flutter/eld_graph_flutter.dart';
import 'package:flutter/material.dart';

class EldGraphView extends StatefulWidget {
  const EldGraphView({super.key});

  @override
  State<EldGraphView> createState() => _EldGraphViewState();
}

class _EldGraphViewState extends State<EldGraphView> {
  final dummyLogs = [
    {
      "startTime": "2025-03-17T06:38:05.000Z",
      "endTime": "2025-03-17T09:32:45.000Z",
      "eventType": 1
    },
    {
      "startTime": "2025-03-17T09:32:45.000Z",
      "endTime": "2025-03-17T12:48:21.000Z",
      "eventType": 4
    },
    {
      "startTime": "2025-03-17T12:48:21.000Z",
      "endTime": "2025-03-18T06:37:02.000Z",
      "eventType": 1
    },
    {
      "startTime": "2025-03-18T06:37:02.000Z",
      "endTime": "2025-03-18T09:39:58.000Z",
      "eventType": 4
    },
    {
      "startTime": "2025-03-18T09:39:58.000Z",
      "endTime": "2025-03-18T13:08:12.000Z",
      "eventType": 1
    },
    {
      "startTime": "2025-03-18T13:08:12.000Z",
      "endTime": "2025-03-18T13:10:20.000Z",
      "eventType": 4
    },
    {
      "startTime": "2025-03-18T13:10:20.000Z",
      "endTime": null,
      "eventType": 1
    }
  ];
  List<EldModel> eldLogList =[];
   @override
  void initState() {eldLogList = dummyLogs.map((log) => EldModel.fromJson(log)).toList();
     super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Center(child: Padding(
       padding: const EdgeInsets.symmetric(horizontal: 60.0),
       child: ELdGraph(dataPoints: eldLogList, logsDate: DateTime.now()),
     )),

    );
  }
}
