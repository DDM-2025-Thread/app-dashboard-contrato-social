import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final List<double> data;
  final List<String> labels;
  final Color color;

  const LineChartWidget({
    Key? key,
    required this.data,
    required this.labels,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);

    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: _LineChartPainter(
        data: data,
        labels: labels,
        color: color,
        maxValue: maxValue,
        minValue: minValue,
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final Color color;
  final double maxValue;
  final double minValue;

  _LineChartPainter({
    required this.data,
    required this.labels,
    required this.color,
    required this.maxValue,
    required this.minValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;

    final textStyle = TextStyle(
      color: Colors.grey[600],
      fontSize: 10,
    );

    // Calculate points
    final points = <Offset>[];
    final xStep = size.width / (data.length - 1);
    final yRange = maxValue - minValue;
    
    for (int i = 0; i < data.length; i++) {
      final x = i * xStep;
      final y = size.height - ((data[i] - minValue) / yRange * size.height);
      points.add(Offset(x, y));
    }

    // Draw grid lines
    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Draw line
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    // Draw points
    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);
      canvas.drawCircle(point, 2, Paint()..color = Colors.white);
    }

    // Draw labels
    for (int i = 0; i < labels.length; i++) {
      final textSpan = TextSpan(
        text: labels[i],
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(i * xStep - textPainter.width / 2, size.height + 5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}