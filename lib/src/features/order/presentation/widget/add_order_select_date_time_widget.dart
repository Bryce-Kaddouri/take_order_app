import 'package:fluent_ui/fluent_ui.dart';
import 'package:take_order_app/main.dart';

class SelectDateTimePage extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onSelectedDate;
  final Function(DateTime) onSelectedTime;

  SelectDateTimePage(
      {super.key,
      required this.selectedDate,
      required this.onSelectedDate,
      required this.onSelectedTime});

  @override
  State<SelectDateTimePage> createState() => _SelectDateTimePageState();
}

class _SelectDateTimePageState extends State<SelectDateTimePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DatePicker(
            startDate: DateTime.now(),
            header:
                TranslationHelper(context: context).getTranslation('pickDate'),
            selected: widget.selectedDate,
            onChanged: (time) {
              DateTime finalTime =
                  DateTime(time.year, time.month, time.day, 0, 0);
              if (finalTime.isBefore(DateTime.now().copyWith(
                  hour: 0,
                  minute: 0,
                  second: 0,
                  millisecond: 0,
                  microsecond: 0))) {
                displayInfoBar(
                  alignment: Alignment.topRight,
                  context,
                  builder: (context, close) => InfoBar(
                    title: Text('Invalid Date'),
                    content: Text('Please select a date in the future'),
                    action: IconButton(
                      icon: const Icon(FluentIcons.clear),
                      onPressed: close,
                    ),
                    severity: InfoBarSeverity.error,
                  ),
                );
              } else {
                widget.onSelectedDate(time);
              }
              /*setState(() {
                selectedDate = selectedDate.copyWith(year: time.year, month: time.month, day: time.day);
              });*/
            },
          ),
          SizedBox(
            height: 20,
          ),
          TimePicker(
            minuteIncrement: 15,
            header:
                TranslationHelper(context: context).getTranslation('pickTime'),
            selected: widget.selectedDate,
            onChanged: (DateTime time) {
              DateTime finalTime = DateTime(
                  widget.selectedDate.year,
                  widget.selectedDate.month,
                  widget.selectedDate.day,
                  time.hour,
                  time.minute);
              if (finalTime.isBefore(DateTime.now())) {
                displayInfoBar(
                  alignment: Alignment.topRight,
                  context,
                  builder: (context, close) => InfoBar(
                    title: Text('Invalid Time'),
                    content: Text('Please select a time in the future'),
                    action: IconButton(
                      icon: const Icon(FluentIcons.clear),
                      onPressed: close,
                    ),
                    severity: InfoBarSeverity.error,
                  ),
                );
              } else {
                widget.onSelectedTime(time);
              }
              /* setState(() {
                selectedDate = selectedDate.copyWith(hour: time.hour, minute: time.minute);
              });*/
            },
            hourFormat: HourFormat.HH,
          ),
        ],
      ),
    );
  }
}
