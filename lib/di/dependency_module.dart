
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
@module
abstract class DependencyModule{

  /*@singleton
  RestService get restService;*/

  @singleton
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();


}