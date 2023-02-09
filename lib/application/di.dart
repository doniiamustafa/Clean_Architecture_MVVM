import 'package:clean_architecture/application/app_prefs.dart';
import 'package:clean_architecture/data/data_source/remote_data_source.dart';
import 'package:clean_architecture/data/network/app_api.dart';
import 'package:clean_architecture/data/network/dio_factory.dart';
import 'package:clean_architecture/data/network/network_info.dart';
import 'package:clean_architecture/data/repository_impl/repository_impl.dart';
import 'package:clean_architecture/domain/repository/repository.dart';
import 'package:clean_architecture/domain/usecases/forgetPassword_usecase.dart';
import 'package:clean_architecture/domain/usecases/getHomeData_usecase.dart';
import 'package:clean_architecture/domain/usecases/login_usecase.dart';
import 'package:clean_architecture/domain/usecases/register_usecase.dart';
import 'package:clean_architecture/presentation/forgot_password/view_model/forgetpassword_viewmodel.dart';
import 'package:clean_architecture/presentation/login/view_model/login_view_model.dart';
import 'package:clean_architecture/presentation/main/pages/home/home_view_model.dart';
import 'package:clean_architecture/presentation/register/view_model/register_view_model.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final instance = GetIt.instance; //3lshan a3raf a3melo access fl app kolo

Future<void> initAppModule() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  // Shared Preferences
  instance.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // App Preferences
  // = () => AppPreferences(instance())); howa hydwar yshof eh el instance eli gowa el app preference w haygebo
  instance.registerLazySingleton<AppPreferences>(() => AppPreferences(instance<
      SharedPreferences>())); // aw mmkn a7dedo hatgeb mn gowa el app preference el instance of sharedPreference

  // Network Info
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  // Dio Factory
  instance.registerLazySingleton<DioFactory>(() => DioFactory(
      instance())); // 3amlt object mn el dio factory file eli ana 3amla

  Dio dio = await instance<DioFactory>()
      .getDio(); // 3amlt object mn el dio package 3lshan ha7tagha fl constructor bta3 el app service client

  // App Service Client
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  // Remote Data Source
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance()));

  // Repository
  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance()));
}

initLoginModule() {
  // hastakhdem register factory 3lshan bastkhdem el login mara wahda lel user fa kol mara 3iza y3mel object gded

  // ha3mel if condition law el user madkhalsh 3la el login abl kda hakhli ykhosh w a3mel register lel object eli dkhal
  // else law kan already dkhal abl kda w el object ma3molo register, hastakhdem el object da msh ha3mel wahed gded (else null)
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    // Login UseCase
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));

    // Login View Model
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }
}

initForgetPasswordModule() {
  if (!GetIt.I.isRegistered<ForgetPasswordUsecase>()) {
    instance.registerFactory<ForgetPasswordUsecase>(
        () => ForgetPasswordUsecase(instance()));
    instance.registerFactory<ForgetPasswordViewModel>(
        () => ForgetPasswordViewModel(instance()));
  }
}

initRegisterModule() {
  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    instance
        .registerFactory<RegisterUseCase>(() => RegisterUseCase(instance()));
    instance.registerFactory<RegisterViewModel>(
        () => RegisterViewModel(instance()));
    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }
}

initHomeModule() {
  if (!GetIt.I.isRegistered<HomeDataUseCase>()) {
    instance
        .registerFactory<HomeDataUseCase>(() => HomeDataUseCase(instance()));
    instance.registerFactory<HomeViewModel>(() => HomeViewModel(instance()));
  }
}
