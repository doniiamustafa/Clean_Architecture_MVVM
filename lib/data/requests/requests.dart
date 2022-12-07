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
  RegisterRequest(this.userName, this.email, this.password, this.mobileNumber,
      this.mobileCode, this.profilePicture);
}
