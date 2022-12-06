import 'package:clean_architecture/application/app_constants.dart';
import 'package:clean_architecture/data/responses/response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'app_api.g.dart';

@RestApi(baseUrl: Constant.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @POST("/customer/login")
  Future<AuthenticationResponse> login(
      @Field("email") String email, @Field("password") String password);

  @POST("/customer/forget-password")
  Future<ForgetPasswordResponse> forgetPassword(@Field("email") String email);
}
