import 'package:adminui/repository/User_mockprovider.dart';
import 'package:adminui/models/UsersResponse.dart';
import 'package:adminui/models/BookedDatesResponse.dart';
import 'UsersDataBaseProvider.dart';
import 'package:adminui/models/Match.dart';
import 'package:adminui/models/MatchsResponse.dart';

class UserRepository{
 // UsersMockProvider _apiProvider = UsersMockProvider();
  UsersDBProvider _apiProvider = UsersDBProvider();
  Future<UsersResponse> getUsers() async{
    return _apiProvider.getUsers();
  }
  Future<UsersResponse>  saveMatches  (List<Match> matches)  async {
    return _apiProvider.saveMatches(matches);
  }
  Future<BookedDatesResponse> getMonthStatus(String month) async{
    return _apiProvider.getMonthStatus( month);
  }
  Future<MatchsResponse> getAllMatchs() async{
    return _apiProvider.getAllMatchs( );
  }

}