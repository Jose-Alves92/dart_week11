import 'package:dw_barbershop/app/core/ui/styles/colors_app.dart';
import 'package:flutter/material.dart';

class HoursPanel extends StatefulWidget {
  final List<int>? enableTimes;
  final int startTime;
  final int endTime;
  final ValueChanged<int> onPressed;
  final bool singleSelection;

  const HoursPanel({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onPressed,
    this.enableTimes,
  }) : singleSelection = false;

  const HoursPanel.singleSelection({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onPressed,
    this.enableTimes,
  }) : singleSelection =  true;

  @override
  State<HoursPanel> createState() => _HoursPanelState();
}

class _HoursPanelState extends State<HoursPanel> {
  int? lastSelection;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecione os horários de atendimento',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 16,
          children: [
            for (int i = widget.startTime; i <= widget.endTime; i++)
              TimeButton(
                label: '${i.toString().padLeft(2, '0')}:00',
                value: i,
                enableTimes: widget.enableTimes,
                singleSelection: widget.singleSelection,
                timeSelected: lastSelection,
                onPressed: (timeSelected){
                  widget.onPressed(timeSelected);

                  setState(() {
                    if(widget.singleSelection){
                      if(lastSelection == timeSelected){
                        lastSelection = null;
                      } else{
                        lastSelection = timeSelected;
                      }
                    }
                  });
                },
              ),
          ],
        ),
      ],
    );
  }
}

class TimeButton extends StatefulWidget {
  final List<int>? enableTimes;
  final String label;
  final int value;
  final ValueChanged<int> onPressed;
  final bool singleSelection;
  final int? timeSelected;

  const TimeButton({
    super.key,
    required this.label,
    required this.value,
    required this.onPressed,
    this.enableTimes,
    required this.singleSelection, 
    required this.timeSelected,
  });

  @override
  State<TimeButton> createState() => _TimeButtonState();
}

class _TimeButtonState extends State<TimeButton> {
  var selected = false;

  @override
  Widget build(BuildContext context) {
    final TimeButton(:singleSelection, :timeSelected, :enableTimes, :value, :label, :onPressed,) = widget;

    if(singleSelection){
      if(timeSelected != null){
        if(timeSelected == value){
          selected = true;
        }else {
          selected = false;
        }
      }
    }

    final textColor = selected ? Colors.white : ColorsApp.grey;
    var buttonColor = selected ? ColorsApp.brow : Colors.white;
    final buttonBorderColor = selected ? ColorsApp.brow : ColorsApp.grey;
    
    final disableTime = enableTimes != null && !enableTimes.contains(value);

    if(disableTime){
      buttonColor = Colors.grey[400]!;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: disableTime ? null : () {
        setState(() {
          selected = !selected;
          onPressed(value);
        });
      },
      child: Container(
        height: 36,
        width: 64,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: buttonBorderColor),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
