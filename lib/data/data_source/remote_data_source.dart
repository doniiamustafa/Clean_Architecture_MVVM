import 'package:clean_architecture/data/network/app_api.dart';
import 'package:clean_architecture/data/requests/requests.dart';
import 'package:clean_architecture/data/responses/response.dart';

abstract class RemoteDataSource {
  Future<AuthenticationResponse> login(LoginRequest loginRequest);
  Future<ForgetPasswordResponse> forgetPassword(String email);
  Future<AuthenticationResponse> register(RegisterRequest registerRequest);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final AppServiceClient appServiceClient;
  RemoteDataSourceImpl(this.appServiceClient);
  @override
  Future<AuthenticationResponse> login(LoginRequest loginRequest) async {
    return await appServiceClient.login(
        loginRequest.email, loginRequest.password);
  }

  @override
  Future<ForgetPasswordResponse> forgetPassword(String email) async {
    return await appServiceClient.forgetPassword(email);
  }

  @override
  Future<AuthenticationResponse> register(
      RegisterRequest registerRequest) async {
    return await appServiceClient.register(
        registerRequest.email,
        registerRequest.password,
        registerRequest.mobileCode,
        registerRequest.mobileNumber,
        registerRequest.profilePicture,
        registerRequest.userName);
  }
}
