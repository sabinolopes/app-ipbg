import 'package:app_igreja_guacui/domains/schedule/types.dart';
import 'package:app_igreja_guacui/shared/long_date.dart';
import 'package:flutter/material.dart';

class SlotList extends StatelessWidget {
  const SlotList({required this.slots, required this.onSelect, super.key});

  final List<ScheduleSlot> slots;
  final ValueChanged<ScheduleSlot> onSelect;

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return const Center(child: Text('Nenhum horário disponível no momento.'));
    }

    return ListView.separated(
      itemCount: slots.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) => _slotItem(slots[index]),
    );
  }

  Widget _slotItem(ScheduleSlot slot) {
    return ListTile(
      leading: const Icon(Icons.event_available),
      title: Text(weekdayAndDay(slot.start)),
      subtitle: Text(timeRange(slot.start, slot.end)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => onSelect(slot),
    );
  }
}
