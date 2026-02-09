 
import '../../domain/entities/trade.dart';
import '../../domain/repositories/trade_repository.dart';
import '../model/trade_model.dart';
import '../sources/trade_remote_source.dart';

class TradeRepositoryImpl implements TradeRepository {
  final TradeRemoteSource remoteDataSource;
  TradeRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<List<Trade>> getTrade({required int limit, String search = ''}) async {
    final models = await remoteDataSource.fetchTrade(limit: limit);
    return models.map((e) => e.toEntity()).toList();
  } 
}
