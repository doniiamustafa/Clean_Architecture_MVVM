import 'dart:developer';

import 'package:clean_architecture/data/network/app_api.dart';
import 'package:clean_architecture/data/requests/requests.dart';
import 'package:clean_architecture/data/responses/response.dart';

abstract class RemoteDataSource {
  Future<AuthenticationResponse> login(LoginRequest loginRequest);
  Future<ForgetPasswordResponse> forgetPassword(String email);
  Future<AuthenticationResponse> register(RegisterRequest registerRequest);
  Future<HomeResponse> getHomeData();
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
    log("username ${registerRequest.userName}, password ${registerRequest.password}, email ${registerRequest.email}, mobileCode${registerRequest.mobileCode}, mobileNumber ${registerRequest.mobileNumber}");
    return await appServiceClient.register(
      userName: registerRequest.userName,
      email: registerRequest.email,
      password: registerRequest.password,
      mobileCode: registerRequest.mobileCode,
      mobileNumber: registerRequest.mobileNumber,
      profilePicture: "",
    );
  }

  @override
  Future<HomeResponse> getHomeData() async {
    return await appServiceClient.getHomeData();
  }
}
