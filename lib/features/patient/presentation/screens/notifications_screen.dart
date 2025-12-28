import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:midical_record/l10n/app_localizations.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 3, // Mock data
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(Icons.notifications, color: Theme.of(context).primaryColor),
            ),
            title: Text(l10n.notificationTitle(index + 1)),
            subtitle: Text(l10n.notificationDetail(index + 1)),
            trailing: Text(l10n.hoursAgo(index + 1), style: const TextStyle(color: Colors.grey, fontSize: 12)),
          );
        },
      ),
    );
  }
}
