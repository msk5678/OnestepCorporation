class AuthFlag {
  bool isEmailChecked;
  bool isEmailErrorUnderLine;
  bool isEmailDupliCheckUnderLine;
  bool isSendUnderLine;
  bool isAuthNumber;
  bool isTimeOverChecked;
  bool isTimerChecked;
  bool isSendClick;

  void initAuth() {
    this.isEmailChecked = false;
    this.isEmailErrorUnderLine = true;
    this.isEmailDupliCheckUnderLine = true;
    this.isSendUnderLine = true;
    this.isAuthNumber = true;
    this.isTimeOverChecked = true;
    this.isTimerChecked = false;
    this.isSendClick = false;
  }

  AuthFlag({
    this.isEmailChecked = false,
    this.isEmailErrorUnderLine = true,
    this.isEmailDupliCheckUnderLine = true,
    this.isSendUnderLine = true,
    this.isAuthNumber = true,
    this.isTimeOverChecked = true,
    this.isTimerChecked = false,
    this.isSendClick = false,
  });
}
