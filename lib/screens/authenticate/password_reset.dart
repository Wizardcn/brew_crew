import 'package:brew_crew/services/auth.dart';

void main() async {
  final auth = AuthService();
  await auth.sendPasswordResetEmail('supawat125947@gmail.com');
}
