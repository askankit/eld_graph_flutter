import 'package:eld_graph_flutter/src/eld_utils.dart';
import 'package:flutter/material.dart';
import 'eld_model.dart';

class ELdGraph extends StatefulWidget {
  final List<EldModel> dataPoints;
  final DateTime logsDate;
  final Color? axisColor;
  final Color? graphLineColor;
  final TextStyle? labelTextStyle;

  ELdGraph({
    super.key,
    required this.dataPoints,
    required this.logsDate,
    this.axisColor,
    this.graphLineColor,
    this.labelTextStyle,
  }) : assert(dataPoints.isNotEmpty, "Data points cannot be empty");

  @override
  State<ELdGraph> createState() => _ELdGraphState();
}

class _ELdGraphState extends State<ELdGraph> {
  DateTime get _timeNow => DateTime.now();
  String offTime = "00:00";
  String onDutyTime = "00:00";
  String driveTime = "00:00";
  String sleepTime = "00:00";

  Future<Map<int, String>> calculateDutyDurations() async {
    Map<int, Duration> dutyDurations = {
      1: Duration.zero, // Off Duty
      2: Duration.zero, // Sleeper Berth
      3: Duration.zero, //Driving
      4: Duration.zero, // On Duty
    };

    for (final log in widget.dataPoints) {
      DateTime start = log.startTime ?? _timeNow;
      DateTime end = log.endTime ?? _timeNow;
      dutyDurations[log.eventType!] = dutyDurations[log.eventType]! + end.difference(start);
    }

    return dutyDurations.map(
      (status, duration) => MapEntry(status, _formatDuration(duration)),
    );
  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      width: MediaQuery.sizeOf(context).width,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: StepLineGraphPainter(
            dataPoints: widget.dataPoints,
            rightSideLabels: [(offTime), (sleepTime), (driveTime), (onDutyTime)],
            axisColor: widget.axisColor ?? Colors.grey,
            tickColor: widget.axisColor ?? Colors.grey,
            graphLineColor: widget.graphLineColor ?? Colors.black,
            labelTextStyle:
                widget.labelTextStyle ??
                 TextStyle(
                  fontSize: 14,
                  color: widget.axisColor ?? Colors.grey,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ),
    );
  }
}

class StepLineGraphPainter extends CustomPainter {
  final List<EldModel> dataPoints;
  final List<String> rightSideLabels;
  final Color axisColor;
  final Color tickColor;
  final Color graphLineColor;
  final TextStyle labelTextStyle;

