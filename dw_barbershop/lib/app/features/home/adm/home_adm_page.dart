import 'dart:developer';

import 'package:dw_barbershop/app/core/providers/application_providers.dart';
import 'package:dw_barbershop/app/core/ui/styles/colors_app.dart';
import 'package:dw_barbershop/app/core/ui/styles/icons_app.dart';
import 'package:dw_barbershop/app/core/ui/widgets/barbershop_loader.dart';
import 'package:dw_barbershop/app/features/home/adm/home_adm_vm.dart';
import 'package:dw_barbershop/app/features/home/adm/widgets/home_employee_tile.dart';
import 'package:dw_barbershop/app/features/home/widgets/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeAdmPage extends ConsumerWidget {
  const HomeAdmPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeAdmVmProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: ColorsApp.brow,
        onPressed: () async{
          await Navigator.of(context).pushNamed('/employee/register');
          ref.invalidate(getMeProvider);
          ref.invalidate(homeAdmVmProvider);
        },
        child: const CircleAvatar(
          backgroundColor: Colors.white,
          maxRadius: 12,
          child: Icon(
            IconsApp.addEmployee,
            color: ColorsApp.brow,
          ),
        ),
      ),
      body: homeState.when(
        data: (data) {
          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: HomeHeader(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => HomeEmployeeTile(employee: data.employee[index]),
                  childCount: data.employee.length,
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          log('Erro ao carregar colaboradores', error: error, stackTrace: stackTrace);
          return const Center(child: Text('Erro ao carregar página'));
        },
        loading: () {
          return const BarbershopLoader();
        },
      ),
    );
  }
}
