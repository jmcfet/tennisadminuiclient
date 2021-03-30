import 'package:adminui/models/UsersResponse.dart';
import 'package:adminui/repository/UserRepository.dart';
import 'package:rxdart/rxdart.dart';

class UsersBloc {
  final UserRepository _repository = UserRepository();
  final BehaviorSubject<UsersResponse> _subject =
  BehaviorSubject<UsersResponse>();

  getUsers() async {
    //getGroups(){
    UsersResponse response =  await _repository.getUsers();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<UsersResponse> get subject => _subject;

}
final bloc = UsersBloc();