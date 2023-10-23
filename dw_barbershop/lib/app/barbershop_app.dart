import 'package:asyncstate/widget/async_state_builder.dart';
import 'package:dw_barbershop/app/core/ui/barbershop_nav_global_key.dart';
import 'package:dw_barbershop/app/core/ui/theme/barbershop_theme.dart';
import 'package:dw_barbershop/app/features/auth/register/barbershop/barbershop_register_page.dart';
import 'package:dw_barbershop/app/features/auth/register/user/user_register_page.dart';
import 'package:dw_barbershop/app/features/employees/register/employee_register_page.dart';
import 'package:dw_barbershop/app/features/employees/schedule/employee_schedule_page.dart';
import 'package:dw_barbershop/app/features/home/adm/home_adm_page.dart';
import 'package:dw_barbershop/app/features/home/employee/home_employee_page.dart';
import 'package:dw_barbershop/app/features/schedule/schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/ui/widgets/barbershop_loader.dart';
import 'features/auth/login/login_page.dart';
import 'features/splash/splash_page.dart';

class BarbershopApp extends StatelessWidget {
  const BarbershopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncStateBuilder(
      customLoader: const BarbershopLoader(),
      builder: (asyncNavigatorObserver) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: BarbershopNavGlobalKey.instance.navKey,
          title: 'DW Barbershop',
          theme: BarbershopTheme.themeData,
          navigatorObservers: [asyncNavigatorObserver],
          routes: {
            '/': (_) => const SplashPage(),
            '/auth/login': (_) => const LoginPage(),
            '/auth/register/user': (_) => const UserRegisterPage(),
            '/auth/register/barbershop': (_) => const BarbershopRegisterPage(),
            '/home/adm': (_) => const HomeAdmPage(),
            '/home/employee': (_) => const HomeEmployeePage(),
            '/employee/register': (_) => const EmployeeRegisterPage(),
            '/employee/schedule': (_) => const EmployeeSchedulePage(),
            '/schedule': (_) => const SchedulePage(),
          },
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('pt', 'BR')],
          locale: const Locale('pt', 'BR'),
        );
      },
    );
  }
}
