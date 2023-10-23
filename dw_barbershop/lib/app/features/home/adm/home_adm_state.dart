// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dw_barbershop/app/models/user_model.dart';

enum HomeAdmStateStatus {
  loaded,
  error,
}

class HomeAdmState {
  final HomeAdmStateStatus status;
  final List<UserModel> employee;

  HomeAdmState({
    required this.status,
    required this.employee,
  });

  HomeAdmState copyWith({
    HomeAdmStateStatus? status,
    List<UserModel>? employee,
  }) {
    return HomeAdmState(
      status: status ?? this.status,
      employee: employee ?? this.employee,
    );
  }
}
