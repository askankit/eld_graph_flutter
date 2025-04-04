import 'package:eld_graph_flutter/eld_graph_flutter.dart';
import 'package:flutter/material.dart';
import 'views/eld_graph_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ELD Graph Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const EldGraphView(),
    );
  }
}

class EldGraphView extends StatefulWidget {
  const EldGraphView({super.key});

  @override
  State<EldGraphView> createState() => _EldGraphViewState();
}

class _EldGraphViewState extends State<EldGraphView> {
  final dummyLogs = [
    {
      "dutyType": 1,
      "startTime": "2025-03-31 18:30:00.000Z",
      "endTime": "2025-04-01 05:06:58",
    },
    {
      "dutyType": 1,
      "startTime": "2025-04-01 05:06:58",
      "endTime": "2025-04-01 05:58:34",
    },
    {
      "dutyType": 4,
      "startTime": "2025-04-01 05:58:34",
      "endTime": "2025-04-01 07:05:58",
    },
    {
      "dutyType": 3,
      "startTime": "2025-04-01 07:05:58",
      "endTime": "2025-04-01 09:18:59",
    },
    {
      "dutyType": 1,
      "startTime": "2025-04-01 09:18:59",
      "endTime": "2025-04-01 17:30:00.000Z",
    },
  ];

  List<EldModel> eldLogList = [];
  @override
  void initState() {
    eldLogList = dummyLogs.map((log) => EldModel.fromJson(log)).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter ELD Graph Demo")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60.0),
          child: ELdGraph(dataPoints: eldLogList, logsDate: DateTime.now()),
        ),
      ),
    );
  }
}
