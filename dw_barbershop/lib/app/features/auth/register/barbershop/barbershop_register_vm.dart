import 'package:dw_barbershop/app/core/fp/either.dart';
import 'package:dw_barbershop/app/core/providers/application_providers.dart';
import 'package:dw_barbershop/app/features/auth/register/barbershop/barbershop_register_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'barbershop_register_vm.g.dart';

@riverpod
class BarbershopRegisterVm extends _$BarbershopRegisterVm {

  @override
  BarbershoprReisterState build() => BarbershoprReisterState.initial();

  void addOrRemoveOpenDay(String weekDay) {
    final openingDays = state.openingDays;

    if(openingDays.contains(weekDay)) {
      openingDays.remove(weekDay);
    } else {
      openingDays.add(weekDay);
    }

    state = state.copyWith(openingDays: openingDays); 
  }
  
  void addOrRemoveOpenHour(int weekHour) {
    final openingHours = state.openingHours;

    if(openingHours.contains(weekHour)) {
      openingHours.remove(weekHour);
    } else {
      openingHours.add(weekHour);
    }

    state = state.copyWith(openingHours: openingHours); 
  }

  Future<void> register(String name, String email) async {
    final repository = ref.watch(barbershopRepositoryProvider);
    final BarbershoprReisterState(:openingDays, :openingHours) = state;

    final dto = (
      name: name,
      email: email,
      openingDays: openingDays,
      openingHours: openingHours,
    );

    final registerResult = await repository.save(dto);

    switch(registerResult) {
      case Success():
        ref.invalidate(getMyBarbershopProvider);
        state = state.copyWith(status: BarbershopRegisterStateStatus.success);
      case Failure():
        state = state.copyWith(status: BarbershopRegisterStateStatus.error);
    }
  }
}