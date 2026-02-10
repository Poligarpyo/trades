import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/app_bar_gone.dart';
import '../../../authentication/domain/auth/auth_controller.dart';
import '../../domain/entities/trade.dart';
import '../providers/trade_providers.dart';
import '../widgets/card.dart';

class TradeScreen extends ConsumerStatefulWidget {
  const TradeScreen({super.key});

  @override
  ConsumerState<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends ConsumerState<TradeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isWaitingToLoadMore = false;
  Timer? _loadMoreTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (_isWaitingToLoadMore) return;
        if (_loadMoreTimer?.isActive ?? false) return;

        _loadMoreTimer = Timer(const Duration(seconds: 2), () {
          ref
              .read(tradeProvider.notifier)
              .loadMore(search: _searchController.text);
        });
      }
    });
  }

  @override
  void dispose() {
    _loadMoreTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tradeProvider);
    final notifier = ref.watch(tradeProvider.notifier);
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(
                state.error!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text("Retry"),
                onPressed: () => ref.read(tradeProvider.notifier).fetch(limit: 10),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: EmptyAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await notifier.refresh();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Builder(
              builder: (context) {
                if (state.error != null) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 100),
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          state.error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            notifier.refresh();
                          },
                          child: const Text('Retry'),
                        ),
                      ),
                    ],
                  );
                }

                /// 🟡 INITIAL LOADING (no data yet)
                if (state.isLoading && state.trade.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Total Profit: ${notifier.totalProfit.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount:
                            state.trade.length + (state.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.trade.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final trade = state.trade[index];
                          return TradeCard(trade: trade);
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

}
