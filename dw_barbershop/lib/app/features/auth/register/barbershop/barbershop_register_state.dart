// ignore_for_file: public_member_api_docs, sort_constructors_first
enum BarbershopRegisterStateStatus {
  initial,
  success,
  error,
}

class BarbershoprReisterState {
  final BarbershopRegisterStateStatus status;
  final List<String> openingDays;
  final List<int> openingHours;

  BarbershoprReisterState.initial()
      : this(
          status: BarbershopRegisterStateStatus.initial,
          openingDays: <String>[],
          openingHours: <int>[],
        );

  BarbershoprReisterState({
    required this.status,
    required this.openingDays,
    required this.openingHours,
  });

  BarbershoprReisterState copyWith({
    BarbershopRegisterStateStatus? status,
    List<String>? openingDays,
    List<int>? openingHours,
  }) {
    return BarbershoprReisterState(
      status: status ?? this.status,
      openingDays: openingDays ?? this.openingDays,
      openingHours: openingHours ?? this.openingHours,
    );
  }
}
