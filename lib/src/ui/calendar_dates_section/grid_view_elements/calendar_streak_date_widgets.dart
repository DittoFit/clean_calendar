import 'package:clean_calendar/src/models/calendar_properties.dart';
import 'package:clean_calendar/src/models/dates_properties.dart';
import 'package:clean_calendar/src/size_provider.dart';
import 'package:clean_calendar/src/ui/shield_date_wrapper.dart';
import 'package:clean_calendar/src/utils/get_end_weekday_from_start_weekday.dat.dart';
import 'package:clean_calendar/src/utils/get_suitable_dates_on_tap.dart';
import 'package:clean_calendar/src/utils/get_suitable_dates_properties.dart';
import 'package:clean_calendar/src/utils/get_widget_center_offset_info.dart';
import 'package:clean_calendar/src/utils/simulate_tap_on_an_offset.dart';
import 'package:clean_calendar/src/utils/space_fixer.dart';
import 'package:flutter/material.dart';

/// Only use Ink if its parent is a button otherwise it will act weird such as this https://github.com/flutter/flutter/issues/73315
/// Use space fixer between containers of same color to fix lines due to antialiasing will be fixed with impeller in future.

class CalendarStreakStartDenseDate extends StatelessWidget {
  const CalendarStreakStartDenseDate(
      {super.key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate});

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    final int endWeekday = getEndWeekdayFromStartWeekday(
        startWeekday: getIntFromWeekday(calendarProperties.startWeekday));
    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    double? datesBorderRadius =
        datesProperties.datesDecoration?.datesBorderRadius;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;
    final bool isShieldDate =
        calendarProperties.shieldDates.contains(pageViewElementDate);

