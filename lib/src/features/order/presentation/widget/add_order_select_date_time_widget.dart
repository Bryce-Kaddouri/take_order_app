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
            header:
                TranslationHelper(context: context).getTranslation('pickDate'),
            selected: widget.selectedDate,
            onChanged: (time) {
              widget.onSelectedDate(time);
              /*setState(() {
                selectedDate = selectedDate.copyWith(year: time.year, month: time.month, day: time.day);
              });*/
            },
          ),
          SizedBox(
            height: 20,
          ),
          TimePicker(
            header:
                TranslationHelper(context: context).getTranslation('pickTime'),
            selected: widget.selectedDate,
            onChanged: (DateTime time) {
              widget.onSelectedTime(time);
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
