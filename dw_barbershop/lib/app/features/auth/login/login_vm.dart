import 'package:asyncstate/asyncstate.dart';
import 'package:dw_barbershop/app/core/exceptions/service_exception.dart';
import 'package:dw_barbershop/app/core/fp/either.dart';
import 'package:dw_barbershop/app/core/providers/application_providers.dart';
import 'package:dw_barbershop/app/features/auth/login/login_state.dart';
import 'package:dw_barbershop/app/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_vm.g.dart';

@riverpod
class LoginVm extends _$LoginVm {
  @override
  LoginState build() => LoginState.initial();

  Future<void> login(String email, String password) async {

    final loaderHandler = AsyncLoaderHandler()..start();

    final loginService = ref.watch(userLoginServiceProvider);

    final result = await loginService.execute(email, password);

    switch (result) {
      case Success():
      //Invalidando os caches para evitar o login com usuário errado!
      ref.invalidate(getMeProvider);
      ref.invalidate(getMyBarbershopProvider);

      //buscar dados do usuário logado
      //Fazer uma analize para qual o tipo de login
        final userModel = await ref.read(getMeProvider.future);
        switch(userModel) {
          case UserModelADM():
            state = state.copyWith(status: LoginStateStatus.admLogin);
          case UserModelEmployee():
            state = state.copyWith(status: LoginStateStatus.employeeLogin);
        }
        break;
      case Failure(exception: ServiceException(message: final message)):
        state = state.copyWith(
          status: LoginStateStatus.error,
          errorMessage: () => message,
        );
    }
    loaderHandler.close();

  }
}
