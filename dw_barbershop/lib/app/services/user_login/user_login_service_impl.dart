// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dw_barbershop/app/core/exceptions/auth_exception.dart';
import 'package:dw_barbershop/app/core/exceptions/service_exception.dart';
import 'package:dw_barbershop/app/core/fp/either.dart';
import 'package:dw_barbershop/app/core/fp/nil.dart';
import 'package:dw_barbershop/app/core/utils/constants.dart';
import 'package:dw_barbershop/app/repositories/user/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_login_service.dart';

class UserLoginServiceImpl implements UserLoginService {
  final UserRepository userRepository;
  UserLoginServiceImpl({
    required this.userRepository,
  });

  @override
  Future<Either<ServiceException, Nil>> execute(String email, String password) async {
   final loginResult = await userRepository.login(email, password);

   switch(loginResult) {
    case Success(value: final accessToken):
      final sp = await SharedPreferences.getInstance();
      sp.setString(Constants.ACCESSTOKENKEY, accessToken);
      return Success(nil);
    case Failure(exception:final exception):
     switch(exception) {
      case AuthError():
        return Failure(ServiceException(message: 'Erro ao realizar login'));
      case AuthUnauthorizedException():
        return Failure(ServiceException(message: 'Login ou senha inválidos')); 
     }  
   }
  }

}
