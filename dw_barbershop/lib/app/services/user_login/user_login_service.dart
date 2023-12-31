import 'package:dw_barbershop/app/core/exceptions/service_exception.dart';
import 'package:dw_barbershop/app/core/fp/either.dart';
import 'package:dw_barbershop/app/core/fp/nil.dart';

abstract class UserLoginService {
  Future<Either<ServiceException, Nil>> execute(String email, String password);
}