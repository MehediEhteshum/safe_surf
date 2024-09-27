import 'package:flutter/material.dart';
import 'package:safe_surf/data/dns_blocker/dns_proxy_server.dart';
import 'package:safe_surf/repos/dns_blocker/i_dns_blocker_repo.dart';

class DnsBlockerRepo extends ChangeNotifier implements IDnsBlockerRepo {
  final DnsProxyServer _dnsProxyServer;
  bool _isBlocking = false;

  DnsBlockerRepo(this._dnsProxyServer);

  @override
  Future<int> startDnsProxy() async {
    await _dnsProxyServer.start();
    _isBlocking = true;
    return _dnsProxyServer.port;
  }

  @override
  Future<void> stopDnsProxy() async {
    await _dnsProxyServer.stop();
    _isBlocking = false;
  }

  @override
  bool get isBlocking => _isBlocking;
}
