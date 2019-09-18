import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/ui/animation/bars.dart';
import 'package:sink/ui/statistics/charts/chart_entry.dart';

const HEIGHT_PER_CHARACTER = 8;

const EdgeInsetsGeometry PADDING = const EdgeInsets.only(left: 2.0, right: 2.0);

class VerticalBarChart extends StatelessWidget {
  final List<DatedChartEntry> data;
  final double maxAmount;
  final double maxHeight;

  VerticalBarChart({
    @required this.data,
    @required this.maxAmount,
    @required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var barWidth = screenSize.width / 18;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: data
                .map((m) => ClickableVerticalBar(
                      entry: m,
                      width: barWidth,
                      maxHeight: maxHeight,
                      maxAmount: maxAmount,
                    ))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: data.map((m) => BarLabel(m, barWidth)).toList(),
          )
        ],
      ),
    );
  }
}

class ClickableVerticalBar extends StatelessWidget {
  final DatedChartEntry entry;
  final double width;
  final double maxHeight;

  final double heightPercentage;
  final String amount;
  final int textSize;

  ClickableVerticalBar._(
    this.entry,
    this.width,
    this.maxHeight,
    this.heightPercentage,
    this.amount,
    this.textSize,
  );

  factory ClickableVerticalBar({
    @required DatedChartEntry entry,
    @required double width,
    @required double maxHeight,
    @required double maxAmount,
  }) {
    final heightPercentage = entry.amount / maxAmount;
    final amount = entry.amount.toStringAsFixed(2);
    // fixme: a hack to prevent expansion of stats card
    final textSize = amount.length * HEIGHT_PER_CHARACTER;

    return ClickableVerticalBar._(
      entry,
      width,
      maxHeight,
      heightPercentage,
      amount,
      textSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    var date = this.entry.date;
    return StoreConnector(
      converter: _ClickableVerticalBarViewModel.fromState,
      builder: (BuildContext context, _ClickableVerticalBarViewModel vm) {
        return InkWell(
          onTap: () => vm.month != date.month ? vm.selectMonth(date) : null,
          child: Container(
            constraints: BoxConstraints(
              minHeight: maxHeight + textSize,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              key: ObjectKey(entry),
              children: <Widget>[
                RotatedBox(
                  quarterTurns: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      amount,
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(fontSize: 12.0),
                    ),
                  ),
                ),
                Padding(
                  key: ObjectKey(entry),
                  padding: PADDING,
                  child: AnimatedBar(
                    width: width,
                    height: maxHeight * heightPercentage,
                    color: entry.color,
                    horizontal: false,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ClickableVerticalBarViewModel {
  final Function(DateTime) selectMonth;
  final int month;

  _ClickableVerticalBarViewModel({
    @required this.selectMonth,
    @required this.month,
  });

  static _ClickableVerticalBarViewModel fromState(Store<AppState> store) {
    return _ClickableVerticalBarViewModel(
      selectMonth: (month) => store.dispatch(
        SelectMonth(getMonthEntryByDate(store.state, month)),
      ),
      month: getSelectedMonth(store.state).element.month,
    );
  }
}

class BarLabel extends StatelessWidget {
  final ChartEntry entry;
  final double width;

  BarLabel(this.entry, this.width);

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: ObjectKey(entry),
      padding: PADDING,
      child: Container(
        alignment: Alignment.center,
        width: width,
        child: RotatedBox(
          quarterTurns: 3,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text("${entry.label}"),
          ),
        ),
      ),
    );
  }
}
