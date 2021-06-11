import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

sendEmailAuth([
  String checkPassword = "",
  String universityEmail = "",
]) async {
  // schollAuthFlag = 1 이면 학교인증 sendMail
  // schollAuthFlag = 2 이면 증명서

  // String smtpServerName = 'smtp.gmail.com';
  // int smtpPort = 465;

  // 회사 공용 email 들어가야하고
  String smtpUserName = 'leedool3003@gmail.com';
  String smtpPassword = 'alstjsdl421!';

  // final smtpServer = SmtpServer(
  //   smtpServerName,
  //   port: smtpPort,
  //   ssl: true,
  //   ignoreBadCertificate: false,
  //   allowInsecure: false,
  //   username: smtpUserName,
  //   password: smtpPassword,
  // );
  //

  final _smtpServer = gmail(smtpUserName, smtpPassword);

  final message = Message()
    ..from = Address(smtpUserName)
    ..recipients
        .add('5414030@stu.kmu.ac.kr') // 받는사람 email -> universityEmail 로 받아옴
    ..subject =
        'Test Dart Mailer library :: 😀 :: ${DateTime.now().add(Duration(hours: 9))}' // title
    ..html =
        "<h1>Test</h1>\n<p>Hey! Here's some $checkPassword</p>\n본 인증 코드는 5분동안 유효합니다. "; // body of the email
  try {
    final sendReport = await send(message, _smtpServer);
    print("cex 성공");
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print("cex 실패");
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}

sendCertificateAuth([
  String certificateURL = "",
  String storageNum = "",
]) async {
  // print("@@@@@@@@@@@@@@@@@@@@@@ url = $certificateURL num = $storageNum");
  // String smtpUserName = 'leedool3003@gmail.com';
  // String smtpPassword = 'alstjsdl421!';

  // final _smtpServer = gmail(smtpUserName, smtpPassword);

  // final message = Message()
  //   ..from = Address(smtpUserName)
  //   ..recipients.add('leedool3003@naver.com')
  //   ..subject =
  //       'Test Dart Mailer library :: 😀 :: ${DateTime.now().add(Duration(hours: 9))}' // title
  //   ..html =
  //       "<h1>Test</h1>\n<p>Hey! Here's url $certificateURL</p>\n storageNum = $storageNum"; // body of the email
  // try {
  //   final sendReport = await send(message, _smtpServer);
  //   print('Message sent: ' + sendReport.toString());
  // } on MailerException catch (e) {
  //   print('Message not sent.');
  //   for (var p in e.problems) {
  //     print('Problem: ${p.code}: ${p.msg}');
  //   }
  // }
}
