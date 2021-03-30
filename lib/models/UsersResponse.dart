import 'package:adminui/models/User.dart';


class UsersResponse {
  List<User> users;
  String error;


  UsersResponse();
  UsersResponse.mock(List<User> users):
        users  = users,error = "";
}