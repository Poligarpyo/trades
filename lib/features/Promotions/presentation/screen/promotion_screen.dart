import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/promotion_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PromotionsScreen extends ConsumerWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promotionsAsync = ref.watch(promotionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Promotions")),
      body: promotionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (promotions) {
          // return ListView.builder(
          //   itemCount: promotions.length,
          //   itemBuilder: (context, index) {
          //     final promo = promotions[index];
          //     return Card(
          //       margin: const EdgeInsets.all(8),
          //       child: ListTile(
          //         leading: Image.network(
          //           promo.image,
          //           width: 60,
          //           fit: BoxFit.cover,
          //         ),
          //         title: Text(promo.title),
          //         subtitle: Text(promo.description),
          //         onTap: () async {
          //           final uri = Uri.parse(promo.link);
          //           if (await canLaunchUrl(uri)) {
          //             await launchUrl(uri);
          //           }
          //         },
          //       ),
          //     );
          //   },
          // );
        },
      ),
    );
  }
}
