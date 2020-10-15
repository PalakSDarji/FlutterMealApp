import 'package:flutter_meal_app/di/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@InjectableInit()
Future<void> configureInjection(String env) async {
  await $initGetIt(locator, environment: env);
}

final locator = GetIt.instance;

abstract class Env{
  static const dev = 'dev';
  static const prod = 'prod';
}