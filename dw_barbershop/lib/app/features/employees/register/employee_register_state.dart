// ignore_for_file: public_member_api_docs, sort_constructors_first

enum EmployeeRegisterStateStatus {
  initial,
  success,
  error,
}

class EmployeeRegisterState {
  final EmployeeRegisterStateStatus status;
  final bool registerADM;
  final List<String> workdays;
  final List<int> workhours;

  EmployeeRegisterState.initial()
      : this(
          registerADM: false,
          status: EmployeeRegisterStateStatus.initial,
          workdays: <String>[],
          workhours: <int>[],
        );

  EmployeeRegisterState({
    required this.status,
    required this.registerADM,
    required this.workdays,
    required this.workhours,
  });

  EmployeeRegisterState copyWith({
    EmployeeRegisterStateStatus? status,
    bool? registerADM,
    List<String>? workdays,
    List<int>? workhours,
  }) {
    return EmployeeRegisterState(
      status: status ?? this.status,
      registerADM: registerADM ?? this.registerADM,
      workdays: workdays ?? this.workdays,
      workhours: workhours ?? this.workhours,
    );
  }
}
