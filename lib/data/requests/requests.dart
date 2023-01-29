class LoginRequest {
  String email;
  String password;
  LoginRequest(this.email, this.password);
}

class RegisterRequest {
  String userName;
  String email;
  String password;
  String mobileCode;
  String mobileNumber;
  String profilePicture;
  RegisterRequest(
      {required this.userName,
      required this.email,
      required this.password,
      required this.mobileNumber,
      required this.mobileCode,
      required this.profilePicture});
}
