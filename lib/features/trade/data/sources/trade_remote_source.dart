import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';
import '../../../../../constants/dio_helper.dart';
import '../../../../../constants/endpoints.dart';
import '../../../../core/storage/auth_local_datasource.dart';
import '../../../../data/app/app_initializer.dart';
import '../../../../data/repository/network_repository.dart';
import '../model/trade_model.dart';

class TradeRemoteSource {
  final Dio dio;
  final AuthLocalDataSource authLocalDataSource;
  final NetworkRepository networkRepository;
  TradeRemoteSource({
    required this.dio,
    required this.authLocalDataSource,
    required this.networkRepository,
  });

  Future<List<TradeModel>> fetchTrade({
    int page = 1,
    int limit = 10,
    String search = '',
  }) async {
    try {
      final login = authLocalDataSource.getLogin();
      final token = authLocalDataSource.getToken();

      if (login == null || token == null) {
        throw Exception('❌ No login or token found in local storage');
      }

      // ✅ Use the NetworkRepository Dio instance (with interceptors)
      final Response response = await networkRepository.state.post(
        '${Endpoints.peanutTrade}',
        data: {
          "login": login,
          "token": token,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((json) => TradeModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Failed to load trades');
    } catch (e) {
      // If token expired, interceptor already handles logout
      throw Exception('Error fetching trades: $e');
    }
  }
}