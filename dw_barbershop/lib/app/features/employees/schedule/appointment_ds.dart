// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dw_barbershop/app/core/ui/styles/colors_app.dart';
import 'package:dw_barbershop/app/models/schedule_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentDs extends CalendarDataSource {
  final List<ScheduleModel> schedules;

  AppointmentDs({
    required this.schedules,
  });

  @override
  List<dynamic>? get appointments => schedules
      .map(
        (e) => Appointment(
          color: ColorsApp.brow,
          startTime: DateTime(
            e.date.year,
            e.date.month,
            e.date.day,
            e.hour,
            0,
            0,
          ),
          endTime: DateTime(
            e.date.year,
            e.date.month,
            e.date.day,
            e.hour + 1,
            0,
            0,
          ),
          subject: e.clientName,
        ),
      )
      .toList();
}
