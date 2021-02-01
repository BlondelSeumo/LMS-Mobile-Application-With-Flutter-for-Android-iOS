class Loginresponse {
  String tokenType;
  int expiresIn;
  String accessToken;
  String refreshToken;

  Loginresponse(
      this.tokenType, this.expiresIn, this.accessToken, this.refreshToken);
}
