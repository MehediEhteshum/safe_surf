import 'package:flutter/material.dart';
import 'package:flutter_vpn/flutter_vpn.dart';
import 'package:safe_surf/repos/dns_blocker/i_dns_blocker_repo.dart';

class StartDnsBlocking {
  final IDnsBlockerRepo iDnsBlockerRepo;

  StartDnsBlocking(this.iDnsBlockerRepo);

  Future<void> call() async {
    debugPrint('Starting DNS blocking');
    final proxyPort = await iDnsBlockerRepo.startDnsProxy();
    debugPrint('DNS Proxy started on port: $proxyPort');

    try {
      await FlutterVpn.connectIkev2EAP(
        server: 'localhost',
        username: 'ytshortsblocker',
        password: 'password',
        name: 'YT Shorts Blocker',
        mtu: 1400,
        port: proxyPort,
      );
      debugPrint('VPN connected successfully');
    } catch (e) {
      debugPrint('Error connecting to VPN: $e');
      await iDnsBlockerRepo.stopDnsProxy();
      rethrow;
    }
  }
}
