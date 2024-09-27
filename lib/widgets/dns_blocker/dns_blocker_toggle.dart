import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_surf/repos/dns_blocker/i_dns_blocker_repo.dart';
import 'package:safe_surf/usecases/dns_blocker/toggle_dns_blocking.dart';
import 'package:safe_surf/utils/dependency_container.dart';

class DnsBlockerToggle extends StatelessWidget {
  const DnsBlockerToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<IDnsBlockerRepo>(
      builder: (context, dnsBlockerRepo, child) {
        return Switch(
          value: dnsBlockerRepo.isBlocking,
          onChanged: (value) async {
            final toggleDnsBlocking = getIt<ToggleDnsBlocking>();
            await toggleDnsBlocking(value);
          },
        );
      },
    );
  }
}
