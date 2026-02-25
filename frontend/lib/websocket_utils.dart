import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

WebSocketChannel createChannel(String uri) {
  if (kIsWeb) {
    return WebSocketChannel.connect(Uri.parse(uri));
  } else {
    return IOWebSocketChannel.connect(Uri.parse(uri));
  }
}
