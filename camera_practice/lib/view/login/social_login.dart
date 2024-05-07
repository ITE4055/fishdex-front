abstract class SocialLogin{
  //Future 이유는 비동기로 네트워크 통신
  Future<bool> login();
  Future<bool> logout();
}