import 'package:adminui/models/UsersResponse.dart';

import 'package:adminui/models/User.dart';

class UsersMockProvider {
  final String _endpoint = "https://randomuser.me/api/";


  UsersMockProvider() {
    //BaseOptions options = new BaseOptions(receiveTimeout: 5000, connectTimeout: 10000);
    //  _dio = Dio(options );
    //  _setupLoggingInterceptor();
  }

  Future<UsersResponse>  getUsers()  =>
      //  try {
  //   Response response = await _dio.get(_endpoint);
  Future.delayed(Duration(seconds: 1), () =>  UsersResponse.mock(mockdata()));

  //  } catch (error, stacktrace) {
  //   print("Exception occured: $error stackTrace: $stacktrace");
  //    return UserResponse.withError(_handleError(error));
  // }


  List<User> mockdata()
  {
    List<User> users = [];
    User user = new User( Name: 'John',
      Email: 'jmcfet@bellsouth.net',
      level: 1,
      timesCaptain: 0
    );
    users.add(user) ;
    user = new User( Name: 'ted',
        Email: 'jmcfet@bellsouth.net',
        level: 1,
        timesCaptain: 0
    );
    users.add(user) ;

    user = new User( Name: 'peggysue',
        Email: 'jmcfet@bellsouth.net',
        level: 1,
        timesCaptain: 0
    );
    users.add(user) ;
    user = new User( Name: 'sith',
        Email: 'jmcfet@bellsouth.net',
        level: 1,
        timesCaptain: 0
    );
    users.add(user) ;
    user = new User( Name: 'kenny',
        Email: 'mmmm@bellsouth.net',
        level: 1,
        timesCaptain: 0
    );
    users.add(user) ;

    return users;

  }
}