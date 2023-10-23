
import 'package:dw_barbershop/app/core/providers/application_providers.dart';
import 'package:dw_barbershop/app/core/ui/styles/colors_app.dart';
import 'package:dw_barbershop/app/core/ui/widgets/avatar_widget.dart';
import 'package:dw_barbershop/app/core/ui/widgets/barbershop_loader.dart';
import 'package:dw_barbershop/app/features/home/employee/home_employee_provider.dart';
import 'package:dw_barbershop/app/features/home/widgets/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeEmployeePage extends ConsumerWidget {
  const HomeEmployeePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModelAsync = ref.watch(getMeProvider);

    return Scaffold(
      body: userModelAsync.when(
        error: (error, stackTrace) {
          return const Center(
            child: Text('Erro ao carregar página'),
          );
        },
        loading: () => const BarbershopLoader(),
        data: (user) => CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: HomeHeader.withoutFilter(),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const AvatarWidget(hideUploadButton: true),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .7,
                      height: 108,
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorsApp.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer(
                            builder: (context, ref, child) {
                              final totalAsync = ref.watch(getTotalSchedulesTodayProvider(user.id));
                              return totalAsync.when(
                                error: (error, stackTrace) {
                                  return const Center(
                                    child: Text(
                                        'Erro ao carregar total de agendamentos'),
                                  );
                                },
                                loading: () => const BarbershopLoader(),
                                skipLoadingOnRefresh: false,
                                data: (totalSchedule) => Text(
                                  totalSchedule.toString(),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                    color: ColorsApp.brow,
                                  ),
                                ),
                              );
                            },
                          ),
                          const Text(
                            'Hoje',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56)),
                      onPressed: () async {
                        await Navigator.of(context).pushNamed('/schedule', arguments: user);
                        ref.invalidate(getTotalSchedulesTodayProvider);
                      },
                      child: const Text('AGENDAR CLIENTE'),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56)),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed('/employee/schedule', arguments: user);
                      },
                      child: const Text('VER AGENDA'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
