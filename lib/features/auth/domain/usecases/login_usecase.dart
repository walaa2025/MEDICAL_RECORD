
import 'package:dartz/dartz.dart';
import 'package:midical_record/features/auth/domain/entities/auth_entity.dart';
import 'package:midical_record/features/auth/domain/repositories/auth_repository.dart';

// Use Case for logging in.
// A Use Case encapsulates a single business rule or action.
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  // The 'call' method allows us to use the class instance like a function.
  // It takes the national ID and password and delegates to the repository.
  Future<Either<Failure, AuthEntity>> call(String nationalId, String password) async {
    return await _repository.login(nationalId, password);
  }
}
