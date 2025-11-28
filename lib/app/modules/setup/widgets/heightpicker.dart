
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kenzeno/app/res/colors/colors.dart';
class VerticalScrollController extends ChangeNotifier {
  final double topValue;
  final double bottomValue;
  final double? _itemGap;
  final double height;
  double scrollOffset = 0;
  AxisDirection dragDirection = AxisDirection.up;
  static VerticalScrollController? _instance;
// Factory constructor to return the same instance
  factory VerticalScrollController({
    double? itemGap,
    required double maxValue,
    required double minValue,
    required double height,
  }) {
    return _instance ??= VerticalScrollController._internal(
      itemGap: itemGap,
      topValue: maxValue,
      bottomValue: minValue,
      height: height,
    );
  }
// Private named constructor for initialization
  VerticalScrollController._internal({
    double? itemGap, // Default values can be provided
    required this.topValue,
    required this.bottomValue,
    required this.height,
  }) : _itemGap = itemGap;
  int get itemHeight => max(_itemGap ?? 16, 16).round();
  int get totalLineCount => (bottomValue.floor() - topValue.ceil()).abs();
  double get onScreenTop => totalLineCount + scrollOffset / itemHeight;
  double get onScreenBottom => onScreenTop - height / itemHeight;
  double get pickValuePrecise => (onScreenTop + onScreenBottom) / 2;
  int get pickedValue => dragDirection == AxisDirection.up
      ? ((onScreenTop + onScreenBottom) / 2).floor()
      : ((onScreenTop + onScreenBottom) / 2).ceil();
  @protected
  void scroll(double value) {
    double previousScrollOffset = scrollOffset;
    scrollOffset = value;
    if (value != previousScrollOffset) {
      notifyListeners();
    }
    if (pickValuePrecise > topValue) {
      double minusValue = pickValuePrecise - topValue;
      scrollOffset -= minusValue * itemHeight;
      notifyListeners();
    }
    if (pickValuePrecise < bottomValue) {
      double minusValue = bottomValue - pickValuePrecise;
      scrollOffset += minusValue * itemHeight;
      notifyListeners();
    }
  }
  void updateDirection(AxisDirection direction) {
    dragDirection = direction;
  }
}
class VerticalScrollPickerStyle {
  final Color? backgroundItemColor;
  final Color? foregroundItemColor;
  const VerticalScrollPickerStyle(
      {this.backgroundItemColor, this.foregroundItemColor});
  static const VerticalScrollPickerStyle defaultStyle =
  VerticalScrollPickerStyle(
    backgroundItemColor: Color(0xFF9A9A9A),
    foregroundItemColor: Color(0xFF444444),
  );
}
class VerticalScrollPicker extends StatefulWidget {
  final double? height;
  final double? width;
  final double bottomValue;
  final double topValue;
  final double interval;
  final double lineGap;
  final ValueChanged<double>? onChanged;
  final VerticalScrollPickerStyle style;
  final String Function(double value)? onPickedValueFormat;
  final String Function(double value)? onScaleValueFormat;
  const VerticalScrollPicker({
    super.key,
    this.height,
    this.width,
    required this.bottomValue,
    required this.topValue,
    required this.interval,
    this.onPickedValueFormat,
    this.onScaleValueFormat,
    this.onChanged,
    this.style = VerticalScrollPickerStyle.defaultStyle,
    this.lineGap = 20,
  });
  @override
  State<VerticalScrollPicker> createState() => _VerticalScrollPickerState();
}
class _VerticalScrollPickerState extends State<VerticalScrollPicker> {
  VerticalScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: GestureDetector(
        onVerticalDragEnd: (_){
          if(controller != null){
            widget.onChanged?.call(controller!.pickedValue.toDouble());
          }
        },
        onVerticalDragUpdate: _onDragVertically,
        child: LayoutBuilder(
          builder: (context, constraint) {
            controller = VerticalScrollController(
              itemGap: max(widget.lineGap, 10),
              maxValue: widget.topValue,
              minValue: widget.bottomValue,
              height: constraint.maxHeight,
            );
            return _RangeSlide(
              controller!,
              interval: widget.interval,
              style: widget.style,
              onPickedValueFormat: widget.onPickedValueFormat,
              onScaleValueFormat: widget.onScaleValueFormat,
            );
          },
        ),
      ),
    );
  }
  void _onDragVertically(DragUpdateDetails details) {
    if (controller != null) {
      bool isUp = details.delta.dy < 0;
      controller!.updateDirection(isUp ? AxisDirection.up : AxisDirection.down);
      if (!isUp && controller!.pickValuePrecise > controller!.topValue) {
        return;
      }
      if (isUp && controller!.pickValuePrecise <= controller!.bottomValue) {
        return;
      }
      double tempScrollOffset =
          controller!.scrollOffset + details.primaryDelta!;
      controller!.scroll(tempScrollOffset);
    }
  }
}
class _RangeSlide extends StatefulWidget {
  final String Function(double value)? onPickedValueFormat;
  final String Function(double value)? onScaleValueFormat;
  final double interval;
  final VerticalScrollPickerStyle style;
  final VerticalScrollController controller;
  const _RangeSlide(
      this.controller, {
        this.interval = 10,
        this.onPickedValueFormat,
        this.onScaleValueFormat,
        this.style = VerticalScrollPickerStyle.defaultStyle,
      });
  @override
  State<_RangeSlide> createState() => _RangeSlideState();
}
class _RangeSlideState extends State<_RangeSlide> {
  VerticalScrollController get controller => widget.controller;
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: ListenableBuilder(
        listenable: widget.controller,
        builder: (context,constant) => CustomPaint(
          painter: ScalePainter(
            topValue: controller.topValue,
            totalLineCount: controller.totalLineCount,
            pickedValue: controller.pickedValue,
            color: widget.style.backgroundItemColor,
            itemHeight: controller.itemHeight,
            interval: widget.interval,
            scrollOffset: controller.scrollOffset,
            offsetLeft: 18,
            valueFormatter:
            widget.onScaleValueFormat ?? (value) => value.toString(),
          ),
          foregroundPainter: MarkPainter(
            interval: widget.interval,
            color: widget.style.foregroundItemColor,
            pickedValue: widget.controller.pickedValue,
            offsetLeft: 18,
            valueFormatter:
            widget.onPickedValueFormat ?? (value) => value.toString(),
          ),
        ),
      ),
    );
  }
}
//=========================================================
// Scrollable Scale in Background Section
//=========================================================
class ScalePainter extends CustomPainter {
  final Color? color;
  final int totalLineCount;
  final double interval;
  final double topValue;
  final int pickedValue;
  final double scrollOffset;
  final double offsetLeft;
  final String Function(double value) valueFormatter;
  final int itemHeight;
  ScalePainter({
    required this.totalLineCount,
    required this.pickedValue,
    required this.topValue,
    required this.interval,
    required this.scrollOffset,
    required this.valueFormatter, // Pass callback
    this.color,
    this.offsetLeft = 12,
    required this.itemHeight,
  });
  final int extraLines = 40;
  @override
  void paint(Canvas canvas, Size size) {
    var offsetLeftFinal = offsetLeft + 6;
    final finalColor = color ?? Color(0xFF717171);
    final Paint minorScalePaint = Paint()
      ..color = finalColor
      ..strokeWidth = 2;
// -------------------- Lower lines from middle
    for (int c = -extraLines; c <= totalLineCount + extraLines; c++) {
      int rightLinePointFactor = 2;
      if (c % interval == 0) {
        rightLinePointFactor = 3;
        if (topValue - c.toDouble() != pickedValue) {
          _drawText(
            canvas,
            valueFormatter(topValue - c.toDouble()),
            Offset(
              offsetLeftFinal * rightLinePointFactor + 10,
              c * itemHeight + scrollOffset - 7,
            ),
            finalColor,
          );
        }
      }
      canvas.drawLine(
        Offset(
          offsetLeftFinal,
          c * itemHeight + scrollOffset,
        ),
        Offset(
          offsetLeftFinal * rightLinePointFactor,
          c * itemHeight + scrollOffset,
        ),
        minorScalePaint,
      );
    }
    canvas.drawLine(
      Offset(
        offsetLeftFinal,
        0,
      ),
      Offset(
        offsetLeftFinal,
        size.height,
      ),
      minorScalePaint,
    );
  }
  /// Draws a value label at the given position
  void _drawText(Canvas canvas, String text, Offset position, Color textColor) {
    final TextSpan textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: textColor,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, position);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
//=========================================================
// Marking Section - Arrow Up, Down and Right
//=========================================================
class MarkPainter extends CustomPainter {
  final double interval;
  final int pickedValue;
  final double offsetLeft;
  final Color? color;
  final String Function(double) valueFormatter;
  MarkPainter({
    required this.interval,
    required this.pickedValue,
    required this.valueFormatter,
    this.offsetLeft = 12,
    this.color,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final Paint arrowPaint = Paint()
      ..color = color ?? AppColor.white
      ..strokeWidth = 3
      ..style = PaintingStyle.fill;
    double arrowHandle = 80;
    double arrowHeadSize = 6;
    double gap = 50;
    Offset center = Offset(size.width / 2, size.height / 2);
// UP Arrow (↑)
    Offset upStart = Offset(6, center.dy - gap / 2);
    Offset upEnd = Offset(6, upStart.dy - arrowHandle);
    canvas.drawLine(upStart, upEnd, arrowPaint);
    Path upArrowHead = Path();
    upArrowHead.moveTo(upEnd.dx, upEnd.dy - 2);
    upArrowHead.lineTo(upEnd.dx - arrowHeadSize, upEnd.dy + arrowHeadSize);
    upArrowHead.lineTo(upEnd.dx + arrowHeadSize, upEnd.dy + arrowHeadSize);
    upArrowHead.close();
    canvas.drawPath(upArrowHead, arrowPaint);
// DOWN Arrow (↓)
    Offset downStart = Offset(6, center.dy + gap / 2);
    Offset downEnd = Offset(6, downStart.dy + arrowHandle);
    canvas.drawLine(downStart, downEnd, arrowPaint);
    Path downArrowHead = Path();
    downArrowHead.moveTo(downEnd.dx, downEnd.dy + 2);
    downArrowHead.lineTo(
        downEnd.dx - arrowHeadSize, downEnd.dy - arrowHeadSize);
    downArrowHead.lineTo(
        downEnd.dx + arrowHeadSize, downEnd.dy - arrowHeadSize);
    downArrowHead.close();
    canvas.drawPath(downArrowHead, arrowPaint);
    drawStaticMid(canvas, arrowPaint, center, arrowHeadSize);
  }
  void drawStaticMid(
      Canvas canvas, Paint arrowPaint, Offset center, double arrowHeadSize) {
// HORIZONTAL Arrow (>-)
    Offset horStart = Offset(6 + offsetLeft, center.dy);
    Offset horEnd = Offset(6 + offsetLeft * 4, horStart.dy);
    canvas.drawLine(horStart, horEnd, arrowPaint);
    Path horizontalArrowHead = Path();
    horizontalArrowHead.moveTo(horStart.dx, horStart.dy - arrowHeadSize);
    horizontalArrowHead.lineTo(horStart.dx, horStart.dy + arrowHeadSize);
    horizontalArrowHead.lineTo(horStart.dx + arrowHeadSize, horStart.dy);
    horizontalArrowHead.close();
    canvas.drawPath(horizontalArrowHead, arrowPaint);
// Text next to Horizontal Arrow
    double finalValue = double.parse(pickedValue.toStringAsFixed(1));
    final TextSpan textSpan = TextSpan(
      text: valueFormatter(max(finalValue, 0)),
      style: TextStyle(
        color: color ?? AppColor.customPurple,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
// Draw the text next to the horizontal arrow
    Offset textOffset =
    Offset(horEnd.dx + 10, horEnd.dy - textPainter.height / 2);
    textPainter.paint(canvas, textOffset);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}