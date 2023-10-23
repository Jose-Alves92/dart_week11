// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dw_barbershop/app/core/exceptions/auth_exception.dart';
import 'package:dw_barbershop/app/core/exceptions/repository_exception.dart';
import 'package:dw_barbershop/app/core/fp/either.dart';
import 'package:dw_barbershop/app/core/fp/nil.dart';
import 'package:dw_barbershop/app/core/restClient/rest_client.dart';
import 'package:dw_barbershop/app/models/user_model.dart';
import 'package:dw_barbershop/app/repositories/user/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RestClient restClient;

  UserRepositoryImpl({
    required this.restClient,
  });

  @override
  Future<Either<AuthException, String>> login(
      String email, String password) async {
    try {
      final Response(data: data) = await restClient.unAuth.post('/auth', data: {
        'email': email,
        'password': password,
      });

      return Success(data['access_token']);
    } on DioException catch (e, s) {
      if (e.response != null) {
        final Response(statusCode: statusCode) = e.response!;
        if (statusCode == HttpStatus.forbidden) {
          log('Login ou senha inválidos', error: e, stackTrace: s);
          return Failure(AuthUnauthorizedException());
        }
      }
      log('Erro ao realizar login', error: e, stackTrace: s);
      return Failure(AuthError(message: e.message!));
    }
  }

  @override
  Future<Either<RepositoryException, UserModel>> me() async {
    try {
      final Response(:data) = await restClient.auth.get('/me');

      return Success(UserModel.fromMap(data));
    } on DioException catch (e, s) {
      log('Erro ao buscar usuário', stackTrace: s);
      return Failure(
          RepositoryException(message: 'Erro ao buscar usuário logado'));
    } on ArgumentError catch (e, s) {
      log('Invalid json', stackTrace: s);
      return Failure(RepositoryException(message: e.message));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerAdmin(
      ({String email, String name, String password}) userData) async {
    try {
      await restClient.unAuth.post('/users', data: {
        'name': userData.name,
        'email': userData.email,
        'password': userData.password,
        'profile': 'ADM',
      });

      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao registar usuário admin', error: e, stackTrace: s);
      return Failure(
        RepositoryException(message: 'Erro ao registar usuário admin'),
      );
    }
  }

  @override
  Future<Either<RepositoryException, List<UserModel>>> getEmployees(
      int barbershopId) async {
    try {
      final Response(:List data) =
          await restClient.auth.get('/users', queryParameters: {
        'barbershop_id': barbershopId,
      });

      final employees = data.map((e) => UserModelEmployee.fromMap(e)).toList();

      return Success(employees);
    } on DioException catch (e, s) {
      log('Erro ao buscar colaboradores', error: e, stackTrace: s);
      return Failure(
          RepositoryException(message: 'Erro ao buscar colaboradores'));
    } on ArgumentError catch (e, s) {
      log('Erro ao converter colaboradores (Invalid json)',
          error: e, stackTrace: s);
      return Failure(RepositoryException(
          message: 'Erro ao converter colaboradores (Invalid json)'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerAdmAsEmployee(
      ({ 
     
        List<String> workdays,
        List<int> workhours,
      }) userModel) async {
    try {
      final userModelResult = await me();

      final int userId;

      switch (userModelResult) {
        case Success(value: UserModel(:var id)):
          userId = id;
        case Failure(:var exception):
          return Failure(exception);
      }

      await restClient.auth.put('/users/$userId', data: {
       
        'work_days': userModel.workdays,
        'work_hours': userModel.workhours,
      });

      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao inserir administrador como colaborador',
          error: e, stackTrace: s);
      return Failure(
        RepositoryException(
            message: 'Erro ao inserir administrador como colaborador'),
      );
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerEmployee(
      ({
        int barbershopId,
        String email,
        String name,
        String password,
        List<String> workdays,
        List<int> workhours,
      }) userModel) async {
    try {
      await restClient.auth.post('/users', data: {
        'barbershop_id': userModel.barbershopId,
        'name': userModel.name,
        'email': userModel.email,
        'password': userModel.password,
        'profile': 'EMPLOYEE',
        'work_days': userModel.workdays,
        'work_hours': userModel.workhours,
      });

      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao registrar colaborador', error: e, stackTrace: s);
      return Failure(
        RepositoryException(message: 'Erro ao registrar colaborador'),
      );
    }
  }
}
