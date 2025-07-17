import 'package:clean_calendar/src/models/calendar_properties.dart';
import 'package:clean_calendar/src/models/dates_properties.dart';
import 'package:clean_calendar/src/utils/get_suitable_calendar_general_date_widget.dart';
import 'package:clean_calendar/src/utils/get_suitable_calendar_streak_date_widget.dart';
import 'package:clean_calendar/src/utils/get_suitable_dates_properties.dart';
import 'package:flutter/material.dart';

class CalendarDateWidget extends StatefulWidget {
  const CalendarDateWidget(
      {super.key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate});

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  State<CalendarDateWidget> createState() => _CalendarDateWidgetState();
}

class _CalendarDateWidgetState extends State<CalendarDateWidget> {
  final LayerLink _layerLink = LayerLink();
  late final OverlayPortalController _overlayController;
  late final DatesProperties datesProperties;

  @override
  void initState() {
    super.initState();
    _overlayController = OverlayPortalController();

    datesProperties = getSuitableDatesProperties(
      calendarProperties: widget.calendarProperties,
      pageViewElementDate: widget.pageViewElementDate,
      pageViewDate: widget.pageViewDate,
    );

    // Show overlay when widget is built and overlayWidget is provided
    if (datesProperties.datesDecoration?.overlayWidget != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayController.show();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isStreakDate = widget.calendarProperties.datesForStreaks
        .contains(widget.pageViewElementDate);
    Widget mainWidget;

    if (widget.calendarProperties.datesForStreaks
        .contains(widget.pageViewElementDate)) {
      mainWidget = GetSuitableCalendarStreakDateWidget(
          calendarProperties: widget.calendarProperties,
          pageViewElementDate: widget.pageViewElementDate,
          pageViewDate: widget.pageViewDate);
    } else if (!widget.calendarProperties.datesForStreaks
        .contains(widget.pageViewElementDate)) {
      mainWidget = GetSuitableCalendarGeneralDateWidget(
        calendarProperties: widget.calendarProperties,
        pageViewElementDate: widget.pageViewElementDate,
        pageViewDate: widget.pageViewDate,
      );
    } else {
      mainWidget = const SizedBox();
    }

    // If no overlay widget is provided, return the main widget directly
    if (datesProperties.datesDecoration?.overlayWidget == null) {
      return mainWidget;
    }

    // Use OverlayPortal with CompositedTransformTarget for proper positioning
    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: (context) {
        return CompositedTransformFollower(
          link: _layerLink,
          targetAnchor: Alignment.center,
          followerAnchor: Alignment.center,
          offset: isStreakDate ? const Offset(0, 22) : const Offset(0, 16),
          child: IgnorePointer(
            child: Center(
              child: datesProperties.datesDecoration?.overlayWidget!,
            ),
          ),
        );
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: mainWidget,
      ),
    );
  }
}
