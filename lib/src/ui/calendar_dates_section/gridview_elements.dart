import 'package:clean_calendar/src/models/calendar_properties.dart';
import 'package:clean_calendar/src/models/dates_properties.dart';
import 'package:clean_calendar/src/state/page_controller.dart';
import 'package:clean_calendar/src/utils/get_suitable_calendar_general_date_widget.dart';
import 'package:clean_calendar/src/utils/get_suitable_calendar_streak_date_widget.dart';
import 'package:clean_calendar/src/utils/get_suitable_dates_properties.dart';
import 'package:flutter/material.dart';

class CalendarDateWidget extends StatefulWidget {
  const CalendarDateWidget(
      {super.key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate,
      this.pageControllerState});

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;
  final PageControllerState? pageControllerState;

  @override
  State<CalendarDateWidget> createState() => _CalendarDateWidgetState();
}

class _CalendarDateWidgetState extends State<CalendarDateWidget> {
  final LayerLink _layerLink = LayerLink();
  late final OverlayPortalController _overlayController;
  late final DatesProperties datesProperties;
  bool _isTargetVisible = false;

  @override
  void initState() {
    super.initState();
    _overlayController = OverlayPortalController();

    datesProperties = getSuitableDatesProperties(
      calendarProperties: widget.calendarProperties,
      pageViewElementDate: widget.pageViewElementDate,
      pageViewDate: widget.pageViewDate,
    );

    // Check visibility and show overlay when widget is built and overlayWidget is provided
    if (datesProperties.datesDecoration?.overlayWidget != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkVisibilityAndShowOverlay();
      });
    }

    // Add listener to page controller to check visibility on scroll
    if (widget.pageControllerState != null) {
      widget.pageControllerState!.pageController.addListener(_onPageChanged);
    }
  }

  @override
  void dispose() {
    // Remove page controller listener
    if (widget.pageControllerState != null) {
      widget.pageControllerState!.pageController.removeListener(_onPageChanged);
    }
    if (_overlayController.isShowing) {
      _overlayController.hide();
    }
    super.dispose();
  }

  void _onPageChanged() {
    // Check visibility when page changes
    if (datesProperties.datesDecoration?.overlayWidget != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkVisibilityAndShowOverlay();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-check visibility when dependencies change (e.g., screen size changes)
    if (datesProperties.datesDecoration?.overlayWidget != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkVisibilityAndShowOverlay();
      });
    }
  }

  void _checkVisibilityAndShowOverlay() {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;

      // Check if the widget is visible on screen
      final screenSize = MediaQuery.of(context).size;
      _isTargetVisible = position.dx < screenSize.width &&
          position.dx + size.width > 0 &&
          position.dy < screenSize.height &&
          position.dy + size.height > 0;

      if (_isTargetVisible) {
        _overlayController.show();
      } else {
        _overlayController.hide();
      }
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
