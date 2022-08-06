import 'package:dio/dio.dart';

import '../model/person.dart';

class Api {
  final Dio _dio;

  Api(this._dio);

  Future<List<dynamic>> getPersons({
    void Function(int count, int total)? progressCallback,
  }) async {
    final response = await _dio.get(
      'list',
      onReceiveProgress: progressCallback,
    );
    final json = response.data;
    final persons = json['persons'] as Map;
    return persons.values
        .expand((element) => element)
        .map((element) => Person.fromJson(element))
        .toList();
  }
}
