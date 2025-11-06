library clean_calendar;

import 'package:clean_calendar/clean_calendar.dart';
import 'package:clean_calendar/src/ui/calendar_view.dart';
import 'package:flutter/material.dart';

class CleanCalendar extends StatelessWidget {
  /// - CleanCalendar, Shows a simple Calendar.
  const CleanCalendar({
    super.key,
    this.datePickerCalendarView,
    this.headerProperties,
    this.weekdaysProperties,
    this.streakDatesProperties,
    this.currentDateProperties,
    this.generalDatesProperties,
    this.leadingTrailingDatesProperties,
    this.selectedDatesProperties,
    this.enableDenseViewForDates,
    this.enableDenseSplashForDates,
    this.startDateOfCalendar,
    this.endDateOfCalendar,
    this.dateSelectionMode,
    this.initialViewMonthDateTime,
    this.currentDateOfCalendar,
    this.datesForStreaks,
    this.shieldDates,
    this.selectedDates,
    this.onSelectedDates,
    this.onCalendarViewDate,
    this.startWeekday,
    this.weekdaysSymbol,
    this.monthsSymbol,
    this.calendarDatesSectionMaxHeight,
  });

  /// - datePickerCalendarView, It takes calendar view type.
  final DatePickerCalendarView? datePickerCalendarView;

  /// - headerProperties, It takes customisation properties for calendar header.
  final HeaderProperties? headerProperties;

  /// - weekdaysProperties, It takes customisation properties for weekdays.
  final WeekdaysProperties? weekdaysProperties;

  /// - streakDatesProperties, It takes customisation properties for streak dates.
  final DatesProperties? streakDatesProperties;

  /// - currentDateProperties, It takes customisation properties for current dates.
  final DatesProperties? currentDateProperties;

  /// - generalDatesProperties, It takes customisation properties for general dates.
  final DatesProperties? generalDatesProperties;

  /// - leadingTrailingDatesProperties, It takes customisation properties for leading dates.
  final DatesProperties? leadingTrailingDatesProperties;

  /// - selectedDatesProperties, It takes customisation properties for selected dates.
  final DatesProperties? selectedDatesProperties;

  /// - enableDenseViewForDates, Set true to allow date boundary to shrink.
  final bool? enableDenseViewForDates;

  /// - enableDenseSplashForDates, Set true to allow date tap splash to shrink.
  final bool? enableDenseSplashForDates;

  /// - endDateOfCalendar, It takes start date for calendar view.
  final DateTime? startDateOfCalendar;

  /// - endDateOfCalendar, It takes end date for calendar view.
  final DateTime? endDateOfCalendar;

  /// - dateSelectionMode, It takes DatePickerSelectionMode which Provides different modes for date selection.
  final DatePickerSelectionMode? dateSelectionMode;

  /// - initialViewMonthDateTime, It takes initial month date for calendar view.
  /// Defaults to current date and if current is not between startDateOfCalendar and endDateOfCalendar then defaults to start date.
  final DateTime? initialViewMonthDateTime;

  /// - currentDateOfCalendar, It takes current or today date for calendar view.
  /// Defaults to DateTime.now().
  final DateTime? currentDateOfCalendar;

  /// - datesForStreaks, It takes the list of dates to be shown as streaks.
  final List<DateTime>? datesForStreaks;

  /// - shieldDates, It takes the list of dates to be shown with a shield icon (UI only, does not affect streak calculation).
  final List<DateTime>? shieldDates;

  /// - selectedDates, It takes the list of pre-selected dates to be shown as selected.
  final List<DateTime>? selectedDates;

  /// - onSelectedDates, A callback to get the current selected dates.
  final ValueChanged<List<DateTime>>? onSelectedDates;

  /// - onCalendarViewDate, A callback to get the current calendar view date.
  final ValueChanged<DateTime>? onCalendarViewDate;

  /// - startWeekday, It takes the weekday from which the calendar view should start.
  ///
  /// Defaults to sunday.
  final WeekDay? startWeekday;

  /// - weekdaysSymbol, It takes the weekdays symbols.
  ///
  /// Defaults symbols are Mo, Tu, We, Th, Fr, Sa, Su from monday to sunday.
  final Weekdays? weekdaysSymbol;

  /// - monthsSymbol, It takes the months symbols.
  ///
  /// Defaults symbols are January, February, March, April, May, June, July, August, September, October, November, December.
  final Months? monthsSymbol;

  /// - calendarDatesSectionMaxHeight, It takes the maximum height for the calendar dates section.
  ///
  /// If double.infinity, it will take the 240px height.
  /// If null, it will take the available height.
  final double? calendarDatesSectionMaxHeight;

  @override
  Widget build(BuildContext context) {
    return Calendar(
      calendarProperties: CalendarProperties(
          datePickerCalendarView: datePickerCalendarView,
          weekdaysProperties: weekdaysProperties,
          headerProperties: headerProperties,
          streakDatesProperties: streakDatesProperties,
          currentDateProperties: currentDateProperties,
          generalDatesProperties: generalDatesProperties,
          leadingTrailingDatesProperties: leadingTrailingDatesProperties,
          selectedDatesProperties: selectedDatesProperties,
          enableDenseViewForDates: enableDenseViewForDates,
          enableDenseSplashForDates: enableDenseSplashForDates,
          startDateOfCalendar: startDateOfCalendar,
          endDateOfCalendar: endDateOfCalendar,
          dateSelectionMode: dateSelectionMode,
          initialViewMonthDateTime: initialViewMonthDateTime,
          currentDateOfCalendar: currentDateOfCalendar,
          datesForStreaks: datesForStreaks,
          shieldDates: shieldDates,
          selectedDates: selectedDates,
          onSelectedDates: onSelectedDates,
          onCalendarViewDate: onCalendarViewDate,
          startWeekday: startWeekday,
          weekdaysSymbol: weekdaysSymbol,
          monthsSymbol: monthsSymbol,
          calendarDatesSectionMaxHeight: calendarDatesSectionMaxHeight,
          context: context),
    );
  }
}
