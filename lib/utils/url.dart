// abstract class AppEnv{
//   static const String protocol = 'http';
//   static const String ip = '127.0.0.1:8888';
//   static const String auth = '/token';
//   static const String user = '/user';
//   static const String accounting = '/accounting';
//   static const String history = '/history';
// }

enum URL {
  user('http://127.0.0.1:8888/user'),
  token('http://127.0.0.1:8888/token'),
  accounting('http://127.0.0.1:8888/accounting');

  final String value;

  const URL(this.value);
}