    return !hide
        ? InkResponse(
            containedInkWell: true,
            highlightShape: BoxShape.rectangle,
            customBorder: datesBorderRadius != null
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(datesBorderRadius),
                      bottomLeft: Radius.circular(datesBorderRadius),
                    ),
                  )
                : null,
            splashFactory: InkRipple.splashFactory,
            onTap: disable ? null : dateSuitableDatesOnTap,
            child: Row(
              children: [
                const Expanded(
                  child: SizedBox(),
                ),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    SizedBox(
                      child: Container(
                        margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                        child: Ink(
                          decoration: BoxDecoration(
                            border: datesBorderColor != null
                                ? Border.symmetric(
                                    horizontal: BorderSide(
                                        color: datesBorderColor, width: 1))
                                : null,
                            color: datesBackgroundColor,
                          ),
                          child: Container(
                            width:
                                DateSectionSizeProvider.instance.widthOfDate /
                                    2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: DateSectionSizeProvider.instance.widthOfDate,
                      child: Container(
                        margin: const EdgeInsets.all(4.0),
                        child: Container(
                          //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                          decoration: BoxDecoration(
                            border: datesBorderColor != null
                                ? Border.all(
                                    color: datesBorderColor, width: 1)
                                : null,
                            borderRadius: datesBorderRadius != null
                                ? BorderRadius.only(
                                    topLeft:
                                        Radius.circular(datesBorderRadius),
                                    bottomLeft:
                                        Radius.circular(datesBorderRadius),
                                  )
                                : null,
                            color: datesBackgroundColor,
                          ),
                          child: Center(
                            child: ShieldDateWrapper(
                              showShield: isShieldDate,
                              child: Text(
                                pageViewElementDate.day.toString(),
                                style: datesTextStyle != null
                                    ? datesTextStyle.copyWith(
                                        color: datesTextColor,
                                      )
                                    : TextStyle(color: datesTextColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                datesBackgroundColor != null
                    ? Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 4),
                        child: SpaceFixerVerticalInkLine(
                          overflowWidth: 1,
                          overflowColor: datesBackgroundColor,
                          border: datesBorderColor != null
                              ? Border.symmetric(
                                  horizontal: BorderSide(
                                      color: datesBorderColor, width: 1))
                              : null,
                        ),
                      )
                    : const SizedBox(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 4.0,
                        bottom: 4.0,
                        right:
                            pageViewElementDate.weekday == endWeekday ? 4 : 0),
                    child: Container(
                      //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                      decoration: BoxDecoration(
                        border: datesBorderColor != null
                            ? Border.symmetric(
                                horizontal: BorderSide(
                                    color: datesBorderColor, width: 1))
                            : null,
                        color: datesBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}

class CalendarStreakStartDenseSplashDate extends StatelessWidget {
  const CalendarStreakStartDenseSplashDate(
      {super.key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate});

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final GlobalKey widgetKey = GlobalKey();

    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    final int endWeekday = getEndWeekdayFromStartWeekday(
        startWeekday: getIntFromWeekday(calendarProperties.startWeekday));
    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    double? datesBorderRadius =
        datesProperties.datesDecoration?.datesBorderRadius;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;
    final bool isShieldDate =
        calendarProperties.shieldDates.contains(pageViewElementDate);

    return !hide
        ? InkResponse(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            enableFeedback: false,
            onTap: disable
                ? null
                : () {
                    Offset widgetCenterOffset =
                        getWidgetCenterOffsetInfo(widgetKey);
                    // print(widgetCenterOffset);
                    simulateTapOnAnOffset(widgetCenterOffset);
                  },
            child: Row(
              children: [
                const Expanded(
                  child: SizedBox(),
                ),
                InkResponse(
                  containedInkWell: true,
                  // highlightColor: Colors.blue,
                  highlightShape: BoxShape.rectangle,
                  customBorder: datesBorderRadius != null
                      ? RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(datesBorderRadius),
                            bottomLeft: Radius.circular(datesBorderRadius),
                          ),
                        )
                      : null,
                  splashFactory: InkRipple.splashFactory,
                  onTap: disable ? null : dateSuitableDatesOnTap,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      SizedBox(
                        child: Container(
                          margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                          child: Container(
                            //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                            decoration: BoxDecoration(
                              border: datesBorderColor != null
                                  ? Border.symmetric(
                                      horizontal: BorderSide(
                                          color: datesBorderColor, width: 1))
                                  : null,
                              color: datesBackgroundColor,
                            ),
                            child: Container(
                              width:
                                  DateSectionSizeProvider.instance.widthOfDate /
                                      2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: DateSectionSizeProvider.instance.widthOfDate,
                        child: Container(
                          margin: const EdgeInsets.all(4.0),
                          child: Container(
                            //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                            decoration: BoxDecoration(
                              border: datesBorderColor != null
                                  ? Border.all(
                                      color: datesBorderColor, width: 1)
                                  : null,
                              borderRadius: datesBorderRadius != null
                                  ? BorderRadius.only(
                                      topLeft:
                                          Radius.circular(datesBorderRadius),
                                      bottomLeft:
                                          Radius.circular(datesBorderRadius),
                                    )
                                  : null,
                              color: datesBackgroundColor,
                            ),
                            child: Center(
                              child: ShieldDateWrapper(
                                showShield: isShieldDate,
                                child: Text(
                                  key: widgetKey,
                                  pageViewElementDate.day.toString(),
                                  style: datesTextStyle != null
                                      ? datesTextStyle.copyWith(
                                          color: datesTextColor,
                                        )
                                      : TextStyle(color: datesTextColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                datesBackgroundColor != null
                    ? Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 4),
                        child: SpaceFixerVerticalLine(
                          overflowWidth: 1,
                          overflowColor: datesBackgroundColor,
                          border: datesBorderColor != null
                              ? Border.symmetric(
                                  horizontal: BorderSide(
                                      color: datesBorderColor, width: 1))
                              : null,
                        ),
                      )
                    : const SizedBox(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 4.0,
                        bottom: 4.0,
                        right:
                            pageViewElementDate.weekday == endWeekday ? 4 : 0),
                    decoration: BoxDecoration(
                      border: datesBorderColor != null
                          ? Border.symmetric(
                              horizontal:
                                  BorderSide(color: datesBorderColor, width: 1))
                          : null,
                      color: datesBackgroundColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}

class CalendarStreakStartExpandedDate extends StatelessWidget {
  const CalendarStreakStartExpandedDate(
      {super.key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate});

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    final int endWeekday = getEndWeekdayFromStartWeekday(
        startWeekday: getIntFromWeekday(calendarProperties.startWeekday));

    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    double? datesBorderRadius =
        datesProperties.datesDecoration?.datesBorderRadius;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;
    final bool isShieldDate =
        calendarProperties.shieldDates.contains(pageViewElementDate);

    return !hide
        ? InkResponse(
            containedInkWell: true,
            highlightShape: BoxShape.rectangle,
            customBorder: datesBorderRadius != null
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(datesBorderRadius),
                        bottomLeft: Radius.circular(datesBorderRadius)),
                  )
                : null,
            splashFactory: InkRipple.splashFactory,
            onTap: disable ? null : dateSuitableDatesOnTap,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                  left: 4,
                  right: pageViewElementDate.weekday == endWeekday ? 4 : 0),
              child: Container(
                //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                decoration: BoxDecoration(
                  border: datesBorderColor != null
                      ? Border(
                          top: BorderSide(color: datesBorderColor, width: 1),
                          bottom:
                              BorderSide(color: datesBorderColor, width: 1),
                          left: BorderSide(color: datesBorderColor, width: 1),
                          right:
                              BorderSide(color: datesBorderColor, width: 1),
                        )
                      : null,
                  borderRadius: datesBorderRadius != null
                      ? BorderRadius.only(
                          topLeft: Radius.circular(datesBorderRadius),
                          bottomLeft: Radius.circular(datesBorderRadius))
                      : null,
                  color: datesBackgroundColor,
                ),
                child: Center(
                  child: ShieldDateWrapper(
                    showShield: isShieldDate,
                    child: Text(
                      pageViewElementDate.day.toString(),
                      style: datesTextStyle != null
                          ? datesTextStyle.copyWith(
                              color: datesTextColor,
                            )
                          : TextStyle(color: datesTextColor),
                    ),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}

class CalendarStreakBetweenDenseSplashDate extends StatelessWidget {
  const CalendarStreakBetweenDenseSplashDate(
      {super.key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate});

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final GlobalKey widgetKey = GlobalKey();

    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    final int startWeekday = getIntFromWeekday(calendarProperties.startWeekday);

    final int endWeekday =
        getEndWeekdayFromStartWeekday(startWeekday: startWeekday);
    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;
    final bool isShieldDate =
        calendarProperties.shieldDates.contains(pageViewElementDate);

    return !hide
        ? InkResponse(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            enableFeedback: false,
            onTap: disable
                ? null
                : () {
                    Offset widgetCenterOffset =
                        getWidgetCenterOffsetInfo(widgetKey);

                    simulateTapOnAnOffset(widgetCenterOffset);
                  },
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 4.0,
                        bottom: 4.0,
                        left: pageViewElementDate.weekday == startWeekday
                            ? 4
                            : 0),
                    decoration: BoxDecoration(
                      border: datesBorderColor != null
                          ? Border.symmetric(
                              horizontal:
                                  BorderSide(color: datesBorderColor, width: 1),
                            )
                          : null,
                      color: datesBackgroundColor,
                    ),
                  ),
                ),
                datesBackgroundColor != null
                    ? Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 4),
                        child: SpaceFixerVerticalLine(
                          overflowWidth: 1,
                          overflowColor: datesBackgroundColor,
                          border: datesBorderColor != null
                              ? Border.symmetric(
                                  horizontal: BorderSide(
                                      color: datesBorderColor, width: 1))
                              : null,
                        ),
                      )
                    : const SizedBox(),
                InkResponse(
                  containedInkWell: true,
                  // highlightColor: Colors.blue,
                  highlightShape: BoxShape.rectangle,
                  customBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  splashFactory: InkRipple.splashFactory,
                  onTap: disable ? null : dateSuitableDatesOnTap,
                  child: Container(
                    margin: const EdgeInsets.only(top: 4, bottom: 4),
                    width: DateSectionSizeProvider.instance.widthOfDate,
                    child: Container(
                      //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                      decoration: BoxDecoration(
                        border: datesBorderColor != null
                            ? Border.symmetric(
                                horizontal: BorderSide(
                                    color: datesBorderColor, width: 1))
                            : null,
                        color: datesBackgroundColor,
                      ),
                      child: Center(
                        child: ShieldDateWrapper(
                          showShield: isShieldDate,
                          child: Text(
                            key: widgetKey,
                            pageViewElementDate.day.toString(),
                            style: datesTextStyle != null
                                ? datesTextStyle.copyWith(
                                    color: datesTextColor,
                                  )
                                : TextStyle(color: datesTextColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                datesBackgroundColor != null
                    ? Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 4),
                        child: SpaceFixerVerticalLine(
                          overflowWidth: 1,
                          overflowColor: datesBackgroundColor,
                          border: datesBorderColor != null
                              ? Border.symmetric(
                                  horizontal: BorderSide(
                                      color: datesBorderColor, width: 1))
                              : null,
                        ),
                      )
                    : const SizedBox(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 4.0,
                        bottom: 4.0,
                        right:
                            pageViewElementDate.weekday == endWeekday ? 4 : 0),
                    decoration: BoxDecoration(
                      border: datesBorderColor != null
                          ? Border.symmetric(
                              horizontal:
                                  BorderSide(color: datesBorderColor, width: 1))
                          : null,
                      color: datesBackgroundColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}

class CalendarStreakBetweenExpandedDate extends StatelessWidget {
  const CalendarStreakBetweenExpandedDate(
      {super.key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate});

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    final int startWeekday = getIntFromWeekday(calendarProperties.startWeekday);

    final int endWeekday =
        getEndWeekdayFromStartWeekday(startWeekday: startWeekday);
    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;
    final bool isShieldDate =
        calendarProperties.shieldDates.contains(pageViewElementDate);

    return !hide
        ? InkResponse(
            containedInkWell: true,
            highlightShape: BoxShape.rectangle,
            customBorder: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            splashFactory: InkRipple.splashFactory,
            onTap: disable ? null : dateSuitableDatesOnTap,
            child: Container(
              margin: EdgeInsets.only(
                top: 4,
                bottom: 4,
                right: pageViewElementDate.weekday == endWeekday ? 4 : 0,
                left: pageViewElementDate.weekday == startWeekday ? 4 : 0,
              ),
              child: Container(
                //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                decoration: BoxDecoration(
                  border: datesBorderColor != null
                      ? Border.symmetric(
                          horizontal:
                              BorderSide(color: datesBorderColor, width: 1))
                      : null,
                  color: datesBackgroundColor,
                ),
                child: Container(
                  margin: EdgeInsets.only(
                    right:
                        pageViewElementDate.weekday == startWeekday ? 4 : 0,
                    left: pageViewElementDate.weekday == endWeekday ? 4 : 0,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: SizedBox(),
                      ),
                      Center(
                        child: ShieldDateWrapper(
                          showShield: isShieldDate,
                          child: Text(
                            pageViewElementDate.day.toString(),
                            style: datesTextStyle != null
                                ? datesTextStyle.copyWith(
                                    color: datesTextColor,
                                  )
                                : TextStyle(color: datesTextColor),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}

class CalendarStreakEndDenseDate extends StatelessWidget {
  const CalendarStreakEndDenseDate(
      {super.key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate});

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    final int startWeekday = getIntFromWeekday(calendarProperties.startWeekday);

    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    double? datesBorderRadius =
        datesProperties.datesDecoration?.datesBorderRadius;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;
    final bool isShieldDate =
        calendarProperties.shieldDates.contains(pageViewElementDate);

    return !hide
        ? InkResponse(
            containedInkWell: true,
            highlightShape: BoxShape.rectangle,
            customBorder: datesBorderRadius != null
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(datesBorderRadius),
                      bottomRight: Radius.circular(datesBorderRadius),
                    ),
                  )
                : null,
            splashFactory: InkRipple.splashFactory,
            onTap: disable ? null : dateSuitableDatesOnTap,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 4.0,
                        bottom: 4.0,
                        left: pageViewElementDate.weekday == startWeekday
                            ? 4
                            : 0),
                    child: Container(
                      //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                      decoration: BoxDecoration(
                        border: datesBorderColor != null
                            ? Border(
                                top: BorderSide(
                                    color: datesBorderColor, width: 1),
                                bottom: BorderSide(
                                    color: datesBorderColor, width: 1),
                                // left:
                                //     BorderSide(color: datesBorderColor, width: 1),
                              )
                            : null,
                        color: datesBackgroundColor,
                      ),
                    ),
                  ),
                ),
                datesBackgroundColor != null
                    ? Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 4),
                        child: SpaceFixerVerticalInkLine(
                          overflowWidth: 1,
                          overflowColor: datesBackgroundColor,
                          border: datesBorderColor != null
                              ? Border.symmetric(
                                  horizontal: BorderSide(
                                      color: datesBorderColor, width: 1))
                              : null,
                        ),
                      )
                    : const SizedBox(),
                Stack(
                  children: [
                    SizedBox(
                      child: Container(
                        margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                        child: Container(
                          //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                          decoration: BoxDecoration(
                            border: datesBorderColor != null
                                ? Border.symmetric(
                                    horizontal: BorderSide(
                                        color: datesBorderColor, width: 1))
                                : null,
                            color: datesBackgroundColor,
                          ),
                          child: Container(
                            width:
                                DateSectionSizeProvider.instance.widthOfDate /
                                    2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: DateSectionSizeProvider.instance.widthOfDate,
                      child: Container(
                        margin: const EdgeInsets.all(4.0),
                        child: Container(
                          //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                          decoration: BoxDecoration(
                            border: datesBorderColor != null
                                ? Border.all(
                                    color: datesBorderColor, width: 1)
                                : null,
                            borderRadius: datesBorderRadius != null
                                ? BorderRadius.only(
                                    topRight:
                                        Radius.circular(datesBorderRadius),
                                    bottomRight:
                                        Radius.circular(datesBorderRadius),
                                  )
                                : null,
                            color: datesBackgroundColor,
                          ),
                          child: Center(
                            child: ShieldDateWrapper(
                              showShield: isShieldDate,
                              child: Text(
                                pageViewElementDate.day.toString(),
                                style: datesTextStyle != null
                                    ? datesTextStyle.copyWith(
                                        color: datesTextColor,
                                      )
                                    : TextStyle(color: datesTextColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}

class CalendarStreakEndDenseSplashDate extends StatelessWidget {
  const CalendarStreakEndDenseSplashDate(
      {super.key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate});

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final GlobalKey widgetKey = GlobalKey();

    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    final int startWeekday = getIntFromWeekday(calendarProperties.startWeekday);

    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    double? datesBorderRadius =
        datesProperties.datesDecoration?.datesBorderRadius;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;
    final bool isShieldDate =
        calendarProperties.shieldDates.contains(pageViewElementDate);

    return !hide
        ? InkResponse(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            enableFeedback: false,
            onTap: disable
                ? null
                : () {
                    Offset widgetCenterOffset =
                        getWidgetCenterOffsetInfo(widgetKey);
                    // print(widgetCenterOffset);
                    simulateTapOnAnOffset(widgetCenterOffset);
                  },
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 4.0,
                        bottom: 4.0,
                        left: pageViewElementDate.weekday == startWeekday
                            ? 4
                            : 0),
                    decoration: BoxDecoration(
                      border: datesBorderColor != null
                          ? Border.symmetric(
                              horizontal:
                                  BorderSide(color: datesBorderColor, width: 1))
                          : null,
                      color: datesBackgroundColor,
                    ),
                  ),
                ),
                datesBackgroundColor != null
                    ? Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 4),
                        child: SpaceFixerVerticalLine(
                          overflowWidth: 1,
                          overflowColor: datesBackgroundColor,
                          border: datesBorderColor != null
                              ? Border.symmetric(
                                  horizontal: BorderSide(
                                      color: datesBorderColor, width: 1))
                              : null,
                        ),
                      )
                    : const SizedBox(),
                InkResponse(
                  containedInkWell: true,
                  // highlightColor: Colors.blue,
                  highlightShape: BoxShape.rectangle,
                  customBorder: datesBorderRadius != null
                      ? RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(datesBorderRadius),
                            bottomRight: Radius.circular(datesBorderRadius),
                          ),
                        )
                      : null,
                  splashFactory: InkRipple.splashFactory,
                  onTap: dateSuitableDatesOnTap,
                  child: Stack(
                    children: [
                      SizedBox(
                        child: Container(
                          margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                          child: Container(
                            //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                            decoration: BoxDecoration(
                              border: datesBorderColor != null
                                  ? Border.symmetric(
                                      horizontal: BorderSide(
                                          color: datesBorderColor, width: 1))
                                  : null,
                              color: datesBackgroundColor,
                            ),
                            child: Container(
                              width:
                                  DateSectionSizeProvider.instance.widthOfDate /
                                      2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: DateSectionSizeProvider.instance.widthOfDate,
                        child: Container(
                          margin: const EdgeInsets.all(4.0),
                          child: Container(
                            //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                            decoration: BoxDecoration(
                              border: datesBorderColor != null
                                  ? Border.all(
                                      color: datesBorderColor, width: 1)
                                  : null,
                              borderRadius: datesBorderRadius != null
                                  ? BorderRadius.only(
                                      topRight:
                                          Radius.circular(datesBorderRadius),
                                      bottomRight:
                                          Radius.circular(datesBorderRadius),
                                    )
                                  : null,
                              color: datesBackgroundColor,
                            ),
                            child: Center(
                              child: ShieldDateWrapper(
                                showShield: isShieldDate,
                                child: Text(
                                  key: widgetKey,
                                  pageViewElementDate.day.toString(),
                                  style: datesTextStyle != null
                                      ? datesTextStyle.copyWith(
                                          color: datesTextColor,
                                        )
                                      : TextStyle(color: datesTextColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}

class CalendarStreakEndExpandedDate extends StatelessWidget {
  const CalendarStreakEndExpandedDate(
      {super.key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate});

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    final int startWeekday = getIntFromWeekday(calendarProperties.startWeekday);

    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    double? datesBorderRadius =
        datesProperties.datesDecoration?.datesBorderRadius;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;
    final bool isShieldDate =
        calendarProperties.shieldDates.contains(pageViewElementDate);

    return !hide
        ? InkResponse(
            containedInkWell: true,
            highlightShape: BoxShape.rectangle,
            customBorder: datesBorderRadius != null
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(datesBorderRadius),
                        bottomRight: Radius.circular(datesBorderRadius)),
                  )
                : null,
            splashFactory: InkRipple.splashFactory,
            onTap: disable ? null : dateSuitableDatesOnTap,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                  right: 4,
                  left: pageViewElementDate.weekday == startWeekday ? 4 : 0),
              child: Container(
                //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                decoration: BoxDecoration(
                  border: datesBorderColor != null
                      ? Border(
                          top: BorderSide(color: datesBorderColor, width: 1),
                          bottom:
                              BorderSide(color: datesBorderColor, width: 1),
                          left: BorderSide(color: datesBorderColor, width: 1),
                          right:
                              BorderSide(color: datesBorderColor, width: 1),
                        )
                      : null,
                  borderRadius: datesBorderRadius != null
                      ? BorderRadius.only(
                          topRight: Radius.circular(datesBorderRadius),
                          bottomRight: Radius.circular(datesBorderRadius))
                      : null,
                  color: datesBackgroundColor,
                ),
                child: Center(
                  child: ShieldDateWrapper(
                    showShield: isShieldDate,
                    child: Text(
                      pageViewElementDate.day.toString(),
                      style: datesTextStyle != null
                          ? datesTextStyle.copyWith(
                              color: datesTextColor,
                            )
                          : TextStyle(color: datesTextColor),
                    ),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}

class CalendarStreakSingleDenseDate extends StatelessWidget {
  const CalendarStreakSingleDenseDate(
      {super.key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate});

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    double? datesBorderRadius =
        datesProperties.datesDecoration?.datesBorderRadius;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;
    final bool isShieldDate =
        calendarProperties.shieldDates.contains(pageViewElementDate);

    return !hide
        ? InkResponse(
            containedInkWell: true,
            highlightShape: BoxShape.rectangle,
            customBorder: datesBorderRadius != null
                ? RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(datesBorderRadius)),
                  )
                : null,
            splashFactory: InkRipple.splashFactory,
            onTap: disable ? null : dateSuitableDatesOnTap,
            child: Row(
              children: [
                const Expanded(
                  child: SizedBox(),
                ),
                SizedBox(
                  width: DateSectionSizeProvider.instance.widthOfDate,
                  child: Container(
                    margin: const EdgeInsets.all(4.0),
                    child: Container(
                      //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                      decoration: BoxDecoration(
                        border: datesBorderColor != null
                            ? Border.all(color: datesBorderColor, width: 1)
                            : null,
                        borderRadius: datesBorderRadius != null
                            ? BorderRadius.all(
                                Radius.circular(datesBorderRadius))
                            : null,
                        color: datesBackgroundColor,
                      ),
                      child: Center(
                        child: ShieldDateWrapper(
                          showShield: isShieldDate,
                          child: Text(
                            pageViewElementDate.day.toString(),
                            style: datesTextStyle != null
                                ? datesTextStyle.copyWith(
                                    color: datesTextColor,
                                  )
                                : TextStyle(color: datesTextColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}

class CalendarStreakSingleDenseSplashDate extends StatelessWidget {
  const CalendarStreakSingleDenseSplashDate(
      {super.key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate});

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final GlobalKey widgetKey = GlobalKey();

    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    double? datesBorderRadius =
        datesProperties.datesDecoration?.datesBorderRadius;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;
    final bool isShieldDate =
        calendarProperties.shieldDates.contains(pageViewElementDate);

    return !hide
        ? InkResponse(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            enableFeedback: false,
            onTap: disable
                ? null
                : () {
                    Offset widgetCenterOffset =
                        getWidgetCenterOffsetInfo(widgetKey);
                    // print(widgetCenterOffset);
                    simulateTapOnAnOffset(widgetCenterOffset);
                  },
            child: Row(
              children: [
                const Expanded(
                  child: SizedBox(),
                ),
                InkResponse(
                  containedInkWell: true,
                  // highlightColor: Colors.blue,
                  highlightShape: BoxShape.rectangle,
                  customBorder: datesBorderRadius != null
                      ? RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(datesBorderRadius)),
                        )
                      : null,
                  splashFactory: InkRipple.splashFactory,
                  onTap: dateSuitableDatesOnTap,
                  child: SizedBox(
                    width: DateSectionSizeProvider.instance.widthOfDate,
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      child: Container(
                        //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                        decoration: BoxDecoration(
                          border: datesBorderColor != null
                              ? Border.all(color: datesBorderColor, width: 1)
                              : null,
                          borderRadius: datesBorderRadius != null
                              ? BorderRadius.all(
                                  Radius.circular(datesBorderRadius))
                              : null,
                          color: datesBackgroundColor,
                        ),
                        child: Center(
                          child: ShieldDateWrapper(
                            showShield: isShieldDate,
                            child: Text(
                              key: widgetKey,
                              pageViewElementDate.day.toString(),
                              style: datesTextStyle != null
                                  ? datesTextStyle.copyWith(
                                      color: datesTextColor,
                                    )
                                  : TextStyle(color: datesTextColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}

class CalendarStreakSingleExpandedDate extends StatelessWidget {
  const CalendarStreakSingleExpandedDate(
      {super.key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate});

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    double? datesBorderRadius =
        datesProperties.datesDecoration?.datesBorderRadius;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;
    final bool isShieldDate =
        calendarProperties.shieldDates.contains(pageViewElementDate);

    return !hide
        ? InkResponse(
            containedInkWell: true,
            highlightShape: BoxShape.rectangle,
            customBorder: datesBorderRadius != null
                ? RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(datesBorderRadius)),
                  )
                : null,
            splashFactory: InkRipple.splashFactory,
            onTap: disable ? null : dateSuitableDatesOnTap,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                decoration: BoxDecoration(
                  border: datesBorderColor != null
                      ? Border.all(color: datesBorderColor, width: 1)
                      : null,
                  borderRadius: datesBorderRadius != null
                      ? BorderRadius.all(Radius.circular(datesBorderRadius))
                      : null,
                  color: datesBackgroundColor,
                ),
                child: Center(
                  child: ShieldDateWrapper(
                    showShield: isShieldDate,
                    child: Text(
                      pageViewElementDate.day.toString(),
                      style: datesTextStyle != null
                          ? datesTextStyle.copyWith(
                              color: datesTextColor,
                            )
                          : TextStyle(color: datesTextColor),
                    ),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
