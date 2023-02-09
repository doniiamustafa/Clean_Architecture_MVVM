import 'package:clean_architecture/application/app_constants.dart';
import 'package:clean_architecture/data/responses/response.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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

  @POST("/customer/register")
  Future<AuthenticationResponse> register({
    // lazem named parameters 3lshan el values matkhoshesh f b3d lma n3melha call

    @Field("user_name") required String userName,
    @Field("email") required String email,
    @Field("password") required String password,
    @Field("country_mobile_code") required String mobileCode,
    @Field("mobile_number") required String mobileNumber,
    @Field("profile_picture") required String profilePicture,
  });

  @GET("/home")
  Future<HomeResponse> getHomeData();
}
