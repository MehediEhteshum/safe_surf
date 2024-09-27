import 'package:flutter_vpn/flutter_vpn.dart';
import 'package:safe_surf/repos/dns_blocker/i_dns_blocker_repo.dart';

class ToggleDnsBlocking {
  final IDnsBlockerRepo repository;

  ToggleDnsBlocking(this.repository);

  Future<void> call(bool enable) async {
    if (enable) {
      final int proxyPort = await repository.startDnsProxy();
      await FlutterVpn.connectIkev2EAP(
        server: 'localhost',
        username: 'ytshortsblocker',
        password: 'password',
        name: 'YT Shorts Blocker',
        mtu: 1400,
        port: proxyPort,
      );
    } else {
      await FlutterVpn.disconnect();
      await repository.stopDnsProxy();
    }
  }
}
