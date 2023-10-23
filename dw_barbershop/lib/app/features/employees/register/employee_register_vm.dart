import 'package:asyncstate/asyncstate.dart';
import 'package:dw_barbershop/app/core/exceptions/repository_exception.dart';
import 'package:dw_barbershop/app/core/fp/either.dart';
import 'package:dw_barbershop/app/core/fp/nil.dart';
import 'package:dw_barbershop/app/core/providers/application_providers.dart';
import 'package:dw_barbershop/app/features/employees/register/employee_register_state.dart';
import 'package:dw_barbershop/app/models/barbershop_model.dart';
import 'package:dw_barbershop/app/repositories/user/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee_register_vm.g.dart';

@riverpod
class EmployeeRegisterVm extends _$EmployeeRegisterVm {
  @override
  EmployeeRegisterState build() => EmployeeRegisterState.initial();

  void setRegisterADM(bool isRegisterADM) {
    state = state.copyWith(registerADM: isRegisterADM);
  }

  void addOrRemoveWorkdays(String workday) {
    final EmployeeRegisterState(:workdays) = state;

    if (workdays.contains(workday)) {
      workdays.remove(workday);
    } else {
      workdays.add(workday);
    }

    state = state.copyWith(workdays: workdays);
  }

  void addOrRemoveWorkhours(int workhour) {
    final EmployeeRegisterState(:workhours) = state;

    if (workhours.contains(workhour)) {
      workhours.remove(workhour);
    } else {
      workhours.add(workhour);
    }

    state = state.copyWith(workhours: workhours);
  }

  Future<void> register({String? name, String? email, String? password}) async {
    final EmployeeRegisterState(:registerADM, :workdays, :workhours) = state;
    final asyncLoaderHandler = AsyncLoaderHandler()..start();

    final UserRepository(:registerAdmAsEmployee, :registerEmployee) =
        ref.read(userRepositoryProvider);

      final BarbershopModel(id: id) =
          await ref.watch(getMyBarbershopProvider.future);

    final Either<RepositoryException, Nil> resultRegister;

    if (registerADM) {
      final dto = (
        workdays: workdays,
        workhours: workhours,
      );

      resultRegister = await registerAdmAsEmployee(dto);
    } else {
      final dto = (
        barbershopId: id,
        name: name!,
        email: email!,
        password: password!,
        workdays: workdays,
        workhours: workhours,
      );

      resultRegister = await registerEmployee(dto);
    }

    switch (resultRegister) {
      case Success():
        state = state.copyWith(status: EmployeeRegisterStateStatus.success);
      case Failure():
        state = state.copyWith(status: EmployeeRegisterStateStatus.error);
    }
    asyncLoaderHandler.close();
  }
}
