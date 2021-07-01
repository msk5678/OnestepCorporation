class AuthFlag {
  bool isEmailChecked;
  bool isEmailErrorUnderLine;
  bool isEmailDupliCheckUnderLine;
  bool isSendUnderLine;
  bool isAuthNumber;
  bool isTimeOverChecked;
  bool isTimerChecked;
  bool isSendClick;
  bool isShowBtn;
  int levelClock;

  void initAuth() {
    this.isEmailChecked = false;
    this.isEmailErrorUnderLine = true;
    this.isEmailDupliCheckUnderLine = true;
    this.isSendUnderLine = true;
    this.isAuthNumber = true;
    this.isTimeOverChecked = true;
    this.isTimerChecked = false;
    this.isSendClick = false;
    this.isShowBtn = false;
    this.levelClock = 300;
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
    this.isShowBtn = false,
    this.levelClock = 300,
  });
}
