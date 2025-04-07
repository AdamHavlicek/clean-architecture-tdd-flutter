class NetworkCheckAddressOptions {
  final Uri uri;

  final Duration timeout;

  const NetworkCheckAddressOptions({
    required this.uri,
    this.timeout = const Duration(
      seconds: 10,
    ),
  });
}

final ADDRESS_OPTIONS_LIST = [
  NetworkCheckAddressOptions(
    uri: Uri(
      scheme: 'https',
      host: '1.1.1.1',
    ),
  ),
  NetworkCheckAddressOptions(
    uri: Uri(
      scheme: 'https',
      host: '8.8.8.8',
    ),
  ),
];
