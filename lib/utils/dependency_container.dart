import 'package:get_it/get_it.dart';
import 'package:safe_surf/data/dns_blocker/dns_proxy_server.dart';
import 'package:safe_surf/repos/dns_blocker/dns_blocker_repo.dart';
import 'package:safe_surf/repos/dns_blocker/i_dns_blocker_repo.dart';
import 'package:safe_surf/usecases/dns_blocker/start_dns_blocking.dart';

final getIt = GetIt.instance;
void initializeDependencies() {
  getIt.registerLazySingleton(() => DnsProxyServer());
  getIt.registerLazySingleton<IDnsBlockerRepo>(
    () => DnsBlockerRepo(getIt<DnsProxyServer>()),
  );
  getIt.registerLazySingleton(() => StartDnsBlocking(getIt<IDnsBlockerRepo>()));
}
