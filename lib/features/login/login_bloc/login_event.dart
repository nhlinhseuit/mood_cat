part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginWithEmailPassword extends LoginEvent {
  final String email;
  final String password;

  const LoginWithEmailPassword(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class LoginWithOnlyEmail extends LoginEvent {
  final String email;

  const LoginWithOnlyEmail(this.email);

  @override
  List<Object> get props => [email];
}

class LoginWithFacebook extends LoginEvent {}

class LoginWithGoogle extends LoginEvent {}

class LoginWithPhone extends LoginEvent {
  final String phoneNumber;

  const LoginWithPhone(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}
