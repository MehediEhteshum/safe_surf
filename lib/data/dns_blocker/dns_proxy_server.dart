import 'dart:io';
import 'package:dns_client/dns_client.dart';
import 'package:flutter/material.dart';

class DnsProxyServer {
  final int port;
  final DnsClient dnsClient;
  HttpServer? _server;

  DnsProxyServer({this.port = 0}) : dnsClient = DnsOverHttps.google();

  Future<void> start() async {
    _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    debugPrint(
        'DNS Proxy Server listening on ${_server!.address.address}:${_server!.port}');

    await for (HttpRequest request in _server!) {
      _handleRequest(request);
    }
  }

  void _handleRequest(HttpRequest request) async {
    try {
      final query = await _parseDnsQuery(request);
      debugPrint('Received DNS query: $query');
      if (_shouldBlockQuery(query)) {
        debugPrint('Blocking query: $query');
        request.response.write(_buildBlockingDnsResponse());
      } else {
        debugPrint('Forwarding query: $query');
        final response = await dnsClient.lookup(query);
        request.response.write(_buildDnsResponse(response));
      }
    } catch (e) {
      debugPrint('Error handling DNS request: $e');
    } finally {
      await request.response.close();
    }
  }

  Future<String> _parseDnsQuery(HttpRequest request) async {
    final buffer = await request
        .fold<List<int>>([], (prev, element) => prev..addAll(element));
    return String.fromCharCodes(buffer).toLowerCase();
  }

  bool _shouldBlockQuery(String query) {
    return query.contains('youtube') && query.contains('shorts');
  }

  List<int> _buildBlockingDnsResponse() {
    debugPrint('Building blocking DNS response');
    return [
      0,
      0,
      129,
      128,
      0,
      1,
      0,
      1,
      0,
      0,
      0,
      0,
      7,
      98,
      108,
      111,
      99,
      107,
      101,
      100,
      0,
      0,
      1,
      0,
      1,
      192,
      12,
      0,
      1,
      0,
      1,
      0,
      0,
      0,
      60,
      0,
      4,
      0,
      0,
      0,
      0
    ];
  }

  List<int> _buildDnsResponse(List<InternetAddress> addresses) {
    debugPrint('Building DNS response for addresses: $addresses');
    final response = [0, 0, 129, 128, 0, 1, 0, 1, 0, 0, 0, 0];
    response.addAll(addresses.first.rawAddress);
    return response;
  }

  Future<void> stop() async {
    await _server?.close();
    debugPrint('DNS Proxy Server stopped');
  }
}