  StepLineGraphPainter({
    required this.dataPoints,
    required this.rightSideLabels,
    required this.axisColor,
    required this.tickColor,
    required this.graphLineColor,
    required this.labelTextStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {

    final Paint axisPaint = Paint()
      ..color = axisColor
      ..strokeWidth = 0.5;

    final Paint tickPaint = Paint()
      ..color = tickColor
      ..strokeWidth = 0.5;

    final Paint linePaint = Paint()
      ..color = graphLineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double xStep = size.width / 24;
    final double yStep = size.height / 4;

    // Draw grid, ticks, step graph, and labels
    _drawGridLines(canvas, size, xStep, yStep, axisPaint);
    _drawTicks(canvas, size, xStep, yStep, tickPaint);
    _drawStepGraph(canvas, size, xStep, yStep, linePaint);
    _drawAxisLabels(canvas, size, xStep, yStep);
  }
  // Draw grid lines
  void _drawGridLines(Canvas canvas, Size size, double xStep, double yStep, Paint axisPaint) {
    for (int i = 0; i <= 24; i++) {
      canvas.drawLine(Offset(xStep * i, 0), Offset(xStep * i, size.height), axisPaint);
    }
    for (int i = 0; i <= 4; i++) {
      canvas.drawLine(Offset(0, yStep * i), Offset(size.width, yStep * i), axisPaint);
    }
  }

  // Draw ticks
  void _drawTicks(Canvas canvas, Size size, double xStep, double yStep, Paint tickPaint) {
    // Draw small ruler ticks on the X-axis
    for (int i = 0; i < 24; i++) {
      double x = xStep * i;
      for (int j = 1; j <= 3; j++) {
        double tickX = x + (xStep / 4) * j;
        double tickHeight = (j == 2) ? 20 : 10;  // Bigger size for the 2nd tick

        // Draw ticks at multiple Y-levels
        for (int k = 0; k < 4; k++) {
          double yPos = size.height - (yStep * k);
          canvas.drawLine(
            Offset(tickX, yPos - tickHeight),
            Offset(tickX, yPos),
            tickPaint,
          );
        }
      }
    }

    // Draw small ruler ticks on the Y-axis
    for (int i = 0; i < 4; i++) {
      double y = yStep * i;
      for (int j = 1; j < 3; j++) {
        double tickY = y + (yStep / 2) * j;
        canvas.drawLine(Offset(size.width - 10, tickY), Offset(size.width, tickY), tickPaint);
      }
    }
  }

  void _drawStepGraph(Canvas canvas, Size size, double xStep, double yStep, Paint linePaint) {
    final path = Path();

    // Define Y positions for step alignment
    final Map<int, double> yPositions = {
      1: size.height - (yStep * 3.5), // Off Duty
      2: size.height - (yStep * 2.5), //  Sleeper Berth (SB)
      3: size.height - (yStep * 1.5), // Drive
      4: size.height - (yStep * 0.5), //On Duty
    };
    for (int i = 0; i < dataPoints.length; i++) {
      final log = dataPoints[i];
      // Convert times to X-axis positions
      double startX = (timeToX(EldUtils.extractTime(log.startTime), size.width));
      double endX = (timeToX(EldUtils.extractTime(log.endTime),  size.width));
      double y = yPositions[log.eventType??1]!;
      path.moveTo(startX, y);
      path.lineTo(endX, y);
      if (i < dataPoints.length - 1) {
        double nextY = yPositions[dataPoints[i + 1].eventType??1]!;
        path.lineTo(endX, nextY);
      }
    }
    canvas.drawPath(path, linePaint);
  }

  double timeToX(String time, double width) {
    List<String> parts = time.split(':');
    double hours = double.parse(parts[0]) + (double.parse(parts[1]) / 60);
    return (hours / 24) * width;  // Normalize to 24-hour scale
  }

  // Draw axis labels
  void _drawAxisLabels(Canvas canvas, Size size, double xStep, double yStep) {
    final textStyle =labelTextStyle;
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    _drawXAxisLabels(canvas, xStep, textPainter, textStyle);
    _drawYAxisLabels(canvas, yStep, textPainter, textStyle);
    _drawRightSideLabels(canvas, yStep, textPainter, textStyle, size);
  }

  // Draw X-axis labels
  void _drawXAxisLabels(Canvas canvas, double xStep, TextPainter textPainter, TextStyle textStyle) {
    for (int i = 0; i <= 24; i++) {
      String text = i == 0 ? 'M' : '$i'; // Replace 0 with 'M'
      textPainter.text = TextSpan(text: text, style: textStyle);
      textPainter.layout();
      textPainter.paint(canvas, Offset(xStep * i - 10, -30)); // Position at the top
    }
  }

  // Draw Y-axis labels
  void _drawYAxisLabels(Canvas canvas, double yStep, TextPainter textPainter, TextStyle textStyle) {
    List<String> yLabels = ["OFF", "SB", "D", "ON"];
    for (int i = 0; i < yLabels.length; i++) {
      final String label = yLabels[i];
      textPainter.text = TextSpan(text: label, style: textStyle);
      textPainter.layout();
      double yPosition = yStep * i + (yStep - textPainter.height) / 2;
      textPainter.paint(canvas, Offset(-34, yPosition));
    }
  }

  // Draw right side labels
  void _drawRightSideLabels(Canvas canvas, double yStep, TextPainter textPainter, TextStyle textStyle, Size size) {
    List<String> rightSideLabels = this.rightSideLabels;
    for (int i = 0; i < rightSideLabels.length; i++) {
      final String label = rightSideLabels[i];
      textPainter.text = TextSpan(text: label, style: textStyle);
      textPainter.layout();
      double yPosition = yStep * i + (yStep - textPainter.height) / 2;
      textPainter.paint(canvas, Offset(size.width + 10, yPosition)); // Add 10px padding on the right
    }
  }

  @override
  bool shouldRepaint(covariant StepLineGraphPainter oldDelegate) {
    bool repaint = oldDelegate.dataPoints != dataPoints;
    return repaint;
  }
}
