import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketConnect {
  final WebSocketChannel channel;

  WebSocketConnect(this.channel);

  void send(String message)
  {
    channel.sink.add(message);
  }

  void listen(void Function(dynamic) onData)
  {
    channel.stream.listen(onData);
  }

  void close()
  {
    channel.sink.close();
  }

